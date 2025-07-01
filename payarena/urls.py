from django.conf import settings
from django.conf.urls.static import static
from django.contrib import admin
from django.urls import path, include
from drf_spectacular.views import SpectacularAPIView, SpectacularSwaggerView

urlpatterns = [
    path('', include('home.urls')),
    path('account/', include('account.urls')),
    path('store/', include('store.urls')),
    path('seller/', include('merchant.urls')),
    path('location/', include('location.urls')),
    path('superadmin/', include('superadmin.urls')),
    path('ecommerce/', include('ecommerce.urls')),
    path('transaction/', include('transaction.urls')),
    path('admin/', admin.site.urls),

    # path('prometheus-xyzabc/', include('django_prometheus.urls')),

    # path('auth/', include('social_django.urls', namespace='social')),
    # Enables the /auth/complete/facebook/ and /auth/complete/google/ endpoints

    # Swagger URLs
    path("api/schema/", SpectacularAPIView.as_view(), name="schema"),
    path("api/schema/docs/", SpectacularSwaggerView.as_view(url_name="schema")),

]

urlpatterns += static(settings.MEDIA_URL, document_root=settings.MEDIA_ROOT)
urlpatterns += static(settings.STATIC_URL, document_root=settings.STATIC_ROOT)
