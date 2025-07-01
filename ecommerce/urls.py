from django.urls import path
from ecommerce import views

app_name = "ecommerce"

urlpatterns = [
    path("", views.MallLandPageView.as_view(), name="mall-land-page"),

    path("category-section/", views.MallCategorySectionView.as_view(), name="mall-land-page"),

    path("product-types/", views.ProductTypeListAPIView.as_view(), name="product-types"),
    path("banner-promo/", views.BannerPromoListAPIView.as_view(), name="banner-promo"),
    path("banner-promo/<str:slug>/", views.BannerPromoDetailAPIView.as_view(), name="banner-promo-detail"),

    path("categories/", views.CategoriesView.as_view(), name="categories"),
    path("categories/<str:slug>/", views.CategoriesView.as_view(), name="categories-detail"),

    path("category/<str:category_slug>/", views.ProductInCategoryView.as_view(), name="products-in-category"),

    path('category/<str:category_slug>/sub-category/<str:sub_category_slug>/', views.ProductInCategoryView.as_view(),
         name='products-in-sub-category'),

    path("top-selling/", views.TopSellingProductsView.as_view(), name="top-selling"),
    path("recommended-products/", views.RecommendedProductView.as_view(), name="recommended-products"),

    path("filtered-search/", views.FilteredSearchView.as_view(), name="filter-search"),
    path("product-filter/", views.ProductFilterAPIView.as_view(), name="product-filter"),

    path("category-filter/", views.CategoryFilterAPIView.as_view(), name="category-filter"),

    # CART
    path("cart/", views.CartProductOperationsView.as_view(), name="add-to-cart"),
    path("cart/<str:id>/", views.CartProductOperationsView.as_view(), name="cart-products"),

    path('product-cart-items/<str:product_slug>/', views.ProductDetailOfCartView.as_view(), name='product_cart_items'),

    path('cart-items/', views.CartItemsView.as_view(), name='cart_items'),
    path('cart/modify/<str:product_slug>/', views.ModifyCartAPIView.as_view(), name='modify_cart'),
    path('cart/modify/bulk/', views.ModifyCartAPIView.as_view(), name='bulk_modify_cart'),  # For bulk removal

    # Shipping module
    path('get-shipping/', views.GetExternalShipping.as_view(), name='external-shipping'),
    path('get-location/', views.GetExternalLocation.as_view(), name='external-location'),

    # Wishlist
    path("wishlist/", views.ProductWishlistView.as_view(), name="wishlist"),  # GET, POST
    path('wishlist/<int:id>/', views.ProductWishlistView.as_view(), name='wishlist-detail'),
    # path("wishlist/<int:id>/", views.RetrieveDeleteWishlistView.as_view(), name="wishlist-detail"),

    # Products
    path("product/", views.ProductView.as_view(), name="product"),
    # path("product/<str:slug>/", views.ProductView.as_view(), name="product-detail"),
    path("product/<str:slug>/", views.ProductDetailView.as_view(), name="product-detail"),
    path('recently-viewed-products/', views.RecentlyViewedProductsView.as_view(), name='recently-viewed-products'),

    # Order
    path("checkout-summary/", views.CheckoutView.as_view(), name="checkout"), # favour did

    path("track-order", views.TrackOrderAPIView.as_view(), name="track-order"),
    path("order/", views.OrderAPIView.as_view(), name="orders"),
    path("order/<int:pk>/", views.OrderAPIView.as_view(), name="order-detail"),
    path("order/return/<int:pk>/", views.OrderReturnView.as_view(), name="return-order-detail"),
    path("order/return/", views.OrderReturnView.as_view(), name="return-all"),

    # Return Reasons
    path('return-reason/', views.ReturnReasonListAPIView.as_view(), name='return-reason'),
    path('return-reason/<int:id>/', views.ReturnReasonRetrieveAPIView.as_view(), name='return-reason-detail'),

    # Customer Dashboard
    path("dashboard/", views.CustomerDashboardView.as_view(), name="customer-dashboard"),

    path("customer/overview/", views.CustomerOverviewAPIView.as_view(), name="customer-overview"),
    path("customer/order/", views.CustomerOrdersAPIView.as_view(), name="customer-order"),
    path("customer/order/<int:order_id>/", views.CustomerOrderDetailsAPIView.as_view(), name="customer-order-detail"),
    path("customer/product-review/", views.CustomerProductReviewAPIView.as_view(), name="customer-product-review"),
    path("customer/wallet/", views.CustomerWalletAPIView.as_view(), name="customer-wallet"),

    # Product Review
    path("review/", views.ProductReviewAPIView.as_view(), name="review"),

    # Name Enquiry
    path("name-enquiry/", views.NameEnquiryAPIView.as_view(), name="name-enquiry"),

    # Mobile APP
    path("mobile/category/", views.MobileCategoryListAPIView.as_view(), name="mobile-category"),
    path("mobile/category/<str:slug>/", views.MobileCategoryDetailRetrieveAPIView.as_view(),
         name="mobile-category-detail"),
    path("mobile/store", views.MobileStoreListAPIView.as_view(), name="mobile-store"),
    path("mobile/store/<str:slug>/", views.MobileStoreDetailRetrieveAPIView.as_view(), name="mobile-store-detail"),
    path("mobile/store/<str:store_slug>/product", views.MiniStoreAPIView.as_view(), name="mobile-store-detail"),

    # Followers
    path('mobile/follow/', views.StoreFollowerAPIView.as_view(), name='follower'),

    # Cron
    path('cron/delete-cart/', views.RemoveRedundantCartCronView.as_view(), name='cart-cron'),
    path('cron/retry-pickup/', views.RetryOrderBookingCronView.as_view(), name='retry-pickup'),

]
