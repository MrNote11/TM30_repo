from ckeditor.widgets import CKEditorWidget
from django.contrib import admin
from django.forms import ModelForm

from ecommerce.models import ProductImage, ProductReview, CartProduct, ProductDetail, Brand, Product, Shipper, \
    Cart
from .models import *

admin.site.register(CartProduct)


class BrandAdmin(admin.ModelAdmin):
    exclude = []


class ProductCategoryAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'parent', 'created_on']
    list_filter = ['created_on']
    search_fields = ['name']


class ProductCategoryInline(admin.TabularInline):
    model = ProductCategory
    extra = 1


class StoreAdmin(admin.ModelAdmin):
    list_display = ['seller', 'name', 'is_active', 'created_on']
    list_filter = ['is_active', 'created_on']
    search_fields = ['name']


class ProductDetailInline(admin.TabularInline):
    model = ProductDetail
    extra = 1


class ProductImageInline(admin.StackedInline):
    model = ProductImage
    extra = 1


class ProductDetailAdmin(admin.ModelAdmin):
    list_display = ['product', 'price', 'stock', 'created_on']
    search_fields = ['product__name']
    inlines = [ProductImageInline]


class ProductReviewInline(admin.TabularInline):
    model = ProductReview
    extra = 1


class ProductAdminForm(ModelForm):
    class Meta:
        model = Product
        fields = "__all__"
        widgets = {
            "description": CKEditorWidget(),
        }


class ProductAdmin(admin.ModelAdmin):
    list_display = ['name', 'slug', 'category', 'sub_category', 'status', 'created_on']
    list_filter = ['category', 'sub_category', 'status', 'created_on']
    search_fields = ['name', 'tags']
    form = ProductAdminForm
    inlines = [ProductDetailInline, ProductReviewInline]


class ShipperAdmin(admin.ModelAdmin):
    exclude = []


class CartProductInline(admin.TabularInline):
    model = CartProduct
    extra = 1


class CartAdmin(admin.ModelAdmin):
    list_filter = ['status']
    inlines = [CartProductInline]


admin.site.register(Brand, BrandAdmin)
admin.site.register(ProductCategory, ProductCategoryAdmin)
admin.site.register(Store, StoreAdmin)
admin.site.register(Product, ProductAdmin)
admin.site.register(Shipper, ShipperAdmin)
admin.site.register(Cart, CartAdmin)
admin.site.register(ProductDetail, ProductDetailAdmin)
admin.site.register(ProductImage)
admin.site.register(ProductReview)

