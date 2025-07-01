from decimal import Decimal

from django.db.models import Sum, Avg, F
from rest_framework import serializers

from account.models import Profile
from ecommerce.models import ProductImage, ProductReview, ProductWishlist, CartProduct, Brand, Product, \
    ProductDetail, Shipper, Cart
from merchant.models import MerchantBanner
from merchant.serializers import SellerSerializer
from .models import *


class BrandSerializer(serializers.ModelSerializer):
    class Meta:
        model = Brand
        exclude = []


class ProductCategorySerializer(serializers.ModelSerializer):
    brands = BrandSerializer(many=True, read_only=True, )
    total_products = serializers.SerializerMethodField()
    total_variants = serializers.SerializerMethodField()

    def get_total_products(self, obj):
        total = 0
        if Product.objects.filter(category=obj).exists():
            total = Product.objects.filter(category=obj).count()
        return total

    def get_total_variants(self, obj):
        variants = 0
        if ProductDetail.objects.filter(product__category=obj).exists():
            variants = ProductDetail.objects.filter(product__category=obj).count()
        return variants

    class Meta:
        model = ProductCategory
        exclude = []


class StoreProductSerializer(serializers.ModelSerializer):
    average_rating = serializers.SerializerMethodField()
    image = serializers.SerializerMethodField()
    price = serializers.SerializerMethodField()
    discount = serializers.SerializerMethodField()
    product_detail_id = serializers.SerializerMethodField()

    def get_product_detail_id(self, obj):
        prod = None
        if ProductDetail.objects.filter(product=obj).exists():
            prod = ProductDetail.objects.filter(product=obj).first().id
        return prod

    def get_image(self, obj):
        if obj.image:
            return self.context.get("request").build_absolute_uri(obj.image.image.url)
        return None

    def get_price(self, obj):
        price = 0
        if ProductDetail.objects.filter(product=obj).exists():
            price = ProductDetail.objects.filter(product=obj).first().price
        return price

    def get_discount(self, obj):
        discount = 0
        if ProductDetail.objects.filter(product=obj).exists():
            discount = ProductDetail.objects.filter(product=obj).first().discount
        return discount

    def get_average_rating(self, obj):
        return ProductReview.objects.filter(product=obj).aggregate(Avg('rating'))['rating__avg'] or 0

    class Meta:
        model = Product
        fields = [
            "id", "name", "slug", "category", "image", "description", "average_rating", "price", "discount", "sale_count",
            "view_count", "product_detail_id"
        ]


class StoreSerializer(serializers.ModelSerializer):
    seller = SellerSerializer(many=False)
    products = serializers.SerializerMethodField()
    total_followers = serializers.SerializerMethodField()
    banner_image = serializers.SerializerMethodField()

    class Meta:
        model = Store
        exclude = []
        depth = 1  # Decrease depth for performance, modify as needed

    def get_banner_image(self, obj):
        """
        Fetch the latest banner image for the store's seller, return absolute URL.
        """
        request = self.context.get("request")
        # Fetch the last banner image for the store's seller if it exists
        banner = MerchantBanner.objects.filter(seller=obj.seller).order_by('-id').first()

        if banner and banner.banner_image:
            return request.build_absolute_uri(banner.banner_image.url)

        return None

    def get_products(self, obj):
        """
        Group products into 'recent' and 'best_selling' categories for the store.
        """
        request = self.context.get("request")
        recent_products = Product.objects.filter(store=obj, status="active").order_by("-created_on")[:10]
        best_selling_products = Product.objects.filter(store=obj, status="active").order_by("-sale_count")[:10]

        return {
            "recent": StoreProductSerializer(recent_products, many=True, context={"request": request}).data,
            "best_selling": StoreProductSerializer(best_selling_products, many=True, context={"request": request}).data
        }

    def get_total_followers(self, obj):
        """
        Get the total number of followers for the store by counting profiles with the store in the 'following' field.
        """
        # Using count() directly for better performance instead of fetching the whole queryset
        return Profile.objects.filter(following=obj).count()


class ProductSerializer(serializers.ModelSerializer):
    """
        This serializer is used for serializing Product Model
        and this serializer is used for listing out all products and
        retrieve a particular product.
    """

    store = StoreSerializer(many=False)

    class Meta:
        model = Product
        fields = [
            'store',
            'name',
            'category',
            'sub_category',
            'tags',
            'status',
            'created_on',
            'updated_on'
        ]
        depth = 2


class ProductDetailSerializer(serializers.ModelSerializer):
    product = ProductSerializer(many=False)
    brand = BrandSerializer(many=False)

    class Meta:
        model = ProductDetail
        fields = [
            'id',
            'product',
            'brand',
            'description',
            'sku',
            'size',
            'color',
            'weight',
            'length',
            'width',
            'height',
            'stock',
            'price',
            'discount',
            'low_stock_threshold',
            'shipping_days',
            'out_of_stock_date',
            'created_on',
            'updated_on',
        ]


class ProductImageSerializer(serializers.ModelSerializer):
    product_detail = ProductDetailSerializer(many=False)

    class Meta:
        model = ProductImage
        fields = [
            'id',
            'product_detail',
            'image',
            'created_on',
            'updated_on',
        ]


class ProductReviewSerializer(serializers.ModelSerializer):
    product = ProductSerializer(many=False)

    class Meta:
        model = ProductReview
        fields = ['id', 'product', 'rating']


class ShipperSerializer(serializers.ModelSerializer):
    class Meta:
        model = Shipper
        exclude = ()


class CartProductSerializer(serializers.ModelSerializer):
    # variant_id = serializers.IntegerField(source="product_detail.id")
    store_name = serializers.CharField(source="product_detail.product.store.name")
    store_merchant_code = serializers.CharField(source="product_detail.product.store.seller.merchant_code")
    product_name = serializers.CharField(source="product_detail.product.name")
    product_id = serializers.IntegerField(source="product_detail.product.id")
    product_stock = serializers.IntegerField(source="product_detail.stock")
    product_slug = serializers.CharField(source="product_detail.product.slug")
    description = serializers.CharField(source="product_detail.product.description")
    image = serializers.SerializerMethodField()  # For the primary image
    image_list = serializers.SerializerMethodField()  # For the list of images
    selected = serializers.BooleanField()  # Include selected field

    def get_image(self, obj):
        """Get the primary product image."""
        request = self.context.get("request")
        image_url = None
        if obj.product_detail.product.image:
            if request:  # Ensure request is not None
                image_url = request.build_absolute_uri(obj.product_detail.product.image.image.url)
            else:
                image_url = obj.product_detail.product.image.image.url  # Relative URL as fallback
        return image_url

    def get_image_list(self, obj):
        """Get the list of images related to the product."""
        request = self.context.get("request")
        images = ProductImage.objects.filter(product_detail=obj.product_detail)
        if images.exists():
            if request:  # Ensure request is not None
                return [
                    {
                        "id": instance.id,
                        "url": str(request.build_absolute_uri(instance.image.image.url)),
                    }
                    for instance in images
                ]
            else:
                return [
                    {
                        "id": instance.id,
                        "url": str(instance.image.image.url),
                    }
                    for instance in images
                ]  # Relative URLs as fallback
        return []

    class Meta:
        model = CartProduct
        fields = [
            'id', 'store_name', 'store_merchant_code', "product_slug", 'product_id', "product_stock",
            'product_name', 'description', 'image', 'price', 'quantity', 'shipper_name', 'company_id',
            'discount', 'created_on', 'updated_on', 'image', "selected",
            'image_list',
        ]


class CartSerializer(serializers.ModelSerializer):
    cart_products = serializers.SerializerMethodField()
    total_items = serializers.SerializerMethodField()
    total_selected_items = serializers.SerializerMethodField()
    total_selected_items_quantity = serializers.SerializerMethodField()
    amount_summary = serializers.SerializerMethodField()
    all_amount_summary = serializers.SerializerMethodField()

    def get_amount_summary(self, obj):
        # Calculate subtotal for selected items: price * quantity
        subtotal = CartProduct.objects.filter(cart=obj, selected=True, status="open").aggregate(
            subtotal=Sum(F("price") * F("quantity"))
        )["subtotal"] or 0

        # You could also calculate any additional details, like taxes or delivery fees, if needed:
        delivery_fee = self.context.get("delivery_fee", Decimal("0"))  # Example external fee input
        # tax = Decimal("0.01") * subtotal  # Example tax calculation at 1%

        total = subtotal + delivery_fee
        # total = subtotal + delivery_fee + tax

        return {
            "subtotal": subtotal,
            "delivery_fee": delivery_fee,
            # "tax": tax,
            "total": total
        }

    def get_all_amount_summary(self, obj):
        # Calculate subtotal for selected items: price * quantity
        subtotal = CartProduct.objects.filter(cart=obj, status="open").aggregate(
            subtotal=Sum(F("price") * F("quantity"))
        )["subtotal"] or 0

        # You could also calculate any additional details, like taxes or delivery fees, if needed:
        delivery_fee = self.context.get("delivery_fee", Decimal("0"))  # Example external fee input
        # tax = Decimal("0.1") * subtotal  # Example tax calculation at 10%

        total = subtotal + delivery_fee
        # total = subtotal + delivery_fee + tax

        return {
            "subtotal": subtotal,
            "delivery_fee": delivery_fee,
            # "tax": tax,
            "total": total
        }

    def get_total_items(self, obj):
        return CartProduct.objects.filter(cart=obj, status="open").count() or 0

    def get_total_selected_items(self, obj):
        return CartProduct.objects.filter(cart=obj, selected=True, status="open").count() or 0

    def get_total_selected_items_quantity(self, obj):
        # Total count of selected items in the cart
        return CartProduct.objects.filter(cart=obj, selected=True, status="open").aggregate(total_quantity=Sum("quantity"))[
            "total_quantity"] or 0

    def get_cart_products(self, obj):
        request = self.context.get("request")
        if CartProduct.objects.filter(cart=obj, status="open").exists():
            return CartProductSerializer(CartProduct.objects.filter(cart=obj).order_by("-id"), context={"request": request}, many=True).data
        return None

    class Meta:
        model = Cart
        exclude = ["user"]


class CartUpdateSerializer(serializers.Serializer):
    product_slug = serializers.CharField(required=False)
    quantity = serializers.IntegerField(required=False, min_value=1)
    selected = serializers.BooleanField(required=True)
    select_all = serializers.BooleanField(required=True)

    def validate(self, data):
        # Ensure that either "product_slug" or "select_all" is provided, but not both at the same time.
        product_slug = data.get('product_slug')
        select_all = data.get('select_all')

        if select_all:
            if product_slug:
                raise serializers.ValidationError({
                    "error": "Cannot provide 'product_slug' when 'select_all' is set to true."})
            if 'quantity' in data:
                raise serializers.ValidationError({"error": "Quantity should not be provided when 'select_all' is true."})
        else:
            if not product_slug:
                raise serializers.ValidationError({"error": "Product slug is required when 'select_all' is false."})
            if 'quantity' not in data:
                data['quantity'] = 1  # Set default quantity to 1 if not provided

        return data
