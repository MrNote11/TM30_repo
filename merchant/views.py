import csv
import os
from threading import Thread

from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank, TrigramSimilarity
from django.core.cache import cache
from django.http import HttpResponse
from rest_framework.exceptions import ValidationError, NotFound
from django.shortcuts import get_object_or_404
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated, IsAdminUser, AllowAny

# from ecommerce.document import ProductDocument
from ecommerce.serializers import ProductSerializer
from account.utils import validate_email
from store.serializers import StoreSerializer
from superadmin.exceptions import raise_serializer_error_msg
from superadmin.serializers import BulkProductUploadSerializerIn
from transaction.models import Transaction
from transaction.serializers import TransactionSerializer
from .merchant_email import merchant_account_creation_email
from .serializers import SellerSerializer, MerchantDashboardOrderProductSerializer, \
    MerchantReturnedProductSerializer, MerchantBannerSerializerOut, MerchantBannerSerializerIn, \
    MerchantProductReviewSerialiazer
from rest_framework.response import Response
from rest_framework.views import APIView
from rest_framework import status, generics
from home.pagination import CustomPagination, CustomViewMorePagination
from .utils import *
from .permissions import IsMerchant
from ecommerce.models import ProductDetail, Product, OrderProduct
from .filters import MerchantOrderProductFilter
import environ

import logging

shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')


env = environ.Env()
environ.Env.read_env(os.path.join('.env'))


class BecomeAMerchantView(APIView):
    permission_classes = [IsAuthenticated]

    """
        Authenticated users are allowed to call this endpoint.
    """

    def post(self, request):
        cache_key = None  # Ensure cache_key is initialized
        try:
            user = request.user
            email = request.data.get("email", None)
            phone_number = request.data.get("phone_number", None)

            # Check for double submission using cache
            cache_key = f"merchant_creation_{user.id}"
            if cache.get(cache_key):
                return Response({"detail": "Request already in progress. Please wait."},
                                status=status.HTTP_429_TOO_MANY_REQUESTS)
            cache.set(cache_key, True, timeout=10)  # Lock for 10 seconds

            # Validate email
            if email and not validate_email(email):
                cache.delete(cache_key)  # Remove the lock
                return Response({"detail": "Invalid email format"}, status=status.HTTP_400_BAD_REQUEST)

            # Validate phone number
            if phone_number and str(phone_number[-10:]).isnumeric():
                phone_number = f"{234}{phone_number[-10:]}"
            else:
                cache.delete(cache_key)
                return Response({"detail": "Invalid phone number"}, status=status.HTTP_400_BAD_REQUEST)

            # Check if the user already has a seller account
            seller = Seller.objects.filter(user=user).first()
            if seller:
                if seller.status in ["approve", "active"]:
                    cache.delete(cache_key)
                    return Response({"detail": "You already have a licensed merchant account."},
                                    status=status.HTTP_400_BAD_REQUEST)

                if seller.status == "declined":
                    # ✅ Instead of rejecting, allow them to reapply
                    success, msg = create_seller(request, user, email, phone_number)
                    if not success:
                        cache.delete(cache_key)
                        return Response({"detail": msg}, status=status.HTTP_400_BAD_REQUEST)

                    # Send merchant account creation email
                    Thread(target=merchant_account_creation_email, args=[email]).start()

                    cache.delete(cache_key)
                    return Response({"detail": f"{msg}."}, status=status.HTTP_201_CREATED)

            # ✅ Proceed with merchant creation if no seller record exists
            success, msg = create_seller(request, user, email, phone_number)
            if not success:
                cache.delete(cache_key)
                return Response({"detail": f"{msg}"}, status=status.HTTP_400_BAD_REQUEST)

            # Send merchant account creation email in a separate thread
            Thread(target=merchant_account_creation_email, args=[email]).start()

            # Remove the cache lock after successful processing
            cache.delete(cache_key)
            return Response({"detail": f"{msg}."}, status=status.HTTP_201_CREATED)

        except Exception as err:
            if cache_key:  # Ensure cache_key is valid before trying to delete the cache
                cache.delete(cache_key)  # Ensure the lock is cleared

            merchant_logger.error(f"Error in BecomeAMerchantView: {str(err)}")
            admin_logger.error(f"Error in BecomeAMerchantView: {str(err)}")

            return Response({"detail": f"{err}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MerchantView(APIView, CustomPagination):
    permission_classes = [IsMerchant]

    def get(self, request):
        item = get_object_or_404(Seller, user=request.user)
        serializer = SellerSerializer(item)
        return Response(serializer.data)

    def put(self, request):
        seller = get_object_or_404(Seller, user=request.user)
        phone_no = request.data.get("phone_number")
        if phone_no:
            phone_number = f"{234}{phone_no[-10:]}"
            seller.phone_number = phone_number
        seller.address = request.data.get("address", seller.address)
        seller.town = request.data.get("town", seller.town)
        seller.town_id = request.data.get("town_id", seller.town_id)
        seller.city = request.data.get("city", seller.city)
        seller.state = request.data.get("state", seller.state)
        seller.longitude = request.data.get("longitude", seller.longitude)
        seller.latitude = request.data.get("latitude", seller.latitude)
        seller.status = "inactive"
        seller.save()
        # Set stores to pending
        Store.objects.filter(seller=seller).update(is_active=False)
        return Response(SellerSerializer(seller, context={"request": request}).data)


class MerchantDashboardView(APIView):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request):
        try:
            seller = Seller.objects.get(user=request.user)

            # Check the status of the seller
            if seller.status == "pending":
                return Response({
                    "detail": "Your account is still pending approval. You can only edit your profile."
                }, status=status.HTTP_200_OK)
            elif seller.status == "declined":
                return Response({
                    "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
                }, status=status.HTTP_403_FORBIDDEN)
            elif seller.status in ["approve", "active"]:
                # Return full dashboard access
                store = Store.objects.filter(seller__user=request.user).last()
                return Response({"detail": get_dashboard_data(store, request),
                                 "message": "Welcome to your merchant dashboard."}, status=status.HTTP_200_OK)

        except Exception as err:
            merchant_logger.error(f"Error in MerchantDashboardView: {str(err)}")
            admin_logger.error(f"Error in MerchantDashboardView: {str(err)}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class MerchantStoreView(APIView, CustomViewMorePagination):
    permission_classes = [AllowAny]  # Ensure the user is authenticated

    def get(self, request, merchant_code):
        try:
            # Decode the merchant code to get the user ID
            user_id = Seller.decode_merchant_code(merchant_code)

            store = get_object_or_404(Store, seller__user__id=user_id)

            # Calculate review statistics using a custom serializer
            total_reviews = ProductReview.objects.filter(product__store__seller=store.seller).count()
            positive_reviews = ProductReview.objects.filter(product__store__seller=store.seller, rating__gte=3).count()
            positive_percentage = (positive_reviews / total_reviews * 100) if total_reviews > 0 else 0

            # Filter active products by store
            products = Product.objects.filter(status='active', store__seller=store.seller, store__is_active=True)

            query = self.request.GET.get("search_query", "").strip()

            response_data = dict()
            if query:
                # Step 1: Full-text search
                search_vector = SearchVector('name', 'description', 'tags', 'category__name')
                search_query = SearchQuery(query)
                search_products = Product.objects.annotate(
                    rank=SearchRank(search_vector, search_query)
                )
                search = search_products.filter(rank__gte=0.1, status='active', store__seller=store.seller,
                                                store__is_active=True).order_by('-rank', '-sale_count', '-view_count')

                # Step 2: Fallback to Trigram Similarity if full-text search returns no results
                if not search.exists():
                    search_products = Product.objects.annotate(
                        similarity=TrigramSimilarity('name', query) +
                                   TrigramSimilarity('description', query) +
                                   TrigramSimilarity('tags', query) +
                                   TrigramSimilarity('category__name', query)
                    )
                search = search_products.filter(similarity__gt=0.1, status='active', store__seller=store.seller,
                                                store__is_active=True).order_by(
                    '-similarity', '-sale_count', '-view_count').distinct()

                paginated_search_products = self.paginate_queryset(search, request)
                serializer = ProductSerializer(paginated_search_products, many=True, context={"request": request}).data
                paginated_response = self.get_paginated_response(serializer).data

                # Filter active products by store
                response_data["searched_products"] = paginated_response

                response_data["total_count"] = self.page.paginator.count
                response_data["page_size"] = len(paginated_response)
                response_data["remaining_items"] = max(0, self.page.paginator.count - self.page.end_index())
                response_data["status"] = True if max(0, self.page.paginator.count - self.page.end_index()) > 0 else False

                return Response(response_data, status=status.HTTP_200_OK)

            # Fetch 3 new arrival products based on created_on date
            new_arrivals = products.order_by('-created_on')[:6]

            # Exclude new arrivals from other products and order by popularity (sale_count)
            other_products = products.exclude(id__in=new_arrivals.values_list('id', flat=True)).order_by('-sale_count')

            # Paginate the other products
            paginated_products = self.paginate_queryset(other_products, request)
            serialized_products = ProductSerializer(paginated_products, many=True, context={"request": request}).data

            # Prepare the paginated response
            paginated_response = self.get_paginated_response(serialized_products).data

            # Prepare final response data
            response_data = {
                'total_reviews': total_reviews,
                'positive_percentage': round(positive_percentage, 2),
                'total_followers': store.seller.follower.count(),
                'is_following': request.user in store.seller.follower.all(),
                # Search results
                'new_arrivals': ProductSerializer(new_arrivals, many=True, context={"request": request}).data,
                # New arrivals (6 products)
                'other_products': paginated_response,  # Paginated other products

                "total_count": self.page.paginator.count,
                "page_size": len(paginated_products),
                "remaining_items": max(0, self.page.paginator.count - self.page.end_index()),
                "paginated_status": True if max(0, self.page.paginator.count - self.page.end_index()) > 0 else False,

            }

            return Response(response_data, status=status.HTTP_200_OK)

        except Store.DoesNotExist:
            return Response({'error': 'Store not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            merchant_logger.error(f"Error in MerchantStoreView: {str(e)}")
            admin_logger.error(f"Error in MerchantStoreView: {str(e)}")
            return Response({'error': 'An error occurred: ' + str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class MerchantStoreSearchView(APIView):
    permission_classes = []

    def get(self, request, merchant_code):
        try:
            # Decode the merchant code to get the user ID
            user_id = Seller.decode_merchant_code(merchant_code)

            store = get_object_or_404(Store, seller__user__id=user_id)
            query = self.request.GET.get("query", "").strip()

            # Start with a base queryset
            search = Product.objects.filter(status='active', store__is_active=True, store__seller=store.seller)

            response_data = {}

            if query:
                # Step 1: Full-text search
                search_vector = SearchVector('name', 'description', 'tags', 'category__name')
                search_query = SearchQuery(query)
                search_products = Product.objects.annotate(
                    rank=SearchRank(search_vector, search_query)
                )
                search = search_products.filter(rank__gte=0.1).order_by('-rank', '-sale_count', '-view_count')

                # Step 2: Fallback to Trigram Similarity if full-text search returns no results
                if not search.exists():
                    search_products = Product.objects.annotate(
                        similarity=TrigramSimilarity('name', query) +
                                   TrigramSimilarity('description', query) +
                                   TrigramSimilarity('tags', query) +
                                   TrigramSimilarity('category__name', query)
                    )
                search = search_products.filter(similarity__gt=0.1).order_by(
                    '-similarity', '-sale_count', '-view_count').distinct()

            # Order by newest products
            search = search.order_by('-sale_count', "-view_count", '-updated_on').distinct()

            serializer = ProductSerializer(search, many=True, context={"request": request}).data

            # Filter active products by store
            response_data["searched_products"] = serializer

            return Response(response_data, status=status.HTTP_200_OK)

        except Store.DoesNotExist:
            return Response({'error': 'Store not found.'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            return Response({'error': 'An error occurred: ' + str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class FollowUnfollowAPIView(APIView):
    permission_classes = [IsAuthenticated]
    """
    API for following/unfollowing a store based on the store owner.
    The store model has a foreign key relationship to the seller model,
    and the seller has a foreign key relationship to the user model.
    """

    def post(self, request, merchant_code, *args, **kwargs):
        from django.db import transaction

        try:
            # Decode the merchant code to get the user ID
            user_id = Seller.decode_merchant_code(merchant_code)

            store = get_object_or_404(Store, seller__user__id=user_id)

            # Fetch seller by store_owner (user)
            # seller = get_object_or_404(Seller, user__username=store_owner)
            updated = False
            following = False

            if store.seller.status not in ["approve", "active"]:
                return Response({"detail": "Merchant account is not active"}, status=status.HTTP_400_BAD_REQUEST)

            # Use an atomic transaction to ensure integrity
            with transaction.atomic():
                if request.user in store.seller.follower.all():
                    store.seller.follower.remove(request.user)
                    request.user.profile.following.remove(store.seller)
                    message = "Successfully unfollowed the seller."
                else:
                    store.seller.follower.add(request.user)
                    request.user.profile.following.add(store.seller)
                    updated = True
                    following = True

                    message = "Successfully followed the seller."

            return Response({'message': message, 'follower_count': store.seller.follower.count(),
                             'updated': updated,
                             'following': following,
                             'store_owner': store.name,
                             },
                            status=status.HTTP_200_OK)

        except Store.DoesNotExist:
            return Response({'error': 'Seller not found'}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            import traceback
            merchant_logger.error(f"Error in FollowUnfollowAPIView POST: {str(e)}")
            admin_logger.error(f"Error in FollowUnfollowAPIView POST: {str(e)}")
            return Response({'error': str(e), "error_traceback": f"{traceback.format_exc()}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# Added Search by product_name and category(filter).
class ProductAPIView(APIView, CustomPagination):

    def get(self, request, pk=None):
        try:
            product_name, category = request.GET.get("product_name", None), request.GET.get("category", None)
            seller = Seller.objects.get(user=request.user)
            query = Q(store__seller=seller)

            if pk:
                serializer = ProductSerializer(Product.objects.get(store__seller=seller, id=pk),
                                               context={"request": request}).data
            else:
                if product_name:
                    query &= Q(name__icontains=product_name)

                if category:
                    query &= Q(category__name__icontains=category)

                product_detail_query_set = Product.objects.filter(query).order_by('-id')
                paginated_query_set = self.paginate_queryset(product_detail_query_set, request)
                serialized = ProductSerializer(paginated_query_set, many=True, context={"request": request}).data
                serializer = self.get_paginated_response(serialized).data
            return Response(serializer)
        except (Exception,) as err:
            merchant_logger.error(f"Error in get ProductAPIView: {str(err)}")
            admin_logger.error(f"Error in get ProductAPIView: {str(err)}")

            return Response({"detail": str(err)}, status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        try:
            # Check if the user is a merchant
            seller = Seller.objects.filter(user=request.user).first()
            if not seller:
                return Response(
                    {"detail": "Only merchant accounts can add products."},
                    status=status.HTTP_400_BAD_REQUEST,
                )

            # Check if the seller is approved
            if seller.status not in ["approve", "active"]:
                return Response(
                    {"detail": "Only approved sellers can add products."},
                    status=status.HTTP_403_FORBIDDEN,  # Forbidden status code
                )

            seller = Seller.objects.get(user=request.user)
            success, detail, product = create_product(request, seller)
            if success is False:
                return Response({"detail": detail}, status=status.HTTP_400_BAD_REQUEST)
            return Response(
                {"detail": detail, "product": ProductSerializer(product, context={"request": request}).data})
        except Exception as err:
            merchant_logger.error(f"Error in ProductAPIView: {err}")
            admin_logger.error(f"Error in ProductAPIView: {err}")
            return Response({"detail": "An error has occurred", "error": str(err)}, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            store = Store.objects.get(seller__user=request.user)
            product = Product.objects.get(id=pk, store=store)
            success, query = update_product(request, product)

            if not success:
                return Response({"detail": query}, status=status.HTTP_400_BAD_REQUEST)

            return Response({
                "detail": "Product updated successfully",
                "product": ProductSerializer(query, context={"request": request}).data
            })

        except Store.DoesNotExist:
            return Response({"detail": "Store not found."}, status=status.HTTP_404_NOT_FOUND)

        except Product.DoesNotExist:
            return Response({"detail": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

        except Exception as e:
            merchant_logger.error(f"Error in put ProductAPIView: {str(e)}")
            admin_logger.error(f"Error in put ProductAPIView: {str(e)}")

            return Response({"detail": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# Haven't written this "Ashavin said it should be handled by the Admin"
class MerchantAddBannerView(APIView):
    permission_classes = [IsAuthenticated, IsMerchant]

    def post(self, request):
        try:
            # Get image from the F.E.
            # Process Image (Banner): Must be a certain size.
            #
            return Response({"detail": "..."})
        except (Exception,) as err:
            return Response({"detail": str(err)}, status=status.HTTP_400_BAD_REQUEST)


class MerchantOrderProductsView(generics.ListAPIView):
    """
        filter_backends: used to specify Django Default FilterSet which creates a FilterSet based on 'filterset_fields'.
        filterset_class: Used to pass in your written customized FilterSet class, don't use 'filterset_fields' with it.
        filterset_fields: Used to specify the field name to filter against in the Model.

        Note: The DjangoFilterBackend is not neccessary in the 'filter_backends' if we already passed in our custom
            FilterSet in filter_class.
    """
    permission_classes = [IsAuthenticated, IsMerchant]
    pagination_class = CustomPagination
    serializer_class = MerchantDashboardOrderProductSerializer
    # filter_backends = [filters.DjangoFilterBackend]
    filterset_class = MerchantOrderProductFilter

    def get_queryset(self):
        user = self.request.user

        # Check if the user has a store
        store = Store.objects.filter(seller__user=user).first()
        if not store:
            raise ValidationError({'detail': f"No Store matches the authenticated user {user.username}."})

        query = Q(product_detail__product__store=store)

        start_date = self.request.GET.get("date_from", None)
        end_date = self.request.GET.get("date_to", None)
        status_ = self.request.GET.get("status", None)

        if start_date and end_date:
            date_field_mapping = {
                "cancelled": "cancelled_on",
                "paid": "payment_on",
                "delivered": "delivered_on",
                "returned": "returned_on",
                "processed": "packed_on",
                "shipped": "shipped_on",
                "refunded": "refunded_on",
            }
            date_field = date_field_mapping.get(status_, "created_on")
            query &= Q(**{f"{date_field}__date__range": [start_date, end_date]})

        queryset = OrderProduct.objects.filter(query).order_by('-id')
        return queryset


class DownloadOrderReport(APIView):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request):
        start_date = request.GET.get("date_from")
        end_date = request.GET.get("date_to")

        seller = Seller.objects.filter(user=request.user).first()
        if seller.status == "declined":
            return Response({
                "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
            }, status=status.HTTP_403_FORBIDDEN)

        if not (start_date and end_date):
            raise ValidationError({'detail': "Expected: start date and end date for filter"})

        queryset = \
            OrderProduct.objects.filter(product_detail__product__store__seller__user=self.request.user,
                                        created_on__range=[start_date, end_date]).order_by('-id')

        if not queryset:
            return Response({"detail": "Cannot download empty report"}, status=status.HTTP_400_BAD_REQUEST)

        fields = ['S/N', 'PRODUCT_NAME', 'ORDER_ID', 'CUSTOMER_NAME', 'TRACKING_ID', 'NO_OF_UNITS', 'DATE', 'STATUS']

        file_name = f"order_report_{start_date}_to_{end_date}.csv"
        response = HttpResponse(content_type="text/csv",
                                headers={"Content-Disposition": f'attachment; filename={file_name}'})

        writer = csv.DictWriter(response, fieldnames=fields)
        writer.writeheader()

        num = 0
        for item in queryset:
            num += 1
            data = dict()
            data["S/N"] = num
            data["PRODUCT_NAME"] = item.product_detail.product.name
            data["ORDER_ID"] = item.order.id
            data["CUSTOMER_NAME"] = item.order.customer.get_full_name()
            data["TRACKING_ID"] = item.tracking_id
            data["NO_OF_UNITS"] = item.quantity
            data["DATE"] = item.created_on
            data["STATUS"] = item.status
            writer.writerow(data)

        return response


# Completed [Filter is pending ...]
class MerchantLowAndOutOfStockView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request):
        try:
            stock_type = request.GET.get("stock_type", None)

            seller = Seller.objects.filter(user=request.user).first()
            if seller.status == "declined":
                return Response({
                    "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
                }, status=status.HTTP_403_FORBIDDEN)

            # filter_by_date_from, filter_by_date_to = request.GET.get("date_from", None), request.GET.get("date_to", None)
            # filter_by_status = request.GET.get("status", None)
            # category_id = request.GET.get("category_id", None)

            if stock_type is None:
                return Response({"detail": f"Stock Type is required."}, status=status.HTTP_400_BAD_REQUEST)

            store, query_set = Store.objects.get(seller__user=request.user), None
            if stock_type in ["low_in_stock", "low"]:
                query_set = ProductDetail.objects.filter(product__store=store,
                                                         low_stock_threshold__gt=F('stock'), stock__gte=1).order_by(
                    '-id')
            elif stock_type in ["out_of_stock", "out"]:
                query_set = ProductDetail.objects.filter(product__store=store, stock__lte=0).order_by('-id')
            else:
                return Response({"detail": f"Invalid stock type value passed."}, status=status.HTTP_400_BAD_REQUEST)

            paginated_query_set = self.paginate_queryset(query_set, request)
            serialized_data = ProductLowAndOutOffStockSerializer(paginated_query_set, many=True,
                                                                 context={"request": request}).data
            response = self.get_paginated_response(serialized_data).data

            return Response({"detail": response})
        except (Exception, TypeError) as err:
            merchant_logger.error(f"Error in MerchantLowAndOutOfStockView: {str(err)}")
            admin_logger.error(f"Error in MerchantLowAndOutOfStockView: {str(err)}")

            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


# Completed.
class MerchantReturnsAndRejectView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request):
        try:
            seller = Seller.objects.filter(user=request.user).first()
            if seller.status == "declined":
                return Response({
                    "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
                }, status=status.HTTP_403_FORBIDDEN)

            # Filter all ReturnedProduct where this Merchant is the owner of the Store.
            query_set = ReturnedProduct.objects.filter(
                product__product_detail__product__store__seller__user=request.user,
                status="approved").order_by("-id")

            paginated_query_set = self.paginate_queryset(query_set, request)
            serialized_data = MerchantReturnedProductSerializer(paginated_query_set, many=True,
                                                                context={"request": request}).data
            response = self.get_paginated_response(serialized_data).data
            return Response({"detail": response})
        except (Exception,) as err:
            merchant_logger.error(f"Error in MerchantReturnsAndRejectView: {str(err)}")
            admin_logger.error(f"Error in MerchantReturnsAndRejectView: {str(err)}")

            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class MerchantTransactionView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request):
        try:
            seller = Seller.objects.filter(user=request.user).first()
            if seller.status == "declined":
                return Response({
                    "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
                }, status=status.HTTP_403_FORBIDDEN)

            query = request.GET.get("query", None)  # filter by, product name, customer name ...
            q_status = request.GET.get("status", None)  # filter by, successful cancel ...
            if query is not None:
                # How would i get all Transactions related to this Current Logged in Merchant ?
                transactions = Transaction.objects.filter()
            return Response({"detail": f""})
        except (Exception,) as err:
            merchant_logger.error(f"Error in MerchantTransactionView: {str(err)}")
            admin_logger.error(f"Error in MerchantTransactionView: {str(err)}")

            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class ProductImageView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        max_file_size = 10 * 1024 * 1024  # 10 MB

        try:
            images = request.FILES.getlist('image')  # Expecting key 'image'

            if not images:
                return Response({"detail": "No images provided."}, status=status.HTTP_400_BAD_REQUEST)

            resized_images = []
            for uploaded_image in images:
                # Check file size first
                # if uploaded_image.size > max_file_size:
                #     return Response(
                #         {"detail": "The uploaded file is too large. Maximum allowed size is 10MB."},
                #         status=status.HTTP_400_BAD_REQUEST
                #     )

                resized_image = resize_and_save_image(uploaded_image, 200, 200)
                if not resized_image:
                    continue  # Skip problematic images, log them

                img = Image.objects.create(image=resized_image)
                resized_images.append({
                    "image_id": img.id,
                    "image_url": request.build_absolute_uri(img.image.url)
                })

            if not resized_images:
                return Response({"detail": "No valid images were uploaded."}, status=status.HTTP_400_BAD_REQUEST)

            return Response({"detail": "Images uploaded successfully", "images": resized_images})

        except Exception as ex:
            import traceback
            merchant_logger.error(f"Error in ProductImageView: Error in image upload: {traceback.format_exc()}")
            admin_logger.error(f"Error in ProductImageView: Error in image upload: {traceback.format_exc()}")
            return Response({"detail": str(ex),
                             "error": f"{traceback.format_exc()}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request, pk):
        if not Image.objects.filter(id=pk).exists():
            return Response({'detail': 'Image does not exist'}, status=status.HTTP_400_BAD_REQUEST)

        Image.objects.get(id=pk).delete()
        return Response({'detail': 'Image deleted successfully'})


class MerchantTransactionAPIView(APIView, CustomPagination):
    def get(self, request, pk=None):
        merchant = Seller.objects.get(user=request.user)
        store = Store.objects.get(seller=merchant)
        date_from = request.GET.get("date_from")
        date_to = request.GET.get("date_to")
        search = request.GET.get("search")
        status = request.GET.get("status")

        if merchant.status == "declined":
            return Response({
                "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
            }, status=status.HTTP_403_FORBIDDEN)

        if pk:
            serializer = TransactionSerializer(
                Transaction.objects.get(id=pk, order__orderproduct__product_detail__product__store=store
                                        ), context={"merchant": merchant}).data
        else:
            query = Q(order__orderproduct__product_detail__product__store=store)
            if search:
                query &= Q(order__orderproduct__product_detail__product__name=search) | \
                         Q(order__orderproduct__product_detail__product__category__name=search) | \
                         Q(order__customer__user__first_name=search) | Q(order__customer__user__last_name=search)
            if status:
                query &= Q(status=status)
            if date_from and date_to:
                query &= Q(created_on__range=[date_from, date_to])

            queryset = self.paginate_queryset(Transaction.objects.filter(query), request)
            data = TransactionSerializer(queryset, many=True, context={"merchant": merchant}).data
            serializer = self.get_paginated_response(data).data

        return Response(serializer)


class ListMerchantBannerAPIView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated & (IsAdminUser | IsMerchant)]

    def get(self, request):
        if request.user.is_staff:
            queryset = self.paginate_queryset(MerchantBanner.objects.all().order_by("-id"), request)
            serializer = MerchantBannerSerializerOut(queryset, many=True, context={"request": request}).data
            return Response(self.get_paginated_response(serializer).data)
        seller = get_object_or_404(Seller, user=self.request.user)

        if seller.status == "declined":
            return Response({
                "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
            }, status=status.HTTP_403_FORBIDDEN)

        return Response(MerchantBannerSerializerOut(MerchantBanner.objects.filter(seller=seller).last(),
                                                    context={"request": request}).data)


class MerchantBannerCreateAPIView(generics.CreateAPIView):
    permission_classes = [IsAuthenticated & (IsAdminUser | IsMerchant)]
    serializer_class = MerchantBannerSerializerOut

    def create(self, request, *args, **kwargs):
        # try:
        # Image processor implementation
        image = request.data.getlist('image')[0]
        # success, msg = utils.image_processor(8, image)
        # if not success:
        #     return Response({"detail": f"{msg}"}, status=status.HTTP_400_BAD_REQUEST)
        # Implementation ends here

        serializer = MerchantBannerSerializerIn(data=request.data, context=self.get_serializer_context())
        serializer.is_valid() or raise_serializer_error_msg(errors=serializer.errors)
        serializer = serializer.save()
        return Response({"detail": "Banner added successfully", "data": serializer})
    # except (Exception, ) as err:
    #     return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class MerchantBannerRetrieveUpdateAPIView(generics.RetrieveUpdateDestroyAPIView):
    permission_classes = [IsAuthenticated & (IsAdminUser | IsMerchant)]
    serializer_class = MerchantBannerSerializerOut
    lookup_field = "id"

    def get_queryset(self):
        if self.request.user.is_staff:
            return get_object_or_404(MerchantBanner, id=self.kwargs.get("id"))
        return MerchantBanner.objects.get(id=self.kwargs.get("id"), seller__user=self.request.user)

    def update(self, request, *args, **kwargs):
        serializer = MerchantBannerSerializerIn(data=request.data, instance=self.kwargs.get("id"),
                                                context=self.get_serializer_context())
        serializer.is_valid() or raise_serializer_error_msg(errors=serializer.errors)
        serializer.save()
        return Response({"detail": "Banner updated successfully", "data": serializer})


class ProductImageAPIView(APIView):
    def post(self, request):
        try:
            image = request.data.get('image')
            # success, msg = utils.image_processor(2, image=image)
            #
            # if not success:
            #     return Response({"detail": f"{msg}"}, status=status.HTTP_400_BAD_REQUEST)

            product_image = Image.objects.create(image=image)

            return Response({"detail": "Image has been uploaded successfully", "image_id": product_image.id,
                             "image_url": product_image.image.url})
        except Exception as ex:
            return Response(
                {"detail": "An error occurred. Please try again", "error": str(ex)},
                status=status.HTTP_400_BAD_REQUEST)

    def delete(self, request, pk):
        if not Image.objects.filter(id=pk).exists():
            return Response({'detail': 'Image does not exist'}, status=status.HTTP_400_BAD_REQUEST)

        Image.objects.get(id=pk).delete()
        return Response({'detail': 'Image deleted successfully'})


class MerchantProductReviewsView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated, IsMerchant]

    def get(self, request, pk=None):
        try:
            seller = Seller.objects.filter(user=request.user).first()
            if seller.status == "declined":
                return Response({
                    "detail": "Your account was declined. Please re-sign up as a new merchant, or contact administrator."
                }, status=status.HTTP_403_FORBIDDEN)

            merchant_store = Store.objects.get(seller__user=request.user)
            if pk:
                reviews = ProductReview.objects.get(id=pk, product__store=merchant_store)
                data = MerchantProductReviewSerialiazer(reviews, context={"request": request}).data
                return Response({"detail": data})

            if pk is None:
                reviews = ProductReview.objects.filter(product__store=merchant_store).order_by("-id")
                queryset = self.paginate_queryset(reviews, request)
                data = MerchantProductReviewSerialiazer(queryset, context={"request": request}, many=True).data
                serializer = self.get_paginated_response(data).data

                return Response({"detail": serializer})
        except (Exception,) as err:
            merchant_logger.error(f"Error in MerchantProductReviewsView: {str(err)}")
            admin_logger.error(f"Error in MerchantProductReviewsView: {str(err)}")

            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class BulkProductUpload(APIView):

    def post(self, request):
        serializer = BulkProductUploadSerializerIn(data=request.data, context={"request": request})
        serializer.is_valid() or raise_serializer_error_msg(errors=serializer.errors)
        response = serializer.save()
        return Response({"detail": "File uploaded successfully", "data": response})
