import decimal

from django.conf import settings
from django.db.models import Sum, Avg

from account.models import Profile
from home.utils import log_request
from superadmin.exceptions import InvalidRequestException
from .models import ProductCategory, Product, ProductDetail, ProductImage, ProductReview, Promo, ProductType, \
    ProductWishlist, CartProduct, OrderProduct, Order, ReturnedProduct, ReturnProductImage, ReturnReason, Brand, \
    DailyDeal
from rest_framework import serializers

from django.utils.safestring import mark_safe


# Hot New Arrivals Serializers #
class ProductDetailSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()
    slashed_price = serializers.SerializerMethodField()
    discount_percentage = serializers.SerializerMethodField()

    def get_image(self, obj):
        request = self.context.get("request")
        images = ProductImage.objects.filter(product_detail=obj)
        if request:
            return [
                {
                    "id": instance.id,
                    "url": str(request.build_absolute_uri(instance.image.image.url)),
                }
                for instance in images
            ] or None
        return obj.image.image.url or None

    def get_slashed_price(self, obj):
        if obj.discount:  # Assuming you have a discount price field
            return decimal.Decimal(obj.discount)
        # Use Decimal for multiplier
        return round(obj.price * decimal.Decimal("1.74"), 2)

    def get_discount_percentage(self, obj):
        try:
            # Ensure both price and discount are not None and valid decimals
            if obj.price is not None and obj.discount is not None:
                price = decimal.Decimal(obj.price)
                discount = decimal.Decimal(obj.discount)

                if price == decimal.Decimal("0"):  # Avoid dividing by zero
                    return None

                # Calculate percentage discount
                discount_percentage = ((price - discount) / price) * 100
                return round(discount_percentage, 2)  # Round to 2 decimal places

            # Fallback case when discount isn't set
            if obj.price is not None:
                price = decimal.Decimal(obj.price)

                # Example assumption for slashed price: 30% discount
                discount_rate = decimal.Decimal("0.3")  # Replace with your logic for fallback discount rate
                fallback_slashed_price = price * (1 - discount_rate)  # Apply discount

                # Calculate discount percentage
                fallback_discount = ((price - fallback_slashed_price) / price) * 100
                return round(fallback_discount, 2)

            return None  # If price is also None, return None

        except (decimal.DivisionUndefined, ZeroDivisionError, decimal.InvalidOperation, TypeError):
            return None  # Gracefully handle errors

    class Meta:
        model = ProductDetail
        exclude = []


class VariantImageSerializer(serializers.ModelSerializer):
    images = serializers.SerializerMethodField()

    def get_images(self, obj):
        request = self.context.get("request")
        data = []
        for instance in ProductImage.objects.filter(product_detail=obj):
            data.append(
                {"image_id": instance.image.id, "image_url": str(request.build_absolute_uri(instance.image.image.url))})
        return data or None

    class Meta:
        model = ProductDetail
        exclude = []


class SimilarProductSerializer(serializers.ModelSerializer):
    average_rating = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()
    price = serializers.SerializerMethodField()
    discount = serializers.SerializerMethodField()

    def get_price(self, obj):
        query = ProductDetail.objects.filter(product=obj).first()
        if query:
            return query.price
        return None

    def get_discount(self, obj):
        query = ProductDetail.objects.filter(product=obj).first()
        if query:
            return query.discount
        return None

    def get_average_rating(self, obj):
        rating = 0
        query_set = ProductReview.objects.filter(product=obj).aggregate(Avg('rating'))
        if query_set:
            rating = query_set['rating__avg']
        return rating

    def get_image(self, obj):
        if obj.image:
            request = self.context.get('request')
            if request:
                image = request.build_absolute_uri(obj.image.image.url)
                return image
            return obj.image.image.url
        return None

    class Meta:
        model = Product
        fields = ["id", "name", "slug", "is_featured", "average_rating", "image", "price", "discount"]


class ProductSerializer(serializers.ModelSerializer):
    store = serializers.SerializerMethodField()
    total_stock = serializers.SerializerMethodField()
    brand = serializers.SerializerMethodField()
    brand_id = serializers.SerializerMethodField()
    average_rating = serializers.SerializerMethodField()
    rating_count = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()
    product_detail = serializers.SerializerMethodField()
    product_wishlist_count = serializers.SerializerMethodField()
    # variants = serializers.SerializerMethodField()
    category_id = serializers.SerializerMethodField()
    category = serializers.SerializerMethodField()
    category_slug = serializers.SerializerMethodField()
    sub_category_id = serializers.SerializerMethodField()
    sub_category = serializers.SerializerMethodField()
    sub_category_slug = serializers.SerializerMethodField()
    product_type = serializers.SerializerMethodField()
    product_type_id = serializers.SerializerMethodField()
    # similar = serializers.SerializerMethodField()
    # also_viewed_by_others = serializers.SerializerMethodField()
    # recently_viewed = serializers.SerializerMethodField()
    # merchant_id = serializers.CharField(source="store.seller.merchant_id")
    checked_by = serializers.SerializerMethodField()
    approved_by = serializers.SerializerMethodField()

    merchant_id = serializers.SerializerMethodField()  # Use SerializerMethodField now
    store_followers = serializers.SerializerMethodField()
    positive_reviews = serializers.SerializerMethodField()
    in_cart = serializers.SerializerMethodField()

    description = serializers.CharField()

    def to_representation(self, instance):
        data = super().to_representation(instance)
        data["description"] = mark_safe(instance.description)  # Allows HTML rendering
        return data

    def get_in_cart(self, obj):
        request = self.context.get("request")
        if request and request.user.is_authenticated:
            # Check if the product exists in the authenticated user's cart
            return CartProduct.objects.filter(cart__user=request.user, product_detail__product=obj, cart__status="open",
                                              status="open").exists()
        elif request:
            # Check for session-based carts for unauthenticated users
            session_key = request.query_params.get("session_key")
            return CartProduct.objects.filter(cart__cart_uid=session_key, product_detail__product=obj, cart__status="open",
                                              status="open").exists()
        return False

    def get_merchant_id(self, obj):
        # Safely handle cases where store or seller is None
        if obj.store and obj.store.seller:
            return obj.store.seller.id
        return None  # Return None if store or seller is not available

    def get_store_followers(self, obj):
        # Safely handle cases where store or seller is None
        if obj.store:
            followers = obj.store.seller.follower.all()
            followers_count = followers.count()
            return {
                "followers": [follower.username for follower in followers],  # or another field like 'follower.id'
                "followers_count": followers_count
            }

        # Return None if store is not available
        return {"followers": [], "followers_count": 0}

    # def get_recently_viewed(self, obj):
    #     from store.serializers import StoreProductSerializer
    #
    #     request = self.context.get("request")
    #     recent_view = Product.objects.filter(
    #         status="active", store__is_active=True).order_by("-last_viewed_date").exclude(pk=obj.id)[:10]
    #     if request.user.is_authenticated:
    #         if Profile.objects.filter(user=request.user).exists():
    #             shopper = Profile.objects.get(user=request.user)
    #             if shopper.recent_viewed_products:
    #                 shopper_views = shopper.recent_viewed_products.split(",")[1:]
    #                 recent_view = Product.objects.filter(id__in=shopper_views, status="active",
    #                                                      store__is_active=True).order_by("?")[:15]
    #     return StoreProductSerializer(recent_view, many=True, context={"request": request}).data

    def get_checked_by(self, obj):
        if obj.checked_by:
            return obj.checked_by.email
        return None

    def get_approved_by(self, obj):
        if obj.approved_by:
            return obj.approved_by.email
        return None

    # def get_similar(self, obj):
    #     product = Product.objects.filter(
    #         store__is_active=True, status='active', product_type=obj.product_type
    #     ).order_by('?').exclude(pk=obj.id).distinct()
    #     if self.context.get('seller'):
    #         product = product.filter(store__seller=self.context.get('seller'))
    #     return SimilarProductSerializer(product[:int(settings.SIMILAR_PRODUCT_LIMIT)], many=True,
    #                                     context={"request": self.context.get("request")}).data

    # def get_also_viewed_by_others(self, obj):
    #     viewed = Product.objects.filter(store__is_active=True, status='active',
    #                                     sub_category=obj.sub_category).order_by('?').exclude(pk=obj.id).distinct()
    #     if self.context.get('seller'):
    #         viewed = viewed.filter(store__seller=self.context.get('seller'))
    #     return SimilarProductSerializer(viewed[:int(settings.SIMILAR_PRODUCT_LIMIT)], many=True,
    #                                     context={"request": self.context.get("request")}).data

    def get_store(self, obj):
        # log_request(obj.store)  # This will log the store field to check if it's None
        if obj.store:  # Check if store exists
            return {"id": obj.store.id, "name": obj.store.name, "slug": obj.store.slug,
                    # "seller": obj.store.seller.user.username,
                    "merchant_code": obj.store.seller.merchant_code}
        return None  # Return None or a default value

    def get_total_stock(self, obj):
        query = ProductDetail.objects.filter(product=obj)
        if query:
            return query.aggregate(Sum('stock')).get('stock__sum') or 0
        return 0

    def get_brand(self, obj):
        if obj.brand:  # Check if brand exists
            return obj.brand.name
        return None

    def get_brand_id(self, obj):
        if obj.brand:  # Check if brand exists
            return obj.brand.id
        return None

    def get_average_rating(self, obj):
        rating = 0
        query_set = ProductReview.objects.filter(product=obj)
        if query_set:
            rating = query_set.aggregate(Avg('rating'))['rating__avg'] or 0
        return rating

    def get_positive_reviews(self, obj):
        total_reviews = ProductReview.objects.filter(product__store=obj.store).count()
        positive_reviews = ProductReview.objects.filter(product__store=obj.store, rating__gte=3).count()
        positive_percentage = (positive_reviews / total_reviews * 100) if total_reviews > 0 else 0
        if positive_reviews:
            return round(positive_percentage, 2)
        return None

    def get_rating_count(self, obj):
        ratings = [i.rating for i in obj.productreview_set.all()]
        if len(ratings) < 1:
            return {"one_star": 0, "two_star": 0, "three_star": 0, "four_star": 0, "five_star": 0}

        else:
            one_star = float(ratings.count(1) * 100) / len(ratings)
            two_star = float(ratings.count(2) * 100) / len(ratings)
            three_star = float(ratings.count(3) * 100) / len(ratings)
            four_star = float(ratings.count(4) * 100) / len(ratings)
            five_star = float(ratings.count(5) * 100) / len(ratings)
            return {"one_star": [round(one_star, 2), ratings.count(1)],
                    "two_star": [round(two_star, 2), ratings.count(2)],
                    "three_star": [round(three_star, 2), ratings.count(3)],
                    "four_star": [round(four_star, 2), ratings.count(4)],
                    "five_star": [round(five_star, 2), ratings.count(5)]}

    def get_image(self, obj):
        if obj.image:  # Check if image exists
            request = self.context.get('request')
            if request:
                image_url = request.build_absolute_uri(obj.image.image.url)
                return {"image_url": image_url, "image_id": obj.image.id}
            return {"image_url": obj.image.image.url, "image_id": obj.image.id}
        return None  # Return None or an empty dictionary if no image

    def get_product_detail(self, obj):
        request = self.context.get("request")
        try:
            product_details = ProductDetail.objects.filter(product=obj).order_by('-stock')
        except ProductDetail.DoesNotExist:
            # Handle no ProductDetail objects found (e.g., return an empty list)
            return []
        serializer = ProductDetailSerializer(product_details, many=True, context={"request": request})
        return serializer.data

    def get_product_wishlist_count(self, obj):
        product_wishlist = ProductWishlist.objects.filter(product=obj).count()
        if product_wishlist:
            return product_wishlist
        return None

    # def get_variants(self, obj):
    #     request = self.context.get("request")
    #     serializer = VariantImageSerializer(ProductDetail.objects.filter(product=obj).order_by('-stock'),
    #                                         many=True, context={"request": request})
    #     return serializer.data

    def get_category(self, obj):
        return obj.category.name if obj.category else None

    def get_category_id(self, obj):
        return obj.category.id if obj.category else None

    def get_category_slug(self, obj):
        return obj.category.slug if obj.category else None

    def get_sub_category_id(self, obj):
        return obj.sub_category.id if obj.sub_category else None

    def get_sub_category(self, obj):
        return obj.sub_category.name if obj.sub_category else None

    def get_sub_category_slug(self, obj):
        return obj.sub_category.slug if obj.sub_category else None

    def get_product_type(self, obj):
        return obj.product_type.name if obj.product_type else None

    def get_product_type_id(self, obj):
        return obj.product_type.id if obj.product_type else None

    class Meta:
        model = Product
        exclude = ["search_vector"]


class ProductTypeSerializer(serializers.ModelSerializer):
    sub_category_id = serializers.IntegerField(source="category.id")
    products = serializers.SerializerMethodField()

    def get_products(self, obj):
        request = self.context.get("request", None)
        container = []

        if request is None:
            return []

        product_types = Product.objects.filter(product_type=obj, store__is_active=True, status='active').order_by(
            '-id')[:10]
        for product in product_types:
            product_detail = ProductDetail.objects.filter(product=product).first()
            if product_detail:
                # Check if the product image exists before getting the URL
                image_url = (
                    request.build_absolute_uri(product_detail.product.image.get_image_url())
                    if product_detail.product.image and product_detail.product.image.get_image_url()
                    else None
                )
                container.append({
                    "product_id": product_detail.id,
                    "product_name": product_detail.product.name,
                    "product_slug": product_detail.product.slug,
                    "product_image": image_url,
                    "price": product_detail.price,
                    "discount": product_detail.discount,
                })
        return container

    class Meta:
        model = ProductType
        exclude = ["category"]


class CategoriesSerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()
    sub_categories = serializers.SerializerMethodField()
    product_types = serializers.SerializerMethodField()
    brand = serializers.SerializerMethodField()
    parent_category = serializers.SerializerMethodField()
    new_arrived_products = serializers.SerializerMethodField()

    def get_parent_category(self, obj):
        if obj.parent:
            return {"id": obj.parent.id, "name": obj.parent.name}
        return None

    def get_brand(self, obj):
        if not obj.parent:
            return [{"id": brand.id, "name": brand.name} for brand in obj.brands.all()]
        return None

    def get_image(self, obj):
        request = self.context.get('request', None)
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None

    def get_image_url(self, image, request):
        """Returns the full image URL, handling both internal and external storage."""
        if not image:
            return None
        if image.url.startswith("http"):  # If it's already a full URL, return as is
            return image.url
        return request.build_absolute_uri(image.url)

    def get_sub_categories(self, obj):
        request = self.context.get("request", None)
        if not request:
            return None

        def get_nested_categories(category):
            sub_categories = ProductCategory.objects.filter(parent=category).order_by("-id")
            result = []

            for sub_cat in sub_categories:
                image_url = self.get_image_url(sub_cat.image, request) if sub_cat.image else None
                
                # Get product types for this sub-category
                product_types = ProductType.objects.filter(category=sub_cat)
                product_types_data = [
                    {
                        "id": pt.id,
                        "name": pt.name,
                        "slug": pt.slug,
                        "image": self.get_image_url(pt.image, request) if pt.image else None
                    }
                    for pt in product_types
                ]

                category_data = {
                    "id": sub_cat.id,
                    "name": sub_cat.name,
                    "slug": sub_cat.slug,
                    "image": image_url,
                    "product_types": product_types_data,
                    "sub_categories": get_nested_categories(sub_cat)  # Recursive call
                }
                result.append(category_data)

            return result if result else None

        return get_nested_categories(obj)

    def get_product_types(self, obj):
        request = self.context.get("request", None)
        if request:
            product_types = ProductType.objects.filter(category=obj)
            return ProductTypeSerializer(product_types, many=True, context={"request": request}).data
        return None

    def get_new_arrived_products(self, obj):
        request = self.context.get("request", None)
        if not request:
            return []

        if obj.parent is None:
            query = Product.objects.filter(
                category__id=obj.id, store__is_active=True, status='active'
            ).order_by('-id')[:10]
        else:
            query = Product.objects.filter(
                sub_category__id=obj.id, store__is_active=True, status='active'
            ).order_by('-id')[:10]

        container = []
        for product in query:
            product_detail = ProductDetail.objects.filter(product=product).last()
            price = product_detail.price if product_detail else 0
            discount = product_detail.discount if product_detail else 0
            product_image = (
                request.build_absolute_uri(product.image.image.url)
                if product.image and product.image.image else None
            )
            container.append({
                "product_id": product.id,
                "product_name": product.name,
                "product_slug": product.slug,
                "product_image": product_image,
                "price": price,
                "discount": discount,
            })
        return container

    class Meta:
        model = ProductCategory
        fields = [
            "id", "image", "parent_category", "name", "sub_categories", "brand", "slug", "product_types",
            "new_arrived_products", "created_on", "updated_on"
        ]


class SubCategorySerializer(serializers.ModelSerializer):
    image = serializers.SerializerMethodField()

    class Meta:
        model = ProductCategory
        fields = ["id", "name", "slug", "image"]

    def get_image(self, obj):
        request = self.context.get('request', None)
        if obj.image and request:
            return request.build_absolute_uri(obj.image.url)
        return None


class MallDealSerializer(serializers.ModelSerializer):
    product = serializers.SerializerMethodField()
    banner_id = serializers.IntegerField(source="id")
    image = serializers.SerializerMethodField()

    def get_image(self, obj):
        request = self.context.get("request")
        image = None
        if obj.banner_image:
            image = request.build_absolute_uri(obj.banner_image.url)
        return image

    def get_product(self, obj):
        request = self.context.get("request")
        result = list()
        for product in obj.product.all():
            price = product.productdetail_set.last().price
            discount = product.productdetail_set.last().discount
            p_discount = discount / price
            image = None
            if product.image:
                image = request.build_absolute_uri(product.image.image.url)
            data = {
                'id': product.id,
                'name': product.name,
                'slug': product.slug,
                'image': image,
                'price': price,
                'discount': discount,
                'percentage_discount': f"-{p_discount:.1%}",
                'category': product.category.name,
                'store_name': product.store.name,
                'seller_email': product.store.seller.user.email,
                'rating': product.productreview_set.all().aggregate(Avg('rating'))['rating__avg'] or 0
            }
            result.append(data)
        return result

    class Meta:
        model = Promo
        fields = ['banner_id', 'product', 'image', 'slug']
        depth = 1


# class CartProductSerializer(serializers.ModelSerializer):
#     name = serializers.SerializerMethodField()
#     description = serializers.SerializerMethodField()
#     item_price = serializers.SerializerMethodField()
#     image = serializers.SerializerMethodField()
#
#     def get_name(self, obj):
#         if obj:
#             return obj.product_detail.product.name
#         return None
#
#     def get_description(self, obj):
#         if obj:
#             return obj.product_detail.product.description
#         return None
#
#     def get_item_price(self, obj):
#         if obj:
#             return obj.product_detail.price * obj.quantity
#         return None
#
#     def get_image(self, obj):
#         if self.context.get('request'):
#             request = self.context.get('request')
#             return request.build_absolute_uri(obj.product_detail.product.image.get_image_url())
#         return obj.product_detail.product.image.get_image_url() or None
#
#     class Meta:
#         model = CartProduct
#         fields = ["id", "name", "image", "description", "price", "quantity", "item_price", "discount", "product_detail"]


class ProductWishlistSerializer(serializers.ModelSerializer):
    product = serializers.SerializerMethodField()

    def get_product(self, obj):
        product = None
        if obj.product:
            product = ProductSerializer(obj.product, context={"request": self.context.get("request")}).data
        return product

    class Meta:
        model = ProductWishlist
        exclude = []


class OrderProductSerializer(serializers.ModelSerializer):
    seller_id = serializers.IntegerField(source="product_detail.product.store.seller.id")
    store_name = serializers.CharField(source="product_detail.product.store.name")
    product_id = serializers.CharField(source="product_detail.product.id")
    product_name = serializers.CharField(source="product_detail.product.name")
    product_description = serializers.CharField(source="product_detail.product.description")
    category = serializers.CharField(source="product_detail.product.category.name")
    product_image = serializers.SerializerMethodField()

    def get_product_image(self, obj):
        request = self.context.get("request")
        image = None
        if obj.product_detail.product.image:
            image = request.build_absolute_uri(obj.product_detail.product.image.image.url)
        return image

    class Meta:
        model = OrderProduct
        exclude = ["product_detail"]


class OrderSerializer(serializers.ModelSerializer):
    order_products = serializers.SerializerMethodField()
    no_of_products = serializers.SerializerMethodField()
    order_calculation = serializers.SerializerMethodField()

    address = serializers.CharField(source="address.get_full_address")
    mobile_number = serializers.CharField(source="address.mobile_number")

    def get_order_calculation(self, obj):
        data = dict()
        order_product_total = OrderProduct.objects.filter(order=obj).aggregate(Sum("sub_total"))["sub_total__sum"] or 0
        shipping_fee_total = OrderProduct.objects.filter(order=obj).aggregate(Sum("delivery_fee"))[
                                 "delivery_fee__sum"] or 0
        data["product_total"] = order_product_total
        data["shipping_fee"] = shipping_fee_total
        data["total"] = order_product_total + shipping_fee_total
        return data

    def get_no_of_products(self, obj):
        prod = 0
        if OrderProduct.objects.filter(order=obj).exists():
            prod = OrderProduct.objects.filter(order=obj).count()
        return prod

    def get_order_products(self, obj):
        if OrderProduct.objects.filter(order=obj).exists():
            return OrderProductSerializer(OrderProduct.objects.filter(order=obj), many=True,
                                          context={"request": self.context.get("request")}).data
        return None

    class Meta:
        model = Order
        exclude = ["customer"]
        depth = 1


class BrandSerializer(serializers.ModelSerializer):
    class Meta:
        model = Brand
        exclude = []


class ReturnProductImageSerializer(serializers.ModelSerializer):
    image_url = serializers.SerializerMethodField()

    def get_image_url(self, obj):
        if obj.image:
            request = self.context.get('request')
            if request:
                image = request.build_absolute_uri(obj.image.url)
                return image
            return obj.image.url
        return None

    class Meta:
        model = ReturnProductImage
        exclude = ["id", "return_product", "image"]


class ReturnReasonSerializer(serializers.ModelSerializer):
    class Meta:
        model = ReturnReason
        exclude = []


class ReturnedProductSerializer(serializers.ModelSerializer):
    return_images = serializers.SerializerMethodField()
    return_date = serializers.SerializerMethodField()
    reason = ReturnReasonSerializer()

    description = serializers.CharField(source="product.product_detail.product.description")

    def get_return_date(self, obj):
        if obj:
            return obj.created_on
        return None

    def get_return_images(self, obj):
        if ReturnProductImage.objects.filter(return_product=obj).exists():
            return_product_image = ReturnProductImage.objects.filter(return_product=obj)
            context = self.context.get("request")
            return ReturnProductImageSerializer(return_product_image, many=True, context={"request": context}).data
        return None

    class Meta:
        model = ReturnedProduct
        fields = ['id', 'returned_by', 'return_images', 'product', "description", 'reason', 'status', 'payment_status',
                  'comment',
                  'return_date', 'updated_by', 'updated_on']


class ProductReviewSerializerOut(serializers.ModelSerializer):
    reviewed_by = serializers.CharField(source="user.get_full_name")

    products = serializers.SerializerMethodField()

    def get_products(self, obj):
        # Serialize obj.product directly
        serialized_product = ProductSerializer(
            obj.product, context={"request": self.context.get("request")}
        ).data
        return serialized_product

    class Meta:
        model = ProductReview
        exclude = ["user"]


class ProductReviewSerializerIn(serializers.Serializer):
    auth_user = serializers.HiddenField(default=serializers.CurrentUserDefault())
    product_id = serializers.IntegerField()
    rating = serializers.IntegerField()
    headline = serializers.CharField()
    content = serializers.CharField()
    image = serializers.ImageField(required=False)  # Optional field for image upload

    def validate(self, attrs):

        from django.utils.translation import gettext_lazy as _
        """
        Validate the input data.
        """
        user = attrs.get("auth_user")
        product_id = attrs.get("product_id")

        order_product = OrderProduct.objects.filter(
            order__customer__user=user,
            product_detail__product_id=product_id,
        ).first()

        # Check if the product has been delivered
        if not order_product:
            raise InvalidRequestException(
                {"detail": _("You haven't purchased this product.")}
            )
        if order_product.status != "delivered":
            raise InvalidRequestException(
                {"detail": _("This product must have been delivered to you before leaving a review.")}
            )

        return attrs

    def create(self, validated_data):
        from django.db import transaction
        """
        Create or update a product review.
        """
        user = validated_data["auth_user"]
        product_id = validated_data["product_id"]
        headline = validated_data["headline"]
        rating = validated_data["rating"]
        content = validated_data["content"]
        image = validated_data.get("image", None)

        with transaction.atomic():
            # Create or update the review
            review, created = ProductReview.objects.update_or_create(
                user=user,
                product_id=product_id,
                defaults={
                    "headline": headline,
                    "rating": rating,
                    "review": content,
                    "image": image,
                },
            )

        return ProductReviewSerializerOut(review).data


# Mobile APP
class MobileCategorySerializer(serializers.ModelSerializer):
    products = serializers.SerializerMethodField()
    sub_categories = serializers.SerializerMethodField()

    def get_sub_categories(self, obj):
        cat = None
        if ProductCategory.objects.filter(parent=obj).exists():
            cat = [category.id for category in ProductCategory.objects.filter(parent=obj)]
        return cat

    def get_products(self, obj):
        request = self.context.get("request")
        if Product.objects.filter(category=obj).exists():
            return ProductSerializer(Product.objects.filter(category=obj, status="active"), many=True,
                                     context={"request": request}).data

    class Meta:
        model = ProductCategory
        exclude = []


class DailyDealSerializer(serializers.ModelSerializer):
    product = ProductSerializer()

    class Meta:
        model = DailyDeal
        exclude = []

# class ReturnReasonSerializer(serializers.ModelSerializer):
#     class Meta:
#         model = ReturnReason
#         exclude = []
