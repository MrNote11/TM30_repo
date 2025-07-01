import datetime
import uuid

from django.contrib.auth.models import User
from django.core.exceptions import ValidationError
from django.core.validators import MaxValueValidator, MinValueValidator
from django.db import models
from django.utils.text import slugify

from merchant.models import Seller
from store.choices import product_status_choices, cart_status_choices, payment_status_choices, order_status_choices, \
    order_entry_status

from django.contrib.postgres.search import SearchVectorField
from ckeditor.fields import RichTextField  # If using CKEditor

status_choice = (('active', 'Active'), ('inactive', 'Inactive'))
BANNER_POSITION_CHOICES = (
    ("header_banner", "Header Banner"), ("footer_banner", "Footer Banner"),
    ("big_banner", "Big Banner"), ("medium_banner", "Medium Banner"), ("small_banner", "Small Banner"),
    ("big_deal", "Big Deal"), ("medium_deal", "Medium Deal"), ("small_deal", "Small Deal")
)


# Create your models here.
class Brand(models.Model):
    name = models.CharField(max_length=200)
    image = models.ImageField(upload_to='brand-images', null=True, blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return self.name


class ProductCategory(models.Model):
    name = models.CharField(max_length=100)
    slug = models.CharField(max_length=500, null=True, blank=True, editable=False)
    parent = models.ForeignKey('self', blank=True, null=True, on_delete=models.CASCADE)
    image = models.ImageField(upload_to='category-images', null=False, blank=True)
    brands = models.ManyToManyField(Brand, related_name='brands', blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        temp_slug = f"{self.name.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.name != self.name:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    class Meta:
        verbose_name_plural = 'Product Categories'

    def __str__(self):
        return self.name

    indexes = [
        models.Index(
            fields=['name', 'slug', 'image', 'parent']
        )
    ]


class ProductType(models.Model):
    name = models.CharField(max_length=200)
    slug = models.CharField(max_length=500, null=True, blank=True, editable=False)
    image = models.ImageField(upload_to='product-type-images', blank=True, null=True)
    category = models.ForeignKey(ProductCategory, on_delete=models.CASCADE)
    percentage_commission = models.DecimalField(max_digits=50, decimal_places=2, default=0, null=True, blank=True)
    fixed_commission = models.DecimalField(max_digits=50, decimal_places=2, default=0, null=True, blank=True)
    commission_applicable = models.BooleanField(default=True)

    def save(self, *args, **kwargs):
        temp_slug = f"{self.name.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.name != self.name:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    def __str__(self):
        return self.name


class Image(models.Model):
    image = models.ImageField(upload_to='product-images')
    created_on = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        # Assuming a one-to-many relationship, showing the first ProductImage related to this Image
        product_image = self.productimage_set.first()  # Fetch the first related ProductImage

        # Return the product image name if it exists, otherwise just return the image name
        if product_image:
            return f"Product Image: {product_image.product_detail} - {self.image}"
        else:
            return f"Image: {self.image}"

    def get_image_url(self):
        if not self.image:
            return None
        else:
            return self.image.url

    class Meta:
        indexes = [
            models.Index(fields=['image']),
        ]


class Product(models.Model):
    store = models.ForeignKey('store.Store', on_delete=models.CASCADE, null=True)
    name = models.CharField(max_length=200)
    slug = models.CharField(max_length=500, null=True, blank=True, editable=False, unique=True)
    description = RichTextField(default="<p>No description available</p>")  # Handles HTML input

    # description = models.TextField(help_text='Describe the product', null=True)
    image = models.ForeignKey(Image, on_delete=models.SET_NULL, null=True, blank=True)
    category = models.ForeignKey(ProductCategory, on_delete=models.CASCADE, blank=True, null=True,
                                 related_name='category')
    sub_category = models.ForeignKey(ProductCategory, blank=True, null=True, on_delete=models.CASCADE)
    product_type = models.ForeignKey(ProductType, on_delete=models.CASCADE, null=True, blank=True)
    brand = models.ForeignKey(Brand, on_delete=models.SET_NULL, null=True, blank=True)
    tags = models.TextField(blank=True, null=True)
    status = models.CharField(choices=product_status_choices, max_length=10, default='active')
    decline_reason = models.CharField(max_length=200, blank=True, null=True)

    # Recommended Product: should be updated to 'True' once the merchant makes' payment.
    is_featured = models.BooleanField(default=False)

    discount_end_time = models.DateTimeField(blank=True, null=True)
    choice = models.BooleanField(default=False)
    free_shipping = models.BooleanField(default=False)

    seasonal_pick = models.BooleanField(default=False)

    # View Count: number of times the product is viewed by users.
    view_count = models.PositiveBigIntegerField(default=0)
    last_viewed_date = models.DateTimeField(blank=True, null=True)

    # Top Selling: The highest sold product. Field updates when this product has been successfully paid for.
    sale_count = models.IntegerField(default=0)

    published_on = models.DateTimeField(blank=True, null=True)
    checked_by = models.ForeignKey(User, on_delete=models.SET_NULL, blank=True, null=True,
                                   related_name="product_checked_by")
    approved_by = models.ForeignKey(User, on_delete=models.SET_NULL, blank=True, null=True,
                                    related_name="product_approved_by")
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    search_vector = SearchVectorField(null=True)  # This is the search index

    def save(self, *args, **kwargs):
        temp_slug = f"{self.name.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.name != self.name:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    def __str__(self):
        return self.name

    indexes = [
        models.Index(
            fields=['name', 'slug', 'description', 'discount_end_time',
                    "choice", "sale_count", "free_shipping"]
        )
    ]


class ProductDetail(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    # description = models.TextField(help_text='Describe the product')
    sku = models.CharField(max_length=100, blank=True, null=True)
    size = models.CharField(max_length=100, blank=True, null=True)
    color = models.CharField(max_length=100, default='White')
    weight = models.FloatField(default=0, validators=[MinValueValidator(0)])
    length = models.FloatField(default=0, validators=[MinValueValidator(0)])
    width = models.FloatField(default=0, validators=[MinValueValidator(0)])
    height = models.FloatField(default=0, validators=[MinValueValidator(0)])

    price = models.DecimalField(default=0, max_digits=20, decimal_places=2, validators=[MinValueValidator(0)])
    discount = models.DecimalField(default=0, max_digits=20, decimal_places=2, validators=[MinValueValidator(0)])
    stock = models.PositiveIntegerField(default=1, validators=[MinValueValidator(0)])

    low_stock_threshold = models.IntegerField(default=5, validators=[MinValueValidator(0)])
    shipping_days = models.IntegerField(default=3, validators=[MinValueValidator(0)])
    out_of_stock_date = models.DateTimeField(null=True, blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        if self.stock < 0:
            raise ValidationError(f"Stock cannot be negative for product ID {self.product.id} (Name: {self.product.name}). Current stock: {self.stock}")

        super().save(*args, **kwargs)

    def __str__(self):
        return f'{self.id}: {self.product}'

    indexes = [
        models.Index(
            fields=['product', 'price']
        )
    ]


class ProductImage(models.Model):
    # product_detail = models.ForeignKey(ProductDetail, on_delete=models.CASCADE, related_name='product_detail')

    product_detail = models.ForeignKey(ProductDetail, on_delete=models.CASCADE, related_name='product_images')  # Avoid 'product_detail'

    image = models.ForeignKey(Image, on_delete=models.CASCADE, null=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f'{self.id}:{self.product_detail}'

    class Meta:
        indexes = [
            models.Index(fields=['product_detail', 'image']),
        ]


class ProductReview(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    rating = models.IntegerField(default=0, validators=[MaxValueValidator(5)])
    headline = models.CharField(max_length=250)
    review = models.TextField()
    created_on = models.DateTimeField(auto_now_add=True)

    image = models.ImageField(upload_to="review_images/", null=True, blank=True)  # New field

    def __str__(self):
        return "{} {}".format(self.user, self.product)

    class Meta:
        indexes = [
            models.Index(fields=['user', 'product', 'rating', "review"]),
        ]


class ProductWishlist(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    created_on = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return "{} {}".format(self.user, self.product)

    class Meta:
        verbose_name_plural = "Product Wishlists"

    class Meta:
        indexes = [
            models.Index(fields=['user', "product"]),
        ]


class Shipper(models.Model):
    name = models.CharField(max_length=50)
    description = models.CharField(max_length=200)
    shipper_image = models.ImageField(upload_to='shipper-image', blank=True, null=True)

    slug = models.CharField(max_length=20, unique=True)
    vat_fee = models.DecimalField(max_digits=10, decimal_places=2, default=7.5)
    is_active = models.BooleanField(default=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        temp_slug = f"{self.name.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.name != self.name:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    def __str__(self):
        return self.name

    class Meta:
        indexes = [
            models.Index(fields=['name', 'slug', "description"]),

        ]


class Cart(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE, null=True, blank=True)
    cart_uid = models.CharField(max_length=200, default="", null=True, blank=True)
    status = models.CharField(max_length=20, default='open', choices=cart_status_choices)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"{self.id}: {self.cart_uid}-{self.user}-{self.status}"

    class Meta:
        indexes = [
            models.Index(fields=['user', "cart_uid", "status"]),
        ]


class CartProduct(models.Model):
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE)
    product_detail = models.ForeignKey(ProductDetail, on_delete=models.CASCADE)
    price = models.DecimalField(default=0, decimal_places=2, max_digits=20, validators=[MinValueValidator(0)])
    quantity = models.IntegerField(default=0, validators=[MinValueValidator(0)])
    discount = models.DecimalField(default=0, decimal_places=2, max_digits=20, validators=[MinValueValidator(0)])

    status = models.CharField(max_length=20, default='open', choices=cart_status_choices)  # New field
    selected = models.BooleanField(default=False)  # New field

    shipper_name = models.CharField(max_length=200, null=True, blank=True)
    company_id = models.CharField(max_length=200, null=True, blank=True)
    delivery_fee = models.DecimalField(default=0, decimal_places=2, max_digits=50, null=True, blank=True)

    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return "{}: {} {}".format(self.id, self.cart, self.product_detail)

    def clean(self):
        if self.quantity <= 0:
            raise ValidationError('Quantity must be greater than zero.')

    def save(self, *args, **kwargs):
        self.clean()  # Validate before saving
        super().save(*args, **kwargs)

    class Meta:
        indexes = [
            models.Index(fields=['cart', "product_detail", "price", "quantity",
                                 ]),

        ]


# class CartBill(models.Model):
#     cart = models.OneToOneField(Cart, on_delete=models.CASCADE)
#     # shipper = models.ForeignKey(Shipper, on_delete=models.SET_NULL, blank=True, null=True)
#     shipper_name = models.CharField(max_length=100, default="")
#     item_total = models.DecimalField(default=0.0, decimal_places=2, max_digits=10)
#     discount = models.DecimalField(default=0.0, decimal_places=2, max_digits=10)
#     delivery_fee = models.DecimalField(default=0.0, decimal_places=2, max_digits=10)
#     management_fee = models.DecimalField(decimal_places=2, max_digits=10, default=0.0)
#     total = models.DecimalField(default=0.0, decimal_places=2, max_digits=10)
#     created_on = models.DateTimeField(auto_now_add=True)
#     updated_on = models.DateTimeField(auto_now=True)
#
#     def __str__(self):
#         return "{} {}".format(self.cart, self.total)


DEAL_DISCOUNT_TYPE_CHOICES = (
    ('fixed', 'Fixed Amount'), ('percentage', 'Percentage'), ('amount_off', 'Amount Off')
)
PROMO_TYPE = (
    ('banner', 'Banner'), ('deal', 'Deal'), ('promo', 'Promo')
)


class Promo(models.Model):
    title = models.CharField(max_length=100)
    slug = models.CharField(max_length=500, null=True, blank=True, editable=False)
    fixed_price = models.DecimalField(max_digits=50, decimal_places=2, null=True, blank=True, default=0)
    percentage_discount = models.DecimalField(max_digits=50, decimal_places=2, null=True, blank=True, default=0)
    amount_discount = models.DecimalField(max_digits=50, decimal_places=2, null=True, blank=True, default=0)
    discount_type = models.CharField(max_length=50, default='fixed', choices=DEAL_DISCOUNT_TYPE_CHOICES)
    promo_type = models.CharField(max_length=50, default='promo', choices=PROMO_TYPE)
    details = models.TextField(null=True, blank=True)
    merchant = models.ManyToManyField(Seller, blank=True)
    category = models.ManyToManyField(ProductCategory, blank=True)
    sub_category = models.ManyToManyField(ProductCategory, blank=True, related_name='sub_category')
    product_type = models.ManyToManyField(ProductType, blank=True)
    product = models.ManyToManyField(Product, blank=True)
    banner_image = models.ImageField(upload_to='promo-banners', null=True, blank=True)
    position = models.CharField(max_length=300, choices=BANNER_POSITION_CHOICES, blank=True, null=True)
    status = models.CharField(max_length=50, default='active', choices=status_choice)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        temp_slug = f"{self.title.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.title != self.title:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.merchant} - {self.status}"


class Order(models.Model):
    customer = models.ForeignKey("account.Profile", on_delete=models.SET_NULL, null=True)
    cart = models.ForeignKey(Cart, on_delete=models.SET_NULL, null=True)
    address = models.ForeignKey("account.Address", on_delete=models.SET_NULL, null=True)
    payment_status = models.CharField(max_length=200, choices=payment_status_choices, default="pending")
    created_on = models.DateTimeField(auto_now_add=True)
    updates_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"ID: {self.id}, {self.customer} - {self.cart_id}"

    class Meta:
        indexes = [
            models.Index(fields=['cart', "customer", "address", "payment_status"])
        ]


class OrderProduct(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE)
    product_detail = models.ForeignKey(ProductDetail, on_delete=models.SET_NULL, null=True)
    price = models.DecimalField(max_digits=50, decimal_places=2, default=0, validators=[MinValueValidator(0)])
    quantity = models.IntegerField(default=1, validators=[MinValueValidator(0)])
    discount = models.DecimalField(max_digits=50, decimal_places=2, default=0, validators=[MinValueValidator(0)])
    sub_total = models.DecimalField(max_digits=50, decimal_places=2, default=0, validators=[MinValueValidator(0)])
    total = models.DecimalField(max_digits=50, decimal_places=2, default=0, validators=[MinValueValidator(0)])
    shipper_name = models.CharField(max_length=200, null=True, blank=True)
    company_id = models.CharField(max_length=200, null=True, blank=True)
    tracking_id = models.CharField(max_length=200, null=True, blank=True)
    waybill_no = models.CharField(max_length=200, null=True, blank=True)
    payment_method = models.CharField(max_length=200, null=True, blank=True)
    delivery_fee = models.DecimalField(default=0, decimal_places=2, max_digits=50, null=True, blank=True, validators=[MinValueValidator(0)])

    status = models.CharField(max_length=50, choices=order_status_choices, default='pending')  # changed from paid status

    delivery_date = models.DateField(null=True, blank=True)
    booked = models.BooleanField(default=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)
    cancelled_by = models.ForeignKey(User, on_delete=models.SET_NULL, null=True, blank=True)
    cancelled_on = models.DateTimeField(null=True, blank=True)
    packed_on = models.DateTimeField(null=True, blank=True)
    shipped_on = models.DateTimeField(null=True, blank=True)
    delivered_on = models.DateTimeField(null=True, blank=True)
    returned_on = models.DateTimeField(null=True, blank=True)
    payment_on = models.DateTimeField(null=True, blank=True)
    refunded_on = models.DateTimeField(null=True, blank=True)
    request_for_return = models.BooleanField(default=False)

    class Meta:
        verbose_name_plural = "Order Products"
        indexes = [
            models.Index(
                fields=['price', 'quantity', 'discount', 'total', 'status', 'delivery_date', 'created_on',
                        'updated_on', 'cancelled_on', 'packed_on', 'shipped_on', 'delivered_on', 'returned_on',
                        'payment_on', 'refunded_on', 'request_for_return']
            )
        ]

    def __str__(self):
        return "{}: {} {}".format(self.pk, self.order, self.product_detail)


class ReturnReason(models.Model):
    reason = models.CharField(max_length=200)

    def __str__(self):
        return self.reason


RETURNED_STATUS_CHOICES = (
    ('pending', 'Pending'),
    ('approved', 'Approved'),
    ('success', 'Success'),
    ('failed', 'Failed'),
    ('rejected', 'Rejected'),
)


class ReturnedProduct(models.Model):
    returned_by = models.ForeignKey(User, on_delete=models.CASCADE, default=None, null=True)
    product = models.ForeignKey(OrderProduct, on_delete=models.CASCADE, )
    reason = models.ForeignKey(ReturnReason, on_delete=models.CASCADE, null=True, blank=True)
    status = models.CharField(max_length=50, choices=RETURNED_STATUS_CHOICES, default='pending', blank=True, null=True)
    payment_status = models.CharField(max_length=50, choices=RETURNED_STATUS_CHOICES, default='pending', blank=True,
                                      null=True)
    comment = models.TextField(null=True, blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_by = models.ForeignKey(User, on_delete=models.CASCADE, related_name='updated_by', blank=True, null=True,
                                   default='')
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return "{} {} {}".format(self.returned_by, self.product, self.reason)

    class Meta:
        indexes = [
            models.Index(
                fields=['status', 'payment_status', 'created_on', 'updated_on']
            )
        ]


class ReturnProductImage(models.Model):
    return_product = models.ForeignKey(ReturnedProduct, on_delete=models.CASCADE)
    image = models.ImageField(upload_to="returns", null=True, blank=True)
    is_primary = models.BooleanField(default=False)

    def __str__(self):
        # return f'{self.return_product} {self.image}'
        return f'{self.return_product}'


class OrderEntry(models.Model):
    order = models.ForeignKey(Order, on_delete=models.CASCADE, null=True, blank=True, )
    cart = models.ForeignKey(Cart, on_delete=models.CASCADE, null=True)
    seller = models.ForeignKey(Seller, on_delete=models.CASCADE)
    item_total = models.DecimalField(decimal_places=2, max_digits=20, default=0, validators=[MinValueValidator(0)])
    management_fee = models.DecimalField(decimal_places=2, max_digits=20, default=0, validators=[MinValueValidator(0)])
    delivery_fee = models.DecimalField(decimal_places=2, max_digits=20, default=0, validators=[MinValueValidator(0)])
    total = models.DecimalField(decimal_places=2, max_digits=20, default=0, validators=[MinValueValidator(0)])
    status = models.CharField(max_length=50, choices=order_entry_status, default='packed')
    notified_for = models.CharField(max_length=200, null=True, blank=True)
    order_no = models.CharField(max_length=100, blank=True, null=True)
    tracking_id = models.CharField(max_length=100, blank=True, null=True)
    shipper_settled = models.BooleanField(null=True, blank=True, default=False)
    shipper_settled_date = models.DateTimeField(null=True, blank=True)
    merchant_settled = models.BooleanField(null=True, blank=True, default=False)
    merchant_settled_date = models.DateTimeField(null=True, blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return "(ID: {}) - {}: {}".format(self.id, self.merchant, self.cart)

    class Meta:
        verbose_name_plural = "Order Entries"
        indexes = [
            models.Index(
                fields=['item_total', 'management_fee', 'delivery_fee', 'total', 'status', 'order_no', 'tracking_id',
                        'merchant_settled', 'created_on', 'updated_on']
            )
        ]


class DailyDeal(models.Model):
    product = models.ForeignKey(Product, on_delete=models.CASCADE)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def __str__(self):
        return f"ID {self.id}: - {self.product.name}"
