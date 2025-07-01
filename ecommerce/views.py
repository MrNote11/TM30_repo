import json
import uuid
from datetime import datetime, date, timedelta
from decimal import Decimal
from random import shuffle

import requests
from django.conf import settings
from django.contrib.postgres.search import SearchVector, SearchQuery, SearchRank, TrigramSimilarity
from django.core.exceptions import ObjectDoesNotExist, ValidationError, MultipleObjectsReturned
from django.db import DatabaseError, transaction
from django.db.models import Q, Sum, Prefetch, F
from django.core.cache import cache
from django.http import Http404
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils.text import slugify
from django_filters.rest_framework import DjangoFilterBackend
from rest_framework.filters import SearchFilter
from rest_framework.pagination import PageNumberPagination
from rest_framework.permissions import IsAuthenticated, AllowAny, IsAuthenticatedOrReadOnly
from rest_framework.response import Response
from rest_framework import status, generics
from rest_framework.views import APIView
from django.utils import timezone
from account.models import Profile, Address
from account.serializers import ProfileSerializer
from account.utils import get_wallet_info
from home.utils import get_previous_date
from merchant.models import Seller
from module.apis import call_name_enquiry
from module.payarena_service import PayArenaServices
from store.models import Store
from store.serializers import CartSerializer, StoreSerializer, StoreProductSerializer, ProductReviewSerializer, \
    CartUpdateSerializer, CartProductSerializer
from superadmin.exceptions import raise_serializer_error_msg
from superadmin.serializers import BannerSerializer
from superadmin.utils import perform_banner_filter
from transaction.models import Transaction
from .cron import remove_redundant_cart_cron, retry_order_booking
# from .document import ProductDocument
from .filters import ProductFilter
from .serializers import ProductSerializer, CategoriesSerializer, MallDealSerializer, ProductWishlistSerializer, \
    OrderSerializer, ReturnedProductSerializer, OrderProductSerializer, \
    ProductReviewSerializerOut, ProductReviewSerializerIn, MobileCategorySerializer, ReturnReasonSerializer, \
    DailyDealSerializer, ProductTypeSerializer, SubCategorySerializer

from .models import ProductCategory, Product, ProductDetail, Cart, CartProduct, Promo, ProductWishlist, Order, \
    OrderProduct, ReturnReason, ReturnedProduct, ReturnProductImage, ProductReview, DailyDeal, ProductType
from home.pagination import CustomPagination, CustomViewMorePagination

from .utils import check_cart, perform_operation, top_weekly_products, top_monthly_categories, \
    validate_product_in_cart, get_shipping_rate, order_payment, add_order_product, perform_order_cancellation, \
    perform_order_pickup, perform_order_tracking, create_or_update_cart_product

from django.core.paginator import Paginator
# Create your views here.
from .utils import sorted_queryset
from random import sample
import logging

buyer_logger = logging.getLogger('buyer')
shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')

cache_timeout = settings.CACHE_TIMEOUT


class MallLandPageView(APIView, CustomViewMorePagination):
    permission_classes = [AllowAny]

    def get(self, request):
        report_type = request.GET.get("request_type")
        try:
            response_container = {}
            queried_product_ids = set()  # Track ids of products already queried
            buyer_logger.info(queried_product_ids)
            admin_logger.info(queried_product_ids)

            def fetch_and_cache(queryset, key, limit=None):
                """Fetch data from cache or query and cache the result."""
                nonlocal queried_product_ids
                cached_data = cache.get(key)

                if cached_data is None:
                    # Apply all filtering and slicing before evaluation
                    if limit:
                        products = queryset.filter(status="active", store__is_active=True)[:limit]
                    else:
                        products = queryset.filter(status="active", store__is_active=True)

                    if products.exists():  # Ensure products exist
                        product_ids = set(products.values_list('id', flat=True))
                        queried_product_ids.update(product_ids)

                        # Serialize data
                        serialized_data = ProductSerializer(products, many=True, context={'request': request}).data
                        # Cache the result
                        cache.set(key, serialized_data, timeout=cache_timeout)
                        return serialized_data
                    else:
                        buyer_logger.error(f"Error in MallLandPageView: No products found for cache key: {key}")
                        admin_logger.error(f"Error in MallLandPageView: No products found for cache key: {key}")
                        return []
                else:
                    # Extract IDs from cached data to add to queried_product_ids
                    cached_ids = {item['id'] for item in cached_data}
                    queried_product_ids.update(cached_ids)
                    return cached_data

            # Caching keys for different product types
            cache_keys = {
                "best_sellers": "best_sellers_key",
                "fresh_finds": "fresh_finds_key",
                "choice_products": "choice_products_key",
                "seasonal_picks": "seasonal_picks_key",

                "price_from_999": "price_from_999_key",
                "free_shipping": "free_shipping_key",

                "price_from_4999": "price_from_4999_key",
                "first_come_50_first": "first_come_50_first_key",
                "price_from_7500": "price_from_7500_key",

                "first_come_50_second": "first_come_50_second_key",
                "price_from_5999": "price_from_5999_key",
                "free_shipping_second": "free_shipping_second_key",

                "super_deals": "super_deals_key",
                "quality_picks": "quality_picks_key",
                "categories": "categories_key",
                # "banner": "banner_key",
                "more_to_love": "more_to_love_key",

                "header_banner": "header_banner_key",
            }

            # Handle different request types
            if report_type == "best_sellers":
                best_sellers = fetch_and_cache(
                    Product.objects.order_by('-sale_count'),
                    cache_keys["best_sellers"],
                    limit=2  # Apply limit here
                )
                response_container["best_sellers"] = best_sellers

            elif report_type == "fresh_finds":
                fresh_finds = fetch_and_cache(
                    Product.objects.filter(created_on__gte=timezone.now() - timedelta(days=2)).order_by('-id'),
                    cache_keys["fresh_finds"],
                    limit=2
                )
                response_container["fresh_finds"] = fresh_finds

            elif report_type == "choice_products":
                choice_products = fetch_and_cache(
                    Product.objects.filter(choice=True).order_by('-id'),
                    cache_keys["choice_products"],
                    limit=2
                )
                response_container["choice_products"] = choice_products

            elif report_type == "seasonal_picks":
                seasonal_picks = fetch_and_cache(
                    Product.objects.filter(seasonal_pick=True).order_by('-id'),
                    cache_keys["seasonal_picks"],
                    limit=2
                )
                response_container["seasonal_picks"] = seasonal_picks

            elif report_type == "price_from_999":
                price_from_999 = fetch_and_cache(
                    Product.objects.filter(
                        Q(productdetail__price__gte=999.99) & Q(free_shipping=True)
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["price_from_999"],
                    limit=7
                )
                response_container["price_from_999"] = price_from_999

            elif report_type == "free_shipping":
                free_shipping = fetch_and_cache(
                    Product.objects.filter(free_shipping=True).order_by('-id'),
                    cache_keys["free_shipping"],
                    limit=3
                )
                response_container["free_shipping"] = free_shipping

            elif report_type == "price_from_4999":
                price_from_4999 = fetch_and_cache(
                    Product.objects.filter(
                        Q(productdetail__price__gte=4999.99) & Q(free_shipping=True)
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["price_from_4999"],
                    limit=3
                )
                response_container["price_from_4999"] = price_from_4999

            elif report_type == "first_come_50_first":
                first_come_50_first = fetch_and_cache(
                    Product.objects.filter(
                        productdetail__discount=F('productdetail__price') / 2
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["first_come_50_first"],
                    limit=3
                )
                response_container["first_come_50_first"] = first_come_50_first

            elif report_type == "price_from_7500":
                price_from_7500 = fetch_and_cache(
                    Product.objects.filter(
                        Q(productdetail__price__gte=7500.00) & Q(free_shipping=True)
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["price_from_7500"],
                    limit=10
                )
                response_container["price_from_7500"] = price_from_7500

            elif report_type == "first_come_50_second":
                first_come_50_second = fetch_and_cache(
                    Product.objects.filter(
                        productdetail__discount=F('productdetail__price') / 2
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["first_come_50_second"],
                    limit=3
                )
                response_container["first_come_50_second"] = first_come_50_second

            elif report_type == "price_from_5999":
                price_from_5999 = fetch_and_cache(
                    Product.objects.filter(
                        Q(productdetail__price__gte=5999.99) & Q(free_shipping=True)
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["price_from_5999"],
                    limit=3
                )
                response_container["price_from_5999"] = price_from_5999

            elif report_type == "free_shipping_second":
                free_shipping_second = fetch_and_cache(
                    Product.objects.filter(free_shipping=True).order_by('id'),
                    cache_keys["free_shipping_second"],
                    limit=3
                )
                response_container["free_shipping_second"] = free_shipping_second

            elif report_type == "super_deals":
                super_deals = fetch_and_cache(
                    Product.objects.filter(
                        Q(productdetail__discount=F('productdetail__price') / 2) &
                        Q(productdetail__updated_on__gte=datetime.now() - timedelta(days=2))
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                    cache_keys["super_deals"],
                    limit=3
                )
                response_container["super_deals"] = super_deals

            elif report_type == "quality_picks":
                quality_picks = fetch_and_cache(
                    Product.objects.filter(choice=True).order_by('?'),
                    cache_keys["quality_picks"],
                    limit=15
                )
                response_container["quality_picks"] = quality_picks

            elif report_type == "categories":
                categories = cache.get(cache_keys["categories"])
                if categories is None:
                    categories = ProductCategory.objects.all()
                    serialized_data = CategoriesSerializer(categories, many=True, context={"request": request}).data
                    cache.set(cache_keys["categories"], serialized_data, timeout=cache_timeout)
                else:
                    serialized_data = categories
                response_container["categories"] = serialized_data

            elif report_type == "header_banner":
                header_banner = Promo.objects.filter(promo_type="banner", status="active", position="header_banner")
                response_container["header_banner"] = MallDealSerializer(
                    header_banner, many=True, context={"request": request}).data

            elif report_type == "more_to_love":
                # All Products excluding already queried products
                all_products_query = Product.objects.filter(
                    status="active", store__is_active=True).order_by("-id").exclude(id__in=queried_product_ids)

                shuffled_new_arrivals = list(all_products_query)
                shuffle(shuffled_new_arrivals)

                # Pagination
                paginated_products = self.paginate_queryset(all_products_query, request)

                serialized_all_products = ProductSerializer(paginated_products, many=True,
                                                            context={'request': request}).data
                final_serialized_response = self.get_paginated_response(serialized_all_products).data

                # Instead of adding the paginated response object, we directly add the serialized data

                response_container["total_count"] = self.page.paginator.count
                response_container["page_size"] = len(paginated_products)
                response_container["remaining_items"] = max(0, self.page.paginator.count - self.page.end_index())
                response_container["status"] = True if max(0, self.page.paginator.count - self.page.end_index()) > 0 else False

                response_container["all_products"] = final_serialized_response

            else:
                return Response({"detail": f"Invalid request type selected: {report_type}."}, status=status.HTTP_400_BAD_REQUEST)

            return Response(response_container, status=status.HTTP_200_OK)

        except Product.DoesNotExist:
            return Response({"detail": "Product not found."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            # Log the error for debugging
            buyer_logger.error(f"Error in MallLandPageView: {e}")
            admin_logger.error(f"Error in MallLandPageView: {e}")
            return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)


class MallCategorySectionView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            report_type = request.GET.get("report_type")

            response_container = {}
            paginator = CustomViewMorePagination()  # Instantiate the paginator

            # Define querysets dynamically
            all_products = Product.objects.filter(status="active", store__is_active=True).order_by('-sale_count',
                                                                                                   "-view_count",
                                                                                                   '-updated_on')

            shuffled_products = list(all_products)
            shuffle(shuffled_products)

            queries = {
                "best_sellers": lambda: Product.objects.filter(status="active", store__is_active=True).order_by(
                    "-sale_count", "-view_count"),
                "choice_products": lambda: Product.objects.filter(status="active", choice=True,
                                                                  store__is_active=True).order_by("-id"),
                "seasonal_picks": lambda: Product.objects.filter(status="active", seasonal_pick=True,
                                                                 store__is_active=True).order_by("-id"),
                "fresh_finds": lambda: Product.objects.filter(status="active", store__is_active=True,
                                                              created_on__gte=timezone.now() - timedelta(
                                                                  days=2)).order_by("-id"),

                "price_from_999": lambda: Product.objects.filter(
                        Q(productdetail__price__gte=999.99) & Q(free_shipping=True)
                    ).prefetch_related(
                        Prefetch('productdetail_set', queryset=ProductDetail.objects.all())).order_by('?'),
                "free_shipping": lambda: Product.objects.filter(free_shipping=True).order_by("-id"),
                "price_from_4999": lambda: Product.objects.filter(
                    Q(productdetail__price__gte=4999.99) & Q(free_shipping=True)
                ).prefetch_related(
                    Prefetch('productdetail_set', queryset=ProductDetail.objects.all())).order_by('?'),
                "first_come_50_first": lambda: Product.objects.filter(
                        productdetail__discount=F('productdetail__price') / 2
                    ).prefetch_related(Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),
                "price_from_7500": lambda: Product.objects.filter(
                        Q(productdetail__price__gte=7500.00) & Q(free_shipping=True)
                    ).prefetch_related(Prefetch('productdetail_set', queryset=ProductDetail.objects.all())
                    ).order_by('?'),

                "all_products": lambda: shuffled_products
            }

            # Check if `report_type` is valid
            if report_type not in queries:
                return Response({"detail": "Invalid request type selected."}, status=status.HTTP_400_BAD_REQUEST)

            # # Fetch from cache or query the database
            # cache_key = f"{report_type}"
            # cached_data = cache.get(cache_key)

            # if cached_data is None:
            # queryset = queries[report_type]()
            # if isinstance(queryset, list):  # For shuffled products
            #     paginated_queryset = paginator.paginate_queryset(queryset, request)
            # else:  # For regular querysets
            #     paginated_queryset = paginator.paginate_queryset(queryset, request)

            queryset = queries[report_type]()
            paginated_queryset = paginator.paginate_queryset(queryset, request)
            serialized_data = ProductSerializer(paginated_queryset, many=True, context={"request": request}).data
            final_serialized_response = paginator.get_paginated_response(serialized_data).data
            # cache.set(cache_key, final_serialized_response, timeout=cache_timeout)
            # else:
            #     final_serialized_response = cached_data

            response_container[report_type] = final_serialized_response

            # Add additional pagination details
            total_count = paginator.page.paginator.count if paginator.page else 0
            response_container["total_count"] = total_count
            response_container["page_size"] = paginator.page_size
            response_container["remaining_items"] = max(0, paginator.page.paginator.count - paginator.page.end_index())
            response_container["status"] = (
                    response_container["remaining_items"] > 0
            )

            return Response(response_container, status=status.HTTP_200_OK)

        except (ValueError, TypeError, ValidationError) as e:
            buyer_logger.error(f"Error in MallCategorySectionView: {e}")
            admin_logger.error(f"Error in MallCategorySectionView: {e}")
            return Response({"error": f"ValidationError: {str(e)}"}, status=status.HTTP_400_BAD_REQUEST)

        except KeyError as ke:
            buyer_logger.error(f"Error in MallCategorySectionView: {ke}")
            admin_logger.error(f"Error in MallCategorySectionView: {ke}")
            return Response({"error": f"Missing key: {str(ke)}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            buyer_logger.error(f"Error in MallCategorySectionView: {e}")
            admin_logger.error(f"Error in MallCategorySectionView: {e}")
            return Response({"error": f"An unexpected error occurred: {str(e)}"},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ProductDetailView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request, slug, *args, **kwargs):
        try:
            # Fetch request_type from query parameters
            request_type = request.GET.get("request_type")
            response_data = dict()

            # Try to fetch the product, handle 404 if not found
            try:
                product = Product.objects.get(slug=slug, status='active', store__is_active=True)
                self.save_recently_viewed_products(request, slug)
            except Product.DoesNotExist:
                return Response({"detail": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

            excluded_slugs = [product.slug]

            # If no query params (i.e., request_type), default to product details
            if not request_type or request_type == "details":
                serializer = ProductSerializer(product, context={"request": request})
                response_data['details'] = serializer.data

            # Handling different request_type  # COME BACK TO THIS!!!
            if request_type == "related_items":
                related_products = Product.objects.annotate(
                    similarity=TrigramSimilarity('name', product.name) +
                               TrigramSimilarity('tags', product.name) +
                               TrigramSimilarity('category__name', product.name)
                ).filter(similarity__gt=0.1, status="active", store__is_active=True).order_by('-similarity').exclude(
                    slug__in=excluded_slugs)[:10]

                related_products_ = Product.objects.filter(status="active", store__is_active=True,
                                                          category=product.category).exclude(
                    slug__in=excluded_slugs).order_by("-id")[:10]
                serializer = ProductSerializer(related_products, many=True, context={"request": request})
                response_data['related_items'] = serializer.data

                # Add slugs from `related_items` to the excluded list
                excluded_slugs.extend([item.slug for item in related_products])

            elif request_type == "reviews":
                reviews = ProductReview.objects.filter(product=product).order_by("-id")
                # Pagination
                paginated_reviews = self.paginate_queryset(reviews, request)
                serializer = ProductReviewSerializerOut(paginated_reviews, many=True,
                                                        context={"request": request}).data  # Use ProductReviewSerializer
                final_serialized_response = self.get_paginated_response(serializer).data
                response_data['reviews'] = final_serialized_response

            elif request_type == "store_products":
                store_products = Product.objects.filter(status="active", store__is_active=True, store=product.store
                                                        ).exclude(slug__in=excluded_slugs)[:10]
                serializer = ProductSerializer(store_products, many=True, context={"request": request})
                response_data['store_products'] = serializer.data

            elif request_type == "you_may_also_like":
                recommendations = Product.objects.filter(
                    category=product.category, status="active", store__is_active=True
                ).exclude(slug__in=excluded_slugs).order_by("-sale_count")

                paginated_recommendations = self.paginate_queryset(recommendations, request)
                serializer = ProductSerializer(paginated_recommendations, many=True, context={"request": request}).data
                final_serialized_response = self.get_paginated_response(serializer).data
                response_data['you_may_also_like'] = final_serialized_response

            # Default case for invalid request_type
            elif request_type and request_type not in ['details', 'related_items', 'reviews',
                                                       'store_products', 'you_may_also_like']:
                return Response({"detail": "Invalid request type selected."}, status=status.HTTP_400_BAD_REQUEST)

            return Response(response_data, status=status.HTTP_200_OK)

        except ObjectDoesNotExist as err:
            buyer_logger.error(f"Error in ProductDetailView: {err}")
            admin_logger.error(f"Error in ProductDetailView: {err}")
            return Response({"detail": "The requested resource could not be found."}, status=status.HTTP_404_NOT_FOUND)

        except Exception as err:
            buyer_logger.error(f"Error in ProductDetailView: {err}")
            admin_logger.error(f"Error in ProductDetailView: {err}")
            return Response({"detail": "Error occurred while fetching product", "error": str(err)},
                            status=status.HTTP_400_BAD_REQUEST)

    @staticmethod
    def save_recently_viewed_products(request, slug):
        """
        Save products in the recently viewed field for the authenticated user
        Save products in the session for unauthenticated user
        """
        if slug:
            product_slug = str(slug)

            if request.user.is_authenticated:
                try:
                    # Access or create user profile
                    user_profile, created = Profile.objects.get_or_create(user=request.user)

                    # Retrieve the current recently viewed products from the user profile
                    recently_viewed_products = json.loads(user_profile.recent_viewed_products or "[]")

                    # Remove the product if it already exists to avoid duplicates
                    if product_slug in recently_viewed_products:
                        recently_viewed_products.remove(product_slug)

                    # Add the new product at the start of the list
                    recently_viewed_products.insert(0, product_slug)

                    # Limit the list to the last 20 viewed products
                    recently_viewed_products = recently_viewed_products[:20]

                    # Save the updated list back to the user's profile
                    user_profile.recent_viewed_products = json.dumps(recently_viewed_products)
                    user_profile.save()

                except Exception as e:
                    buyer_logger.error(f"Error in ProductDetailView: Error saving recently viewed products for user: {e}")
                    admin_logger.error(f"Error in ProductDetailView: Error saving recently viewed products for user: {e}")
                    return None

                buyer_logger.error("Error in ProductDetailView: Adding products to recently viewed")
                admin_logger.error("Error in ProductDetailView: Adding products to recently viewed")

            else:
                # Session-based handling if the user is anonymous
                if 'recently_viewed_products' not in request.session:
                    request.session['recently_viewed_products'] = []

                recently_viewed_products = request.session['recently_viewed_products']

                if product_slug in recently_viewed_products:
                    recently_viewed_products.remove(product_slug)

                recently_viewed_products.insert(0, product_slug)

                if len(recently_viewed_products) > 20:
                    recently_viewed_products = recently_viewed_products[:20]

                request.session['recently_viewed_products'] = recently_viewed_products


class FilteredSearchView(generics.ListAPIView):
    permission_classes = []
    pagination_class = CustomPagination
    serializer_class = ProductSerializer
    filter_backends = (DjangoFilterBackend, SearchFilter)
    filter_class = ProductFilter

    def get_queryset(self):
        query = self.request.GET.get('search_query', '').strip()
        order_by = self.request.GET.get('sort_by', '')
        product_type_id = self.request.GET.get('product_type_id', '').strip()

        delivery_options = self.request.GET.getlist('delivery_options', [])
        shipping_option = self.request.GET.get('shipping_option', '').strip()
        discounts = self.request.GET.get('discounts', 'false').lower() == 'true'
        # discounts = self.request.GET.getlist('discounts', [])
        price_range = self.request.GET.get('price_range', '').strip()

        suggestions = self.request.GET.get('suggestions', 'false').lower().strip() == 'true'  # Detect suggestion request

        # Start with a base queryset
        search = Product.objects.filter(status='active', store__is_active=True)

        # Filter by product type if specified
        if product_type_id:
            search = search.filter(product_type_id=product_type_id)

        if query:
            # Step 1: Full-text search
            search_vector = SearchVector('name', 'description', 'tags', 'category__name')
            search_query = SearchQuery(query)
            search_products = Product.objects.annotate(
                rank=SearchRank(search_vector, search_query)
            )
            search = search_products.filter(rank__gte=0.1, status='active', store__is_active=True).order_by(
                '-rank', '-sale_count', '-view_count')

            # Step 2: Fallback to Trigram Similarity if full-text search returns no results
            if not search.exists():
                search_products = Product.objects.annotate(
                    similarity=TrigramSimilarity('name', query) +
                               TrigramSimilarity('description', query) +
                               TrigramSimilarity('tags', query) +
                               TrigramSimilarity('category__name', query)
                )
                search = search_products.filter(similarity__gt=0.1, status='active', store__is_active=True).order_by(
                    '-similarity', '-sale_count', '-view_count').distinct()

        # If it's a suggestion request, return only product names without pagination
        if suggestions:
            return search.values_list('name', flat=True).distinct()[:10]

        # Handle delivery options filter (if provided)
        if delivery_options:
            if isinstance(delivery_options, list):
                search = search.filter(delivery_option__in=delivery_options)
            else:
                return Response({"error": "Invalid format for delivery options."},
                                status=status.HTTP_400_BAD_REQUEST)

        # Handle shipping option filter (if provided)
        if shipping_option:
            search = search.filter(free_shipping=(shipping_option.lower() == 'true'))

        # if discounts:
        #     if isinstance(discounts, list):
        #         # Get product IDs matching the price range from ProductDetail
        #         product_ids_in_discount = ProductDetail.objects.filter(
        #             discount__in=map(int, discounts)
        #         ).values_list('product_id', flat=True)
        #
        #         search = search.filter(id__in=product_ids_in_discount)
        #     else:
        #         return Response({"error": "Invalid format for discounts."}, status=status.HTTP_400_BAD_REQUEST)

        if discounts:
            product_ids_in_price_range = ProductDetail.objects.filter(
                discount__gt=1).values_list('product_id', flat=True)

            # Filter the main search query using the matching product IDs
            search = search.filter(id__in=product_ids_in_price_range)

        # Handle price range filtering
        if price_range:
            try:
                min_price, max_price = map(float, price_range.split('-'))
                product_ids_in_price_range = ProductDetail.objects.filter(
                    price__gte=min_price, price__lte=max_price
                ).values_list('product_id', flat=True)
                search = search.filter(id__in=product_ids_in_price_range)
            except ValueError:
                return Response({"error": "Price range should be in 'min-max' format."},
                                status=status.HTTP_400_BAD_REQUEST)
            except Exception as e:
                buyer_logger.error(f"Error in FilteredSearchView: {e}")
                admin_logger.error(f"Error in FilteredSearchView: {e}")
                return Response({"error": f"An error occurred while processing the price range: {str(e)}"},
                                status=status.HTTP_400_BAD_REQUEST)

        if order_by:
            queryset = sorted_queryset(order_by, query)
            return queryset

        # Order by newest products
        search = search.order_by('-sale_count', "-view_count", '-updated_on').distinct()

        return search

    def list(self, request, *args, **kwargs):
        from django.forms.models import model_to_dict

        suggestions = request.GET.get('suggestions', 'false').lower() == 'true'
        if suggestions:
            # Convert each Product object into a dictionary
            serialized_queryset = [model_to_dict(product, fields=['id', 'name']) for product in self.get_queryset()]

            return Response({"suggestions": serialized_queryset})  # Return suggestions in JSON format
        return super().list(request, *args, **kwargs)


class CategoriesView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request, slug=None):
        try:
            param = request.GET.get("param")
            search = request.GET.get("search")
            sub_cat = request.GET.get("sub-category")

            if slug:
                data = cache.get(f"category_{slug}")
                if data is None:
                    data = CategoriesSerializer(ProductCategory.objects.get(slug=slug),
                                                context={"request": request}).data
                    cache.set(key=f"category_{slug}", value=data, timeout=cache_timeout)
                return Response({"detail": data})

            # If no slug, handle query parameters and fetch all categories
            return self.get_all_categories(sub_cat, search, param, request)

        except Exception as e:
            buyer_logger.error(f"Error in CategoriesView: {e}")
            admin_logger.error(f"Error in CategoriesView: {e}")
            return Response({"detail": str(e)}, status=status.HTTP_400_BAD_REQUEST)

    def get_all_categories(self, sub_cat, search, param, request):
        """Handle request for all categories, with optional filters."""
        query = Q()

        # Filter based on whether it's a sub-category or a main category
        if sub_cat == "yes":
            query &= Q(parent__isnull=False)
        else:
            query &= Q(parent__isnull=True)

        # Filter based on search input
        if search:
            query &= Q(name__icontains=search)

        # No pagination requested
        if param == "no-paginate":
            categories = ProductCategory.objects.filter(query).order_by("-id")
            data = [{"id": cat.id, "name": cat.name, "slug": cat.slug} for cat in categories]
            return Response(data)

        # Apply pagination
        categories = ProductCategory.objects.filter(query).order_by("-id")
        paginated_categories = self.paginate_queryset(categories, request)

        # Fetch all parent categories (with subcategories)
        parent_categories = ProductCategory.objects.filter(parent=None).prefetch_related('subcategories').order_by("-id")

        if paginated_categories is not None:
            serialized_data = CategoriesSerializer(paginated_categories, many=True, context={"request": request}).data
            return self.get_paginated_response(serialized_data)

        # If no pagination needed, just return the full list
        serialized_data = CategoriesSerializer(parent_categories, many=True, context={"request": request}).data
        return Response(serialized_data)


class ProductInCategoryView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request, category_slug, sub_category_slug=None, *args, **kwargs):
        try:
            # Step 1: Get the category by slug
            category = get_object_or_404(ProductCategory, slug=category_slug)

            # Step 2: Fetch products in the category
            # If sub_category_slug is provided, filter by that as well
            products_query = Product.objects.filter(category=category, status="active", store__is_active=True)

            if sub_category_slug:
                sub_category = get_object_or_404(ProductCategory, slug=sub_category_slug, parent=category)
                products_query = products_query.filter(sub_category=sub_category)

            products = products_query.order_by("-sale_count")

            # Step 4: Get sub-categories
            sub_categories = ProductCategory.objects.filter(parent=category)
            sub_category_serializer = SubCategorySerializer(sub_categories, many=True, context={'request': request})

            # Optional: Handle pagination if needed
            paginated_query = self.paginate_queryset(products, request)
            data = ProductSerializer(paginated_query, many=True, context={"request": request}).data

            data = self.get_paginated_response(data=data).data

            response_data = {
                "category": category.name,
                "sub_categories": sub_category_serializer.data,
                "products": data
            }

            return Response(response_data, status=status.HTTP_200_OK)

        except ProductCategory.DoesNotExist:
            # Step 4: Handle non-existent category error
            buyer_logger.error(f"Error in ProductInCategoryView: Category '{category_slug}' does not exist.")
            admin_logger.error(f"Error in ProductInCategoryView: Category '{category_slug}' does not exist.")
            return Response({
                "detail": f"Category '{category_slug}' not found."
            }, status=status.HTTP_404_NOT_FOUND)

        except Exception as e:
            # Step 5: Catch any other errors and log them
            buyer_logger.error(f"Error in ProductInCategoryView: Error fetching products in category '{category_slug}': {str(e)}")
            admin_logger.error(f"Error in ProductInCategoryView: Error fetching products in category '{category_slug}': {str(e)}")

            return Response({
                "detail": "An error occurred while fetching products.",
                "error": str(e)
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class CustomerOverviewAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        response_data = {}

        # Wishlist
        try:
            wishlist = ProductWishlist.objects.filter(user=request.user) if request.user.is_authenticated else None
            serialized_wishlist = ProductWishlistSerializer(wishlist, context={"request": request}, many=True).data
            response_data['wishlist'] = serialized_wishlist if serialized_wishlist else "Nothing to see here"
        except Exception as e:
            buyer_logger.error(f"Error in CustomerOverviewAPIView: {e}")
            admin_logger.error(f"Error in CustomerOverviewAPIView: {e}")

            response_data['wishlist_error'] = str(e)

        # Following Stores
        try:
            if request.user.is_authenticated:
                following_stores = request.user.profile.following.all()

                # Get all stores that belong to the sellers the user is following
                following_s = Store.objects.filter(seller__in=following_stores)

                if following_stores.exists():
                    # Create a list of store data including their URLs
                    store_data = []

                    for store in following_s:
                        # Calculate review statistics for each store
                        total_reviews = ProductReview.objects.filter(product__store=store).count()
                        positive_reviews = ProductReview.objects.filter(product__store=store, rating__gte=3).count()
                        positive_percentage = (positive_reviews / total_reviews * 100) if total_reviews > 0 else 0

                        # Get top 10 products by sale count for each store
                        products = Product.objects.filter(store=store, status='active',
                                                store__is_active=True).order_by("-sale_count")[:10]

                        # Add store-specific data to the list
                        store_data.append({
                            'store_name': store.name,
                            'store_about': store.description,
                            'is_following': {
                                "following_status": request.user in store.seller.follower.all(),
                                "follower_count": store.seller.follower.count(),
                            },
                            "store_positive_percentage": positive_percentage,

                            "store_products": ProductSerializer(products, context={"request": request}, many=True).data

                        })

                    response_data['following'] = store_data
                else:
                    response_data['following'] = "Nothing to see here"
            else:
                response_data['following'] = "User is not authenticated"
        except Exception as e:
            buyer_logger.error(
                f"Error in CustomerOverviewAPIView: {str(e)}")
            admin_logger.error(
                f"Error in CustomerOverviewAPIView: {str(e)}")

            response_data['following_error'] = str(e)

        # Random 30 products
        try:
            random_products = Product.objects.filter(status='active', store__is_active=True).order_by('?')[:10]
            serialized_products = ProductSerializer(random_products, context={"request": request}, many=True).data
            response_data['random_products'] = serialized_products if serialized_products else "Nothing to see here"
        except Exception as e:
            buyer_logger.error(
                f"Error in CustomerOverviewAPIView: {str(e)}")
            admin_logger.error(
                f"Error in CustomerOverviewAPIView: {str(e)}")

            response_data['random_products_error'] = str(e)

        return Response(response_data, status=status.HTTP_200_OK)


class CustomerOrdersAPIView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        from store.choices import order_status_choices

        response_data = {}
        time_filter = request.GET.get("filter_time")
        order_status = request.GET.get("status")
        search_query = request.GET.get('search', '').strip()

        try:
            # Fetch orders for the logged-in user's profile
            orders = Order.objects.filter(customer=request.user.profile).order_by("-id")

            # Apply time-based filters
            if time_filter:
                now = timezone.now()
                if time_filter == "last_year":
                    orders = orders.filter(created_on__year=now.year - 1)
                elif time_filter == "last_month":
                    last_month = now.month - 1 if now.month > 1 else 12
                    year = now.year if now.month > 1 else now.year - 1
                    orders = orders.filter(created_on__year=year, created_on__month=last_month)
                elif time_filter == "last_7_days":
                    orders = orders.filter(created_on__gte=now - timezone.timedelta(days=7))
                elif time_filter == "today":
                    orders = orders.filter(created_on__date=now.date())
                else:
                    return Response(
                        {"error": f"Invalid time filter: {time_filter}"},
                        status=status.HTTP_400_BAD_REQUEST
                    )

            if order_status:
                if order_status == "pending":
                    order_products = OrderProduct.objects.filter(status=order_status).order_by("-id")
                    orders = orders.filter(id__in=order_products.values_list("order_id", flat=True))

                elif order_status == "delivered":
                    order_products = OrderProduct.objects.filter(status=order_status).order_by("-id")
                    orders = orders.filter(id__in=order_products.values_list("order_id", flat=True))

                # if order_status in dict(order_status_choices).keys():
                #     order_products = OrderProduct.objects.filter(status=order_status).distinct().order_by("-id")
                #     orders = orders.filter(id__in=order_products.values_list("order_id", flat=True))

                else:
                    return Response(
                        {"error": f"Invalid order status: {order_status}"},
                        status=status.HTTP_400_BAD_REQUEST
                    )

            if search_query:
                if search_query.isdigit():
                    orders = orders.filter(id__iexact=search_query).distinct()
                else:
                    # Search by product name or store name
                    search_vector = SearchVector('name', 'store__name')
                    search_query_obj = SearchQuery(search_query)

                    # Check for exact matches
                    exact_product_ids = Product.objects.filter(name__iexact=search_query).values_list('id', flat=True)
                    if exact_product_ids.exists():
                        # Filter orders linked to products with exact match
                        order_ids = OrderProduct.objects.filter(product_detail__product_id__in=exact_product_ids
                        ).values_list('order_id', flat=True)
                        orders = orders.filter(Q(id__in=order_ids))
                    else:
                        # Fallback to related items using partial match (full-text search)
                        related_product_ids = Product.objects.annotate(rank=SearchRank(search_vector, search_query_obj)
                        ).filter(rank__gte=0.1).values_list('id', flat=True)

                        # Trigram similarity fallback for broader matches
                        if not related_product_ids.exists():
                            related_product_ids = Product.objects.annotate(
                                similarity=TrigramSimilarity('name', search_query) +
                                           TrigramSimilarity('store__name', search_query)
                            ).filter(similarity__gt=0.1).values_list('id', flat=True)

                        # Filter orders linked to related products
                        if related_product_ids.exists():
                            order_ids = OrderProduct.objects.filter(product_detail__product_id__in=related_product_ids
                            ).values_list('order_id', flat=True)
                            orders = orders.filter(Q(id__in=order_ids))

            # Serialize and return orders
            paginated_orders = self.paginate_queryset(orders, request)
            serialized_orders = OrderSerializer(paginated_orders, context={"request": request}, many=True).data
            final_serialized_response = self.get_paginated_response(serialized_orders).data
            response_data["orders"] = final_serialized_response

            return Response(response_data, status=status.HTTP_200_OK)

        except Order.DoesNotExist:
            return Response(
                {"error": "No orders found for the customer."},
                status=status.HTTP_404_NOT_FOUND,
            )
        except Exception as e:
            buyer_logger.error(f"Error in CustomerOrdersAPIView: {e}")
            admin_logger.error(f"Error in CustomerOrdersAPIView: {e}")
            return Response(
                {"error": f"An error occurred while retrieving orders: {str(e)}"},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR,
            )


class CustomerOrderDetailsAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request, order_id):
        response_data = {}
        try:
            order = Order.objects.get(id=order_id, customer=request.user.profile)
            order_products = OrderProduct.objects.filter(order=order)

            # Serialize the order and products
            order_serializer = OrderSerializer(order)
            order_products_serializer = OrderProductSerializer(order_products, context={"request": request}, many=True)

            response_data['order'] = order_serializer.data
            response_data['products'] = order_products_serializer.data
        except Order.DoesNotExist:
            return Response({"error": "Order not found"}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            response_data['error'] = str(e)

        return Response(response_data, status=status.HTTP_200_OK)


class CustomerProductReviewAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        response_data = {}
        time_filter = request.GET.get('filter_time', None)
        search_query = request.GET.get('search', '').strip()

        try:
            reviews = ProductReview.objects.filter(user=request.user)

            if time_filter == 'last_year':
                reviews = reviews.filter(created_on__year=timezone.now().year - 1)
            elif time_filter == 'last_month':
                reviews = reviews.filter(created_on__month=timezone.now().month - 1)

            if search_query:
                reviews = reviews.filter(Q(product__name__icontains=search_query) |
                                         Q(product__store__seller__user__username__icontains=search_query))

            serialized_reviews = ProductReviewSerializerOut(reviews, context={"request": request}, many=True).data

            response_data['reviews'] = serialized_reviews if reviews.exists() else "Nothing to see here"

        except Exception as e:
            buyer_logger.error(f"Error in CustomerProductReviewAPIView: {e}")
            admin_logger.error(f"Error in CustomerProductReviewAPIView: {e}")
            response_data['error'] = f"Unable to fetch reviews: {str(e)}"

        return Response(response_data, status=status.HTTP_200_OK)


class CustomerWalletAPIView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            response = dict()

            # Wallet Information
            profile = Profile.objects.get(user=request.user)
            wallet_bal = get_wallet_info(profile)

            # Recent Orders
            response['profile_detail'] = ProfileSerializer(profile, context={"request": request}).data

            response['wallet_information'] = wallet_bal
            response['total_amount_spent'] = Transaction.objects.filter(
                order__customer__user=request.user, status="success"
            ).aggregate(Sum("amount"))["amount__sum"] or 0

            return Response({"balance": response}, status=status.HTTP_200_OK)
        except AttributeError:
            return Response({"error": "Wallet not found"}, status=status.HTTP_404_NOT_FOUND)

        except Exception as e:
            buyer_logger.error(f"Error in CustomerWalletAPIView: {e}")
            admin_logger.error(f"Error in CustomerWalletAPIView: {e}")
            return Response({"error": str(e)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class RecentlyViewedProductsView(APIView):
    permission_classes = []

    def get(self, request):
        # Check if user is authenticated and retrieve the recently viewed products
        if request.user.is_authenticated:
            user_profile = getattr(request.user, 'profile', None)
            if user_profile and user_profile.recent_viewed_products:
                recently_viewed_slugs = json.loads(user_profile.recent_viewed_products)
            else:
                recently_viewed_slugs = []
        else:
            # For guests, retrieve recently viewed products from the session
            recently_viewed_slugs = request.session.get('recently_viewed_products', [])

        # Query the products based on the slugs
        products = Product.objects.filter(slug__in=recently_viewed_slugs, status='active', store__is_active=True)

        # Serialize the products
        serialized_products = ProductSerializer(products, many=True, context={'request': request}).data

        # Preserve the order of recently viewed products based on the stored slugs
        ordered_products = [product for slug in recently_viewed_slugs for product in serialized_products if
                            product['slug'] == slug]

        return Response(ordered_products, status=status.HTTP_200_OK)


class ProductTypeListAPIView(generics.ListAPIView):
    permission_classes = []
    queryset = ProductType.objects.all().order_by("-id")
    serializer_class = ProductTypeSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter]
    search_fields = ["name"]


class BannerPromoListAPIView(generics.ListAPIView):
    permission_classes = []
    queryset = Promo.objects.all().order_by("-id")
    serializer_class = BannerSerializer
    pagination_class = CustomPagination
    filter_backends = [DjangoFilterBackend, SearchFilter]
    search_fields = ["title"]


class BannerPromoDetailAPIView(generics.RetrieveAPIView):
    permission_classes = []
    queryset = Promo.objects.all().order_by("-id")
    serializer_class = BannerSerializer
    lookup_field = "slug"


class TopSellingProductsView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request):
        try:
            start_date = timezone.datetime.today()
            end_date2 = timezone.timedelta(weeks=1)

            top_selling_prod_key = "top_selling_prod_ep_key"
            queryset = cache.get(top_selling_prod_key)
            if queryset is None:
                queryset = Product.objects.filter(sale_count=0, created_on__date__gte=start_date - end_date2).order_by(
                    "-id")
                cache.set(key=top_selling_prod_key, value=queryset, timeout=cache_timeout)

            paginated_query = self.paginate_queryset(queryset, request)
            data = self.get_paginated_response(
                ProductSerializer(paginated_query, many=True, context={"request": request}).data).data

            return Response({"detail": data})
        except (Exception,) as err:
            buyer_logger.error(f"Error in TopSellingProductsView: {err}")
            admin_logger.error(f"Error in TopSellingProductsView: {err}")
            # LOG ERROR
            return Response({"detail": str(err)}, status=status.HTTP_400_BAD_REQUEST)


class RecommendedProductView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request):
        try:
            query_set = Product.objects.filter(is_featured=True).order_by("-id")

            paginated_query = self.paginate_queryset(query_set, request)
            data = ProductSerializer(paginated_query, many=True, context={"request": request}).data

            data = self.get_paginated_response(data=data).data
            return Response({"detail": data})
        except (Exception,) as err:
            buyer_logger.error(f"Error in RecommendedProductView: {err}")
            admin_logger.error(f"Error in RecommendedProductView: {err}")
            # LOG ERROR
            return Response({"detail": str(err)}, status=status.HTTP_400_BAD_REQUEST)


class CartProductOperationsView(APIView):
    permission_classes = []

    def post(self, request):
        try:
            variant = request.data.get("variant", [])

            if not variant:
                return Response(
                    {"detail": "Product variant is required"}, status=status.HTTP_400_BAD_REQUEST
                )

            if request.user.is_authenticated:
                cart, _ = Cart.objects.get_or_create(user=request.user, status="open")
            else:

                session_id = request.session.session_key
                if not session_id:
                    request.session.create()
                    session_id = request.session.session_key
                cart, created = Cart.objects.get_or_create(cart_uid=session_id, status="open")

            success, response = create_or_update_cart_product(variant, cart=cart)
            if success is False:
                return Response({"detail": response}, status=status.HTTP_400_BAD_REQUEST)
            # Delete cart if no item is in it
            if not CartProduct.objects.filter(cart=cart).exists():
                cart.delete()
                return Response({"detail": "Cart is empty"})

            serializer = CartSerializer(cart, context={"request": request}).data
            return Response({"detail": "Cart updated", "data": serializer})
        except Exception as err:
            buyer_logger.error(f"Error in CartProductOperationsView: {err}")
            admin_logger.error(f"Error in CartProductOperationsView: {err}")
            return Response({"detail": "An error has occurred", "error": str(err)}, status=status.HTTP_400_BAD_REQUEST)

    def get(self, request, id=None):
        # try:
        cart = None
        if request.user.is_authenticated:
            if Cart.objects.filter(status="open", user=request.user).exists():
                cart = Cart.objects.filter(status="open", user=request.user).last()
                remaining_open_carts = Cart.objects.filter(status="open", user=request.user).exclude(id=cart.id)

                # Close other open carts
                if remaining_open_carts:
                    remaining_open_carts.update(status="discard")
        else:
            session_id = request.session.session_key
            if Cart.objects.filter(status="open", cart_uid=session_id).exists():
                cart = Cart.objects.get(status="open", cart_uid=session_id)

        if not cart:
            return Response({"detail": "Cart empty"})

        serializer = CartSerializer(cart, context={"request": request}).data

        return Response({"detail": serializer}, status=status.HTTP_200_OK)


class GetExternalShipping(APIView):
    permission_classes = []

    def get(self, request):
        try:
            url = f"{settings.UPDATED_SHIPPING_BASE_URL}/core/shippers/active"
            headers = {
                "X-API-KEY": f"{settings.UPDATED_SHIPPING_X_API_KEY}"
            }
            response = requests.get(url, headers=headers)
            response_data = response.json()

            return Response({
                "response": response_data["Data"]
            }, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            shipping_logger.error(f"Error in GetExternalShipping: {str(e)}")
            admin_logger.error(f"Error in GetExternalShipping: {str(e)}")
            return Response({"error": f"An unexpected error occurred: {str(e)}"},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class GetExternalLocation(APIView):
    permission_classes = []

    def get(self, request, *args, **kwargs):
        from rest_framework.exceptions import APIException

        if not all([settings.UPDATED_SHIPPING_BASE_URL, settings.UPDATED_SHIPPING_X_API_KEY]):
            raise APIException("Shipping settings are not properly configured.")

        try:
            state_name = request.GET.get("StateName")

            if state_name:
                url = f"{settings.UPDATED_SHIPPING_BASE_URL}/location/state?StateName={state_name}"
                headers = {
                    "X-API-KEY": settings.UPDATED_SHIPPING_X_API_KEY
                }

                response = requests.get(url, headers=headers)
                response.raise_for_status()
                response_data = response.json()

                return Response({"response": response_data}, status=status.HTTP_200_OK)

            elif not state_name:
                # If StateName param is not provided, fetch all states
                url = f"{settings.UPDATED_SHIPPING_BASE_URL}/location/states"
                headers = {
                    "X-API-KEY": settings.UPDATED_SHIPPING_X_API_KEY
                }

                response = requests.get(url, headers=headers)
                response.raise_for_status()
                response_data = response.json()

                return Response({"response": response_data}, status=status.HTTP_200_OK)

            else:
                return Response(
                    {"detail": f"Invalid query params selected: {state_name}."}, status=status.HTTP_400_BAD_REQUEST
                )

        except requests.RequestException as e:
            shipping_logger.error(f"Error in GetExternalLocation: {e}")
            admin_logger.error(f"Error in GetExternalLocation: {e}")
            raise APIException(f"Error in GetExternalLocation: {e}")

        except (TypeError, ValueError, OverflowError) as err:
            return Response({"error": f"Process failed: {err}"},  status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            shipping_logger.error(f"Unexpected error in GetExternalLocation: {str(e)}")
            admin_logger.error(f"Unexpected error in GetExternalLocation: {str(e)}")
            return Response(
                {"error": f"An unexpected error occurred: {str(e)}"},  status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


class ModifyCartAPIView(APIView):
    permission_classes = []

    @transaction.atomic
    def post(self, request, product_slug=None):
        operation = request.data.get('operation')
        # shipping_service = request.data.get('shipping_service')
        company_id = request.data.get('factoryId')
        # delivery_fee = request.data.get('delivery_fee', 0)
        quantity = request.data.get('quantity', 1)
        product_slugs = request.data.get('product_slugs', [])

        if operation not in ['add', 'update', 'remove', 'reduce', 'buy_now']:
            return Response({"error": "Invalid operation. Use 'add', 'update', 'reduce', 'buy_now' or 'remove'."},
                            status=status.HTTP_400_BAD_REQUEST)

        # Ensure session key for anonymous users
        if not request.user.is_authenticated:
            session_key = request.data.get("session_key")

        else:
            session_key = None

        try:
            if request.user.is_authenticated:
                cart, created = Cart.objects.get_or_create(user=request.user, status='open')
            else:
                cart, created = Cart.objects.get_or_create(cart_uid=session_key, status='open')

            with transaction.atomic():
                # Handle cart operations
                if operation == 'remove':
                    if product_slugs and isinstance(product_slugs, list):
                        removed_count = 0
                        not_found_slugs = []
                        for slug in product_slugs:
                            try:
                                product_detail = self._get_product_detail(slug)
                                # product_detail = get_object_or_404(ProductDetail, product__slug=slug)
                                cart_product = CartProduct.objects.filter(cart=cart,
                                                                          product_detail=product_detail).first()
                                if cart_product:
                                    cart_product.delete()
                                    removed_count += 1
                                else:
                                    not_found_slugs.append(slug)  # Product not in cart
                            except ProductDetail.DoesNotExist:
                                not_found_slugs.append(slug)  # Collect slugs that were not found

                        if removed_count > 0:
                            message = f"{removed_count} products removed from cart."
                        else:
                            message = "No products were removed from the cart."

                        if not_found_slugs:
                            message += f" The following products were not found: {', '.join(not_found_slugs)}"

                        return Response({"message": message}, status=status.HTTP_200_OK)

                    else:
                        # Single product removal as in the original logic
                        product_detail = self._get_product_detail(product_slug)
                        # product_detail = get_object_or_404(ProductDetail, product__slug=product_slug)
                        cart_product = CartProduct.objects.filter(cart=cart, product_detail=product_detail).first()
                        if cart_product:
                            cart_product.delete()
                            return Response({"message": "Product removed from cart."}, status=status.HTTP_200_OK)
                        else:
                            return Response({"error": "Product not found in cart"}, status=status.HTTP_404_NOT_FOUND)

                elif operation == 'add':
                    product_detail = self._get_product_detail(product_slug)
                    # product_detail = get_object_or_404(ProductDetail, product__slug=product_slug)

                    if quantity > product_detail.stock:
                        return Response({"error": "Requested quantity exceeds available stock."},
                                        status=status.HTTP_400_BAD_REQUEST)

                    if product_detail.product.status != "active" and product_detail.product.store.is_active is False:
                        return Response({"error": f"Selected product: ({product_detail.product.name}) is not available"},
                                        status=status.HTTP_400_BAD_REQUEST)

                    cart_product = CartProduct.objects.filter(cart=cart, product_detail=product_detail).first()
                    if cart_product is None:
                        CartProduct.objects.create(
                            cart=cart,
                            product_detail=product_detail,
                            price=product_detail.price,
                            quantity=quantity,
                            shipper_name=company_id,
                            company_id=company_id,
                            # delivery_fee=delivery_fee
                        )
                    else:
                        cart_product.quantity += quantity
                        cart_product.save()

                elif operation == 'update':
                    product_detail = self._get_product_detail(product_slug)
                    # product_detail = get_object_or_404(ProductDetail, product__slug=product_slug)

                    if quantity > product_detail.stock:
                        return Response({"error": "Requested quantity exceeds available stock."},
                                        status=status.HTTP_400_BAD_REQUEST)

                    if product_detail.product.status != "active" and product_detail.product.store.is_active is False:
                        return Response(
                            {"error": f"Selected product: ({product_detail.product.name}) is not available"},
                            status=status.HTTP_400_BAD_REQUEST)

                    cart_product = CartProduct.objects.filter(cart=cart, product_detail=product_detail).first()
                    if cart_product:
                        cart_product.quantity = quantity if quantity else cart_product.quantity
                        cart_product.shipper_name = company_id if company_id else cart_product.company_id
                        cart_product.company_id = company_id if company_id else cart_product.company_id
                        # cart_product.delivery_fee = delivery_fee if delivery_fee else cart_product.delivery_fee
                        cart_product.save()
                    else:
                        return Response({"error": "Product not found in cart"}, status=status.HTTP_404_NOT_FOUND)

                elif operation == 'reduce':
                    product_detail = self._get_product_detail(product_slug)
                    # product_detail = get_object_or_404(ProductDetail, product__slug=product_slug)
                    cart_product = CartProduct.objects.filter(cart=cart, product_detail=product_detail).first()
                    if cart_product:
                        if cart_product.quantity > quantity:
                            cart_product.quantity -= quantity
                            cart_product.save()
                        else:
                            cart_product.delete()
                            return Response({"message": "Product removed from cart."}, status=status.HTTP_200_OK)
                    else:
                        return Response({"error": "Product not found in cart"}, status=status.HTTP_404_NOT_FOUND)

                elif operation == 'buy_now':
                    # product_detail = self._get_product_detail(product_slug)
                    product_detail = get_object_or_404(ProductDetail, product__slug=product_slug)

                    if quantity > product_detail.stock:
                        return Response({"error": "Requested quantity exceeds available stock."},
                                        status=status.HTTP_400_BAD_REQUEST)

                    if product_detail.product.status != "active" and product_detail.product.store.is_active is False:
                        return Response(
                            {"error": f"Selected product: ({product_detail.product.name}) is not available"},
                            status=status.HTTP_400_BAD_REQUEST)

                    # Remove existing instances of the product from the cart
                    CartProduct.objects.filter(cart=cart, product_detail=product_detail).delete()

                    # Deselect all other cart items
                    selected_cart_product = CartProduct.objects.filter(cart=cart, selected=True)
                    if selected_cart_product.exists():
                        for item in selected_cart_product:
                            item.selected = False
                            item.save()

                    CartProduct.objects.create(
                        cart=cart,
                        product_detail=product_detail,
                        price=product_detail.price,
                        quantity=quantity,
                        shipper_name=company_id,
                        company_id=company_id,
                        # delivery_fee=delivery_fee,
                        selected=True
                    )

                return Response({
                    "message": f"Item {operation}ed to cart successfully.",
                    "product_slug": product_slug,
                    "session_key": session_key
                }, status=status.HTTP_200_OK)

        except ProductDetail.DoesNotExist:
            return Response({"error": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

        except KeyError as ke:
            buyer_logger.error(f"Error in ModifyCartAPIView: Missing key: {ke}")
            admin_logger.error(f"Error in ModifyCartAPIView: Missing key: {ke}")
            return Response({"error": f"Missing key: {str(ke)}"}, status=status.HTTP_400_BAD_REQUEST)

        except ValidationError as ve:
            buyer_logger.error(f"Error in ModifyCartAPIView: Validation error: {ve}")
            admin_logger.error(f"Error in ModifyCartAPIView: Validation error: {ve}")
            return Response({"error": f"Validation error: {ve.message}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            buyer_logger.error("Error in ModifyCartAPIView: Unexpected error during cart modification")
            admin_logger.error("Error in ModifyCartAPIView: Unexpected error during cart modification")
            return Response({"error": f"An unexpected error occurred: {str(e)}"},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def _get_product_detail(self, product_slug):
        """
        Fetch a single ProductDetail object. Handle duplicate or missing entries gracefully.
        Log duplicates with their names.
        """
        product_details = ProductDetail.objects.filter(product__slug=product_slug)
        count = product_details.count()

        if count == 0:
            raise ProductDetail.DoesNotExist("No ProductDetail found for the given slug.")

        if count > 1:
            duplicate_names = ", ".join([f"{pd.product.name} (ID: {pd.id})" for pd in product_details])
            buyer_logger.debug(
                f"Duplicate ProductDetail entries found for slug '{product_slug}': {duplicate_names}"
            )
            admin_logger.debug(
                f"Duplicate ProductDetail entries found for slug '{product_slug}': {duplicate_names}"
            )
            raise ValueError(
                f"Multiple ProductDetail entries found for slug '{product_slug}'. Duplicates logged."
            )

        return product_details.first()


class ProductDetailOfCartView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, product_slug):
        try:
            product = ProductDetail.objects.get(product__slug=product_slug)

            if request.user.is_authenticated:
                cart = Cart.objects.filter(status="open", user=request.user).last()

            else:
                session_key = request.query_params.get("session_key")
                cart = Cart.objects.get(status="open", cart_uid=session_key)

            cart_items = CartProduct.objects.get(cart=cart, product_detail=product, status="open")
            cart_products = CartProductSerializer(cart_items, context={"request": request}).data

            return Response({
                "product": product.product.name,
                "cart_product_id": cart_products["id"],
                "quantity": cart_products["quantity"],
                "price": cart_products["price"],
                "shipper_name": cart_products["shipper_name"],
                "company_id": cart_products["company_id"],

            }, status=status.HTTP_200_OK)

        except Product.DoesNotExist:
            return Response({"error": f"Product with slug {product_slug} doesn't exists"}, status=status.HTTP_404_NOT_FOUND)

        except Exception as err:
            import traceback
            buyer_logger.error(f"Error in ProductDetailOfCartView: {err}---{traceback.format_exc()}")
            admin_logger.error(f"Error in ProductDetailOfCartView: {err}---{traceback.format_exc()}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class CartItemsView(APIView):
    permission_classes = [AllowAny]  # Allow access to all users

    def get(self, request):
        self._authenticate_user(request)  # Authenticate user manually
        cart = None
        if request.user.is_authenticated:
            if Cart.objects.filter(status="open", user=request.user).exists():
                cart = Cart.objects.filter(status="open", user=request.user).last()
                remaining_open_carts = Cart.objects.filter(status="open", user=request.user).exclude(id=cart.id)
                # Close other open carts
                if remaining_open_carts:
                    remaining_open_carts.update(status="discard")
        else:
            session_key = request.query_params.get("session_key")

            if Cart.objects.filter(status="open", cart_uid=session_key).exists():
                cart = Cart.objects.get(status="open", cart_uid=session_key)

        if not cart:
            return Response({"detail": "Cart empty"})

        # Show only open items

        open_cart_products = CartProduct.objects.filter(cart=cart, status="open").order_by("-created_on", "-updated_on")
        data = CartSerializer(cart, context={"request": request}).data
        cart_products = CartProductSerializer(open_cart_products, context={"request": request}, many=True).data
        data["cart_products"] = cart_products

        for item in cart_products:
            item['in_cart'] = True

        return Response(data, status=status.HTTP_200_OK)

    @transaction.atomic
    def post(self, request, *args, **kwargs):
        try:
            # self._authenticate_user(request)  # Authenticate user manually

            serializer = CartUpdateSerializer(data=request.data)
            if serializer.is_valid():
                product_slug = serializer.validated_data.get('product_slug')
                quantity = serializer.validated_data.get('quantity', 1)
                selected = serializer.validated_data.get('selected')
                select_all = serializer.validated_data.get('select_all')

                try:
                    # Get or create the cart
                    if request.user.is_authenticated:
                        cart, created = Cart.objects.get_or_create(status="open", user=request.user)
                    else:
                        session_key = request.data.get("session_key")

                        cart, created = Cart.objects.get_or_create(status="open", cart_uid=session_key)

                    with transaction.atomic():
                        # Handle 'select all' scenario
                        if select_all:
                            # Update selected status for all items in the cart
                            CartProduct.objects.filter(cart=cart).update(selected=selected)
                        else:
                            # If not 'select all', handle specific product operations
                            product = get_object_or_404(ProductDetail, product__slug=product_slug)

                            if quantity > product.stock:
                                return Response({"error": "Requested quantity exceeds available stock."},
                                                status=status.HTTP_400_BAD_REQUEST)

                            # Retrieve or create the cart item
                            cart_item = CartProduct.objects.select_for_update().filter(cart=cart,
                                                                                       product_detail=product).first()

                            if not cart_item:
                                return Response({"error": "Item not found in cart."}, status=status.HTTP_404_NOT_FOUND)

                            cart_item.quantity = quantity
                            cart_item.selected = selected
                            cart_item.save()

                        # Calculate subtotal, shipping, and total for selected items
                        selected_items = CartProduct.objects.filter(cart=cart, selected=True)
                        subtotal = sum(item.quantity * item.product_detail.price for item in selected_items)

                        total = subtotal

                        return Response({
                            "cart_items": CartSerializer(cart, context={"request": request}).data,
                            "subtotal": subtotal,

                            "total": total,
                        }, status=status.HTTP_200_OK)

                except ProductDetail.DoesNotExist:
                    return Response({"error": "Product not found."}, status=status.HTTP_404_NOT_FOUND)

                except Exception as e:
                    buyer_logger.error(f"Error in CartItemsView: {e}")
                    admin_logger.error(f"Error in CartItemsView: {e}")
                    return Response({"error": f"An unexpected error occurred: {str(e)}"},
                                    status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"Error in CartItemsView: {err}")
            admin_logger.error(f"Error in CartItemsView: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"Error in CartItemsView: {err}")
            admin_logger.error(f"Error in CartItemsView: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @staticmethod
    def _authenticate_user(request):
        """
        Manually authenticate the user via JWT token.
        """
        from rest_framework.authentication import get_authorization_header
        from rest_framework_simplejwt.authentication import JWTAuthentication

        auth = get_authorization_header(request).split()
        if len(auth) == 2 and auth[0].lower() == b"bearer":
            try:
                validated_user = JWTAuthentication().authenticate(request)
                if validated_user:
                    request.user = validated_user[0]
            except Exception:
                pass  # Ignore token errors; treat as unauthenticated user


class CheckoutView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        try:
            customer = Profile.objects.get(user=request.user)

            # Get address - prefer primary, fall back if necessary
            address = (
                    Address.objects.filter(customer=customer, is_primary=True).last()
                    or Address.objects.filter(customer=customer).last()
            )

            # Get open cart for the customer
            try:
                cart = Cart.objects.get(user=request.user, status="open")
            except Cart.DoesNotExist:
                return Response({"error": "No open cart available for checkout."}, status=status.HTTP_404_NOT_FOUND)
            except Cart.MultipleObjectsReturned:
                return Response({"error": "Multiple open carts found for customer. Please resolve."},
                                status=status.HTTP_409_CONFLICT)

            # Get cart items and group by seller
            cart_products = CartProduct.objects.filter(cart=cart, status="open", selected=True).select_related(
                'product_detail__product__store__seller'
            )
            if not cart_products:
                return Response({"error": "No items selected in the cart for checkout."}, status=status.HTTP_400_BAD_REQUEST)

            cart_items = []
            sellers = {}
            subtotal = Decimal(0)

            # Iterate by seller & pass payload to API
            shipping_information = []

            shipping_rates_ = []

            for cart_product in cart_products:
                if cart_product is None or cart_product.id is None:
                    continue  # Skip invalid cart products

                # Get the product and store (seller) information
                product = cart_product.product_detail.product
                seller = product.store
                seller_data = {
                    "id": seller.id,
                    "name": seller.name,
                }

                # Add seller to sellers dictionary for shipping calculations
                if seller.id not in sellers:
                    sellers[seller.id] = {"seller": seller, "products": []}
                sellers[seller.id]["products"].append(cart_product)

                # Get shipping rates and process the response
                shipper_id = cart_product.company_id

                payload = self.build_quote_payload(address, [cart_product], shipper_id)
                shipping_rates = self.fetch_shipping_rates(payload)
                shipping_rates_.append(shipping_rates)

                # Map API response to cart products
                for rate in shipping_rates:
                    cart_product.shipper_name = shipper_id
                    cart_product.company_id = shipper_id
                    cart_product.delivery_fee = Decimal(rate['TotalPrice'])
                    # cart_product.estimated_delivery = rate['QuoteList'][0]['EstimatedDelivery']
                    cart_product.save()

                    shipping_information.append({
                        "cart_product_id": [cart_product.id],  # NEW INPUT
                        "product_id": cart_product.id,
                        "shipper": rate["ShipperName"],
                        "shipping_fee": Decimal(rate["TotalPrice"]),
                        # "estimated_delivery": rate["QuoteList"][0]["EstimatedDelivery"]
                    })

                # Prepare item data for the cart item
                item_data = {
                    "cart_product_item": CartProductSerializer(cart_product, context={"request": request}).data,
                    "total_price": cart_product.quantity * cart_product.product_detail.price,

                    "shipper": cart_product.company_id,
                    "delivery_fee": cart_product.delivery_fee,

                    "seller": seller_data,
                    # "cart_product_id": cart_product.id,
                    "cart_product_id": [cart_product.id],
                }
                cart_items.append(item_data)  # Add item data to the list
                subtotal += item_data["total_price"]  # Update the subtotal for the cart

            total_shipping_fee = sum(Decimal(rate["shipping_fee"]) for rate in shipping_information)

            # Prepare final response structure
            response_data_first = {
                "address": {
                    'address_id': address.id if address else "Not specified",
                    'address_name': address.name if address else "Not specified",
                    'address_landmark': address.landmark if address else "Not specified",
                    'city': address.city if address else "Not specified",
                    'state': address.state if address else "Not specified",
                    'country': address.country if address else "Not specified",
                    'postal_code': address.postal_code if address else "Not specified",
                },
                "cart_items": cart_items,
                "shipping_information": shipping_information,
                "shipping_rates_vendor": shipping_rates_,
                "summary": {
                    "subtotal": float(subtotal),
                    # "subtotal": sum(cp.quantity * cp.product_detail.price for cp in cart_products),
                    "total_shipping_fee": total_shipping_fee,
                    "total_amount": float(subtotal + total_shipping_fee),
                }
            }

            return Response(response_data_first, status=status.HTTP_200_OK)

        except Profile.DoesNotExist:
            return Response({"error": "Customer profile not found."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            buyer_logger.error(f"Error in CheckoutView: {e}")
            admin_logger.error(f"Error in CheckoutView: {e}")
            return Response({"error": f"Unexpected error: {str(e)}"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def build_quote_payload(self, address, products, shipper_id):
        customer, created = Profile.objects.get_or_create(user=self.request.user)
        total_item_weight = []

        items = []
        prod_weight = 0  # Initialize prod_weight if not already initialized

        for p in products:
            weight = float(p.product_detail.weight or 0)
            quantity = int(p.quantity or 0)

            item = {
                "PackageId": p.id,
                "Quantity": quantity,
                "Weight": weight,
                "ItemType": "Normal",
                "Name": p.product_detail.product.name,
                "Amount": float(p.product_detail.price * p.quantity),
                "ShipmentType": "Regular",
                "Description": p.product_detail.product.description,
            }
            items.append(item)
            prod_weight += weight * quantity
            total_item_weight.append(prod_weight)

        # Ensure total_item_weight only contains numbers
        total_weight = sum(float(weight) for weight in total_item_weight)

        return {
            "QuoteInformation": [
                {
                    "PickupAddress": p.product_detail.product.store.seller.get_full_address(),
                    "PickupCoordinate": {"Latitude": p.product_detail.product.store.seller.latitude,
                                         "Longitude": p.product_detail.product.store.seller.longitude},

                    "PickupTime": str(datetime.now().time()),
                    "PickupDate": str((datetime.today().date() + timedelta(days=2))).replace("-", "/"),

                    "PickupCity": str(p.product_detail.product.store.seller.city),
                    "PickupState": p.product_detail.product.store.seller.state,
                    "PickupStationId": 4,
                    "SenderNumber": f"0{p.product_detail.product.store.seller.phone_number[-10:]}",
                    "SenderName": p.product_detail.product.store.seller.user.get_full_name(),
                    "ReceiverName": customer.user.get_full_name(),
                    "ReceiverPhoneNumber": f"0{customer.phone_number[-10:]}",

                    "DeliveryAddress": address.get_full_address,
                    "DeliveryCoordinate": {"Latitude": address.latitude,
                                           "Longitude": address.longitude},

                    "DeliveryState": address.state,
                    "DeliveryStationId": 4,
                    "DeliveryCity": address.city,

                    "Items": items,

                    "Id": p.product_detail.product.store.seller.id,
                    "TotalWeight": total_weight
                }
                for p in products
            ],
            "ShipperId": shipper_id,  # Dynamically use the selected shipper ID
        }

    def fetch_shipping_rates(self, payload):
        from rest_framework.exceptions import APIException

        # Ensure necessary settings are available
        if not all([settings.UPDATED_SHIPPING_BASE_URL, settings.UPDATED_SHIPPING_TOKEN,
                    settings.UPDATED_SHIPPING_X_API_KEY]):
            raise APIException("Shipping settings are not properly configured.")

        url = f"{settings.UPDATED_SHIPPING_BASE_URL}/core/quote"  # Replace with actual URL
        try:
            headers = {
                'Authorization': f'Bearer {settings.UPDATED_SHIPPING_TOKEN}',
                'Content-Type': 'application/json',
                "X-API-KEY": f"{settings.UPDATED_SHIPPING_X_API_KEY}"
            }
            # Validate payload
            if not payload:
                buyer_logger.error(f"Error in build_quote_payload: Payload cannot be empty")
                admin_logger.error(f"Error in build_quote_payload: Payload cannot be empty")
                raise APIException("Payload cannot be empty.")

            # Set a timeout for the request
            response = requests.post(url, json=payload, headers=headers, timeout=10)  # 10 seconds timeout
            response.raise_for_status()

            # Check if 'Data' key exists in the response
            response_data = response.json()
            if "Data" not in response_data:
                shipping_logger.error(f"fetch_shipping_rates: Response does not contain 'Data' key.")
                admin_logger.error(f"fetch_shipping_rates: Response does not contain 'Data' key.")
                raise APIException("Response does not contain 'Data' key.")

            shipping_logger.info(f"fetch_shipping_rates: url: {url}, payload: {payload}, response: {response}, response_data: {response_data}")
            admin_logger.info(f"fetch_shipping_rates: url: {url}, payload: {payload}, response: {response}, response_data: {response_data}")

            return response_data["Data"]
        except requests.RequestException as e:
            shipping_logger.error(f"fetch_shipping_rates: Request failed: {e}")
            admin_logger.error(f"fetch_shipping_rates: Request failed: {e}")
            raise APIException(f"Failed to fetch shipping rates: {e}")
        except ValueError as e:
            shipping_logger.error(f"fetch_shipping_rates: Invalid JSON response: {e}")
            admin_logger.error(f"fetch_shipping_rates: Invalid JSON response: {e}")
            raise APIException("Failed to parse shipping rates response.")
        except Exception as e:
            shipping_logger.error(f"fetch_shipping_rates: Unexpected error: {e}")
            admin_logger.error(f"fetch_shipping_rates: Unexpected error: {e}")
            raise APIException(f"An unexpected error occurred: {e}")

    def post(self, request):
        try:
            # Extract data from request
            payment_method = request.data.get("payment_method")
            pin = request.data.get("pin")
            source = request.data.get("source", "payarena")
            address_id = request.data.get("address_id")
            shipping_information = request.data.get("shipping_information")

            if not all([shipping_information, address_id]):
                return Response({"error": "Shipping information and address are required."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Get customer and address
            customer = Profile.objects.get(user=request.user)

            address = (
                    Address.objects.filter(customer=customer, is_primary=True).last()
                    or Address.objects.filter(customer=customer).last()
            )
            if not address:
                return Response({"error": "No address available for this customer."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Get cart and selected items
            cart = Cart.objects.get(user=request.user, status="open")
            selected_items = CartProduct.objects.filter(cart=cart, status="open", selected=True)
            if not selected_items.exists():
                return Response({"error": "No items selected for checkout."}, status=status.HTTP_400_BAD_REQUEST)

            # Process shipping and fees
            delivery_fees = []
            for product in shipping_information:
                cart_products = CartProduct.objects.filter(id__in=product["cart_product_id"], cart=cart, selected=True)

                for cart_product in cart_products:
                    # cart_product.company_id = product.get("shipper")
                    # cart_product.shipper_name = product.get("shipper", "Unknown").upper()
                    # cart_product.delivery_fee = Decimal(product.get("shipping_fee", 0))
                    # cart_product.save()

                    delivery_fees.append(cart_product.delivery_fee)

            # Validate cart contents
            validation_message = validate_product_in_cart(customer)
            if validation_message:
                return Response({"error": validation_message}, status=status.HTTP_400_BAD_REQUEST)

            # Create order and process payment
            order, _ = Order.objects.get_or_create(customer=customer, cart=cart, address=address)
            total_delivery_fee = sum(delivery_fees)
            payment_success, payment_detail = order_payment(
                request, payment_method, total_delivery_fee, order, source, address, pin
            )

            if not payment_success:
                return Response({"error": payment_detail}, status=status.HTTP_400_BAD_REQUEST)
            return Response(
                {"detail_message": "Checkout processing...", "order_id": order.id,
                 "payment_detail": payment_detail},
                status=status.HTTP_200_OK)

        except Profile.DoesNotExist:
            return Response({"error": "Customer profile not found."}, status=status.HTTP_404_NOT_FOUND)
        except Address.DoesNotExist:
            return Response({"error": "Invalid address specified."}, status=status.HTTP_400_BAD_REQUEST)
        except Cart.DoesNotExist:
            return Response({"error": "No open cart available for checkout."}, status=status.HTTP_404_NOT_FOUND)
        except Exception as e:
            buyer_logger.error(f"Error in CheckoutView: {e}")
            admin_logger.error(f"Error in CheckoutView: {e}")
            return Response({"error": "An error occurred during checkout.", "details": str(e)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ProductWishlistView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated]

    def get(self, request, id=None):
        try:
            if id is not None:
                product = get_object_or_404(Product, id=id)
                wishlist_item = ProductWishlist.objects.filter(user=request.user, product=product).first()

                # Add the 'is_in_wishlist' indicator
                is_in_wishlist = wishlist_item is not None
                user_wishlist_count = ProductWishlist.objects.filter(user=request.user).count()

                # Get count of how many times the product has been added to wishlists across all users
                total_wishlist_count_for_product = ProductWishlist.objects.filter(product=product).count()

                serializer = ProductWishlistSerializer(wishlist_item, context={"request": request})
                data = serializer.data
                data.update({
                    'is_in_wishlist': is_in_wishlist,
                    'user_wishlist_count ': user_wishlist_count,
                    'total_wishlist_count_for_product': total_wishlist_count_for_product,
                })

                return Response({"detail": data}, status=status.HTTP_200_OK)

            product_wishlist = ProductWishlist.objects.filter(user=request.user).order_by("-id")
            paginated_queryset = self.paginate_queryset(product_wishlist, request)
            serialized_queryset = ProductWishlistSerializer(paginated_queryset, many=True,
                                                            context={"request": request}).data

            for item in serialized_queryset:
                item['is_in_wishlist'] = True

            serializer = self.get_paginated_response(serialized_queryset).data
            return Response({"detail": serializer})
        except (Exception,) as err:
            buyer_logger.error(f"Error in ProductWishlistView: {err}")
            admin_logger.error(f"Error in ProductWishlistView: {err}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        product_id = request.data.get('product_id', '')
        if not product_id:
            return Response({"detail": "Product ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Check if the product exists
            product = Product.objects.get(pk=product_id, status='active', store__is_active=True)

            # Check if the product is already in the wishlist for the user
            wishlist_item = ProductWishlist.objects.filter(user=request.user, product=product).first()

            if wishlist_item:
                # If it already exists, return a response indicating that it's already in the wishlist
                return Response({"detail": "Product already in wishlist"}, status=status.HTTP_200_OK)

            # If not in the wishlist, create a new entry
            product_wishlist, created = ProductWishlist.objects.get_or_create(user=request.user, product=product)
            data = ProductWishlistSerializer(product_wishlist, context={"request": request}).data
            return Response({"detail": "Added to wishlist", "data": data}, status=status.HTTP_201_CREATED)

        except Product.DoesNotExist:
            return Response({"detail": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        except Exception as ex:
            buyer_logger.error(f"Error in post ProductWishlistView: {ex}")
            admin_logger.error(f"Error in post ProductWishlistView: {ex}")
            return Response({"detail": "An error occurred. Please try again", "error": str(ex)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request):
        # Remove product from wishlist
        product_id = request.data.get('product_id', '')
        if not product_id:
            return Response({"detail": "Product ID is required"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            product = Product.objects.get(pk=product_id, status='active', store__is_active=True)
            wishlist_item = ProductWishlist.objects.filter(user=request.user, product=product).first()

            if wishlist_item:
                wishlist_item.delete()

                # Get the updated wishlist count
                updated_wishlist_count = ProductWishlist.objects.filter(user=request.user).count()

                # Check if the product still exists in the wishlist
                is_in_wishlist = ProductWishlist.objects.filter(user=request.user, product=product).exists()

                return Response({"detail": "Removed from wishlist", "updated_wishlist_count": updated_wishlist_count,
                                 "is_in_wishlist": is_in_wishlist}, status=status.HTTP_200_OK)
            else:
                return Response({"detail": "Product not in wishlist"}, status=status.HTTP_404_NOT_FOUND)

        except Product.DoesNotExist:
            return Response({"detail": "Product not found"}, status=status.HTTP_404_NOT_FOUND)

        except Exception as ex:
            buyer_logger.error(f"Error in delete ProductWishlistView: {ex}")
            admin_logger.error(f"Error in delete ProductWishlistView: {ex}")
            return Response({"detail": "An error occurred. Please try again", "error": str(ex)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# class RetrieveDeleteWishlistView(generics.RetrieveDestroyAPIView):
#     pagination_class = [CustomPagination]
#     serializer_class = ProductWishlistSerializer
#     lookup_field = "id"
#
#     def get_queryset(self):
#         queryset = ProductWishlist.objects.filter(user=self.request.user)
#         return queryset


class ProductView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request, slug=None):
        try:
            if slug:
                product = Product.objects.get(slug=slug, status="active", store__is_active=True)
                product.view_count += 1
                product.last_viewed_date = datetime.now()
                if request.user.is_authenticated:
                    shopper = Profile.objects.get(user=request.user)
                    viewed_products = str(shopper.recent_viewed_products).split(',')
                    if str(product.id) not in viewed_products:
                        shopper.recent_viewed_products = str("{},{}").format(shopper.recent_viewed_products, product.id)
                        shopper.save()
                product.save()
                serializer = ProductSerializer(product, context={"request": request}).data
            else:
                search = request.GET.get("search")
                query = Q(status="active", store__is_active=True)
                if search:
                    query &= Q(name=search)
                prod = self.paginate_queryset(Product.objects.filter(query).order_by("-id"), request)
                queryset = ProductSerializer(prod, many=True, context={"request": request}).data
                serializer = self.get_paginated_response(queryset).data
            return Response(serializer)
        except Exception as err:
            buyer_logger.error(f"Error in ProductView: {err}")
            admin_logger.error(f"Error in ProductView: {err}")
            return Response({"detail": "Error occurred while fetching product", "error": str(err)},
                            status=status.HTTP_400_BAD_REQUEST)


class OrderAPIView(APIView, CustomPagination):

    def get(self, request, pk=None):
        context = {"request": request}
        try:
            if pk:
                data = OrderSerializer(Order.objects.get(id=pk, customer__user=request.user), context=context).data
            else:
                order_status = request.GET.get("status", None)
                if order_status:
                    order = Order.objects.filter(orderproduct__status=order_status,
                                                 customer__user=request.user).distinct()
                else:
                    order = Order.objects.filter(customer__user=request.user, payment_status="success").order_by("-id")
                queryset = self.paginate_queryset(order, request)
                serializer = OrderSerializer(queryset, many=True, context=context).data
                data = self.get_paginated_response(serializer).data
            return Response(data)
        except (Exception,) as err:
            buyer_logger.error(f"Error in OrderAPIView: {err}")
            admin_logger.error(f"Error in OrderAPIView: {err}")
            return Response({"detail": "An error has occurred", "error": str(err)}, status=status.HTTP_400_BAD_REQUEST)

    def put(self, request, pk):
        try:
            order = Order.objects.get(id=pk, customer__user=request.user)
            success, detail = perform_order_cancellation(order, request.user)
            if success is False:
                return Response({"detail": detail}, status=status.HTTP_400_BAD_REQUEST)
            return Response({"detail": detail})
        except Exception as ex:
            buyer_logger.error(f"Error in put OrderAPIView: {ex}")
            admin_logger.error(f"Error in put OrderAPIView: {ex}")
            return Response({"detail": "An error has occurred", "error": str(ex)}, status=status.HTTP_400_BAD_REQUEST)


class OrderReturnView(APIView, CustomPagination):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        """
            To fetch all returned order by the current logged user.
        """
        try:
            returned_products = ReturnedProduct.objects.filter(returned_by=request.user).order_by("-id")
            paginated_response = self.paginate_queryset(returned_products, request)
            serialized_returned_product = ReturnedProductSerializer(instance=paginated_response, many=True,
                                                                    context={"request": request}).data
            final_serialized_response = self.get_paginated_response(serialized_returned_product).data
            return Response({"detail": final_serialized_response})
        except (Exception,) as err:
            buyer_logger.error(f"Error in get OrderReturnView: {err}")
            admin_logger.error(f"Error in get OrderReturnView: {err}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)

    def post(self, request, pk=None):
        try:
            reason_id = request.data.get('reason_id', None)
            comment = request.data.get('comment', None)
            images = request.data.getlist('images', [])

            # I don't need the image processor here !

            if pk is None:
                return Response({"detail": f"Order Product ID is required."}, status=status.HTTP_400_BAD_REQUEST)

            if reason_id is None:
                return Response({"detail": f"Order Product ID is required."}, status=status.HTTP_400_BAD_REQUEST)

            if comment is None:
                return Response({"detail": f"Your comment is needed."}, status=status.HTTP_400_BAD_REQUEST)

            # Check if images was passed into 'images' list.
            if all(images) is False:
                return Response({"detail": f"Please provide an Image"}, status=status.HTTP_400_BAD_REQUEST)

            order_product = OrderProduct.objects.filter(id=pk, status="delivered")

            if not order_product.exists():
                return Response({"detail": f"Order product does not exist."}, status=status.HTTP_400_BAD_REQUEST)

            order_product = order_product.last()

            reason = get_object_or_404(ReturnReason, pk=reason_id)

            return_product_instance, success = ReturnedProduct.objects.get_or_create(
                returned_by=request.user, product=order_product)
            return_product_instance.reason = reason
            return_product_instance.comment = comment
            return_product_instance.save()

            for image in images:
                # Pending... waiting for image processing (waiting on the image processing method to use)
                return_product_image = ReturnProductImage(return_product=return_product_instance, image=image)
                return_product_image.save()

            # Pending... Notify admin
            return Response({"detail": f"Your report has been submitted"})
        except (Exception,) as err:
            buyer_logger.error(f"Error in post OrderReturnView: {err}")
            admin_logger.error(f"Error in post OrderReturnView: {err}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class CustomerDashboardView(APIView):
    permission_classes = [IsAuthenticated]

    def get(self, request):
        try:
            response = dict()

            # Wallet Information
            profile = Profile.objects.get(user=request.user)
            wallet_bal = get_wallet_info(profile)

            # Recent Orders
            recent_orders = OrderProduct.objects.filter(order__customer=profile).order_by("-id")[:10]
            response['profile_detail'] = ProfileSerializer(profile, context={"request": request}).data
            response['recent_orders'] = OrderProductSerializer(recent_orders, context={"request": request},
                                                               many=True).data
            response['wallet_information'] = wallet_bal
            response['total_amount_spent'] = Transaction.objects.filter(
                order__customer__user=request.user, status="success"
            ).aggregate(Sum("amount"))["amount__sum"] or 0
            # ----------------------

            # Recent Payment
            # -------------------------------

            return Response(response)

        except (Exception,) as err:
            buyer_logger.error(f"Error in CustomerDashboardView: {err}")
            admin_logger.error(f"Error in CustomerDashboardView: {err}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class TrackOrderAPIView(APIView):

    def get(self, request):
        order_prod_id = request.GET.get("order_product_id")

        try:
            order_product = OrderProduct.objects.get(id=order_prod_id, order__customer__user=request.user)
            if order_product.tracking_id:
                # Track Order
                success, detail = perform_order_tracking(order_product)
                if success is False:
                    return Response({"detail": detail}, status=status.HTTP_400_BAD_REQUEST)
                return Response(detail)
            else:
                return Response({"detail": "Tracking ID not found for selected order"})
        except Exception as er:
            buyer_logger.error(f"Error in TrackOrderAPIView: {er}")
            admin_logger.error(f"Error in TrackOrderAPIView: {er}")
            return Response({"detail": f"{er}"}, status=status.HTTP_400_BAD_REQUEST)


class ProductReviewAPIView(APIView, CustomPagination):
    permission_classes = []

    def get(self, request):
        try:
            product_id = self.request.GET.get("product_id")

            reviews = self.paginate_queryset(ProductReview.objects.filter(product_id=product_id), request)
            serializer = ProductReviewSerializerOut(reviews, context={"request": request}, many=True).data
            data = self.get_paginated_response(serializer).data
            return Response(data)

        except Exception as err:
            buyer_logger.error(f"Error in ProductReviewAPIView: {err}")
            admin_logger.error(f"Error in ProductReviewAPIView: {err}")
            return Response({"error": "Error in trying to get the Products", "detail": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def post(self, request):
        serializer = ProductReviewSerializerIn(data=request.data, context={"request": request})
        serializer.is_valid() or raise_serializer_error_msg(errors=serializer.errors)
        result = serializer.save()
        return Response({"detail": "Review added successfully", "data": result})


class NameEnquiryAPIView(APIView):
    permission_classes = []

    def get(self, request):
        try:
            bank_code = request.GET.get("bank_code")
            account_no = request.GET.get("account_no")

            # success, response = call_name_enquiry(bank_code, account_no)
            profile = Profile.objects.get(user=request.user)
            response = PayArenaServices.name_enquiry_from_bank(profile, bank_code, account_no)

            # if response.status_code == 200:
            if response["Success"] is True:
                data = response["Data"]["BeneficiaryName"]

                response_json = response
                merchant_logger.info(f"Response from NameEnquiryAPIView: {response_json}")
                admin_logger.info(f"Response from NameEnquiryAPIView: {response_json}")

                return Response({"NameEnquiryResponse": {"AccountName": data}}, status=status.HTTP_200_OK)
            else:
                error_response = response
                merchant_logger.info(f"Error in else statement for NameEnquiryAPIView: {error_response}")
                admin_logger.info(f"Error in else statement for NameEnquiryAPIView: {error_response}")
                return Response({"detail": "Error while requesting for name enquiry"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            merchant_logger.info(f"Error in NameEnquiryAPIView: {err}")
            admin_logger.info(f"Error in NameEnquiryAPIView: {err}")
            return Response({"error": "Error while requesting for name enquiry", "detail": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        # return Response({"success": success, "data": response})


# Mobile APP
class MobileCategoryListAPIView(generics.ListAPIView):
    permission_classes = []
    pagination_class = CustomPagination
    queryset = ProductCategory.objects.filter(parent__isnull=True).order_by("-id")
    serializer_class = MobileCategorySerializer


class MobileCategoryDetailRetrieveAPIView(generics.RetrieveAPIView):
    permission_classes = []
    serializer_class = MobileCategorySerializer
    queryset = ProductCategory.objects.filter(parent__isnull=True).order_by("-id")
    lookup_field = "slug"


class MobileStoreListAPIView(generics.ListAPIView):
    permission_classes = []
    pagination_class = CustomPagination
    serializer_class = StoreSerializer

    def get_queryset(self):
        query = self.request.GET.get("query")
        queryset = Store.objects.filter(is_active=True, seller__status="active").order_by("-id")
        if query == "on_sale":
            queryset = Store.objects.filter(is_active=True, seller__status="active", on_sale=True)
        if query == "latest":
            today = datetime.now()
            last_7_days = get_previous_date(date=datetime.now(), delta=7)
            queryset = Store.objects.filter(is_active=True, seller__status="active",
                                            created_on__range=[last_7_days, today])
        return queryset

    def list(self, request, *args, **kwargs):
        response = super(MobileStoreListAPIView, self).list(request, args, kwargs)
        today = datetime.now()
        last_7_days = get_previous_date(date=datetime.now(), delta=7)
        on_sales = [{
            "id": store.id,
            "name": store.name,
            "logo": request.build_absolute_uri(store.logo.url),
            "description": store.description
        } for store in Store.objects.filter(is_active=True, seller__status="active", on_sale=True)[:5]]

        latest_store = [{
            "id": store.id,
            "name": store.name,
            "logo": store.logo.url,
            "description": store.description
        } for store in
            Store.objects.filter(is_active=True, seller__status="active", created_on__range=[last_7_days, today])[:5]]
        response.data["new_stores"] = latest_store
        response.data["on_sales"] = on_sales
        return response


class MobileStoreDetailRetrieveAPIView(generics.RetrieveAPIView):
    permission_classes = []
    serializer_class = StoreSerializer
    queryset = Store.objects.filter(is_active=True, seller__status="active")
    lookup_field = "slug"


class MiniStoreAPIView(generics.ListAPIView):
    permission_classes = []
    pagination_class = CustomPagination
    serializer_class = StoreProductSerializer

    def get_queryset(self):
        store_id = self.kwargs.get("store_id")
        order_by = self.request.GET.get('sort_by', '')
        category_id = self.request.GET.get("category_id")
        search = self.request.GET.get("search")

        query = Q(status='active', store__is_active=True, store__slug=store_id)

        if category_id:
            query &= Q(category_id=category_id)

        if search:
            query &= Q(name__icontains=search)

        if order_by:
            queryset = sorted_queryset(order_by, query)
            return queryset

        queryset = Product.objects.filter(query).distinct()
        return queryset


class ReturnReasonListAPIView(generics.ListAPIView):
    queryset = ReturnReason.objects.all()
    serializer_class = ReturnReasonSerializer
    permission_classes = []


class ReturnReasonRetrieveAPIView(generics.RetrieveAPIView):
    queryset = ReturnReason.objects.all()
    serializer_class = ReturnReasonSerializer
    permission_classes = []
    lookup_field = "id"


class StoreFollowerAPIView(APIView):
    def post(self, request):
        store = request.data.get("store", [])
        profile = Profile.objects.get(user=request.user)

        try:
            profile.following.clear()
            for store_id in store:
                profile.following.add(store_id)
            return Response({"detail": "Update successful"})
        except Exception as err:
            buyer_logger.error(f"Error in StoreFollowerAPIView: {err}")
            admin_logger.error(f"Error in StoreFollowerAPIView: {err}")
            return Response({"detail": "An error has occurred", "error": str(err)}, status=status.HTTP_400_BAD_REQUEST)


class ProductFilterAPIView(APIView, CustomPagination):
    permission_classes = []

    def post(self, request):
        param = request.data.get("param")
        products = perform_banner_filter(request)
        result = self.paginate_queryset(products, request)
        if param == "no-paginate":
            return Response(ProductSerializer(result, many=True, context={"request": request}).data)
        serializer = ProductSerializer(result, many=True, context={"request": request}).data
        response = self.get_paginated_response(serializer).data
        return Response(response)


class CategoryFilterAPIView(APIView):
    permission_classes = []

    def post(self, request):
        cat = request.data.get("category_id", [])
        sub_cat = request.data.get("sub_category_id", [])

        result = []
        if cat:
            # category = ProductCategory.objects.filter(id__in=cat, parent__isnull=True).order_by("-id")
            category = ProductCategory.objects.filter(parent__id__in=cat, parent__isnull=False).order_by("-id")
            result = [{"id": cat.id, "name": cat.name} for cat in category]
        if sub_cat:
            # sub_category = ProductCategory.objects.filter(id__in=sub_cat, parent__isnull=False).order_by("-id")
            product_type = ProductType.objects.filter(category__id__in=sub_cat,
                                                      category__parent__isnull=False).order_by("-id")
            result = [{"id": prod.id, "name": prod.name} for prod in product_type]

        return Response(result)


# CRONJOBS
class RemoveRedundantCartCronView(APIView):
    permission_classes = []

    def get(self, request):
        response = remove_redundant_cart_cron()
        return Response({"detail": response})


class RetryOrderBookingCronView(APIView):
    permission_classes = []

    def get(self, request):
        response = retry_order_booking()
        return Response({"detail": response})


class TestTransactionApi(APIView):
    permission_classes = []
    def post(self, request):
        orderid = request.data.get("order_id")
        
        
        