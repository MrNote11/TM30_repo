import os
import logging
from pathlib import Path
from datetime import timedelta
import environ
from datetime import datetime
from logging.handlers import TimedRotatingFileHandler




# Build paths inside the project like this: BASE_DIR / 'subdir'.
BASE_DIR = Path(__file__).resolve().parent.parent

env = environ.Env()
environ.Env.read_env(os.path.join(BASE_DIR, '.env'))

# Quick-start development settings - unsuitable for production
# See https://docs.djangoproject.com/en/4.0/howto/deployment/checklist/

# Application definition

INSTALLED_APPS = [
    'django.contrib.admin',
    'django.contrib.auth',
    'django.contrib.contenttypes',
    'django.contrib.sessions',
    'django.contrib.messages',
    'django.contrib.staticfiles',

    'account',
    'home',
    'merchant',
    'store.apps.StoreConfig',
    'superadmin',
    'location',
    'transaction',
    'ecommerce.apps.EcommerceConfig',

    # INSTALLED APPS
    'rest_framework',
    'rest_framework.authtoken',
    'django_filters',
    'corsheaders',
    'django_crontab',
    'storages',
    'rest_framework_simplejwt',
    'django_elasticsearch_dsl',
    'drf_yasg',
    'django_celery_results',
    'django_celery_beat',
    'drf_spectacular',

    'ckeditor',
    'ckeditor_uploader',

    # 'django_prometheus',
    # 'social_django',

]

CKEDITOR_UPLOAD_PATH = "uploads/"

MIDDLEWARE = [
    # 'django_prometheus.middleware.PrometheusBeforeMiddleware',
    'corsheaders.middleware.CorsMiddleware',
    'django.middleware.common.CommonMiddleware',  # Common Middleware after CORS

    'django.middleware.security.SecurityMiddleware',
    'django.contrib.sessions.middleware.SessionMiddleware',

    'django.middleware.csrf.CsrfViewMiddleware',
    'corsheaders.middleware.CorsPostCsrfMiddleware',
    'django.contrib.auth.middleware.AuthenticationMiddleware',
    'django.contrib.messages.middleware.MessageMiddleware',
    'django.middleware.clickjacking.XFrameOptionsMiddleware',
    'ecommerce.middlewares.custommiddlewares.RecentlyViewedProductsMiddleware',

    # 'django_prometheus.middleware.PrometheusAfterMiddleware',
    # 'social_django.middleware.SocialAuthExceptionMiddleware',
]
# MIDDLEWARE = [
#     'corsheaders.middleware.CorsMiddleware',
#     'django.middleware.security.SecurityMiddleware',
#     'django.contrib.sessions.middleware.SessionMiddleware',
#     'django.middleware.common.CommonMiddleware',
#     'django.middleware.csrf.CsrfViewMiddleware',
#     'corsheaders.middleware.CorsPostCsrfMiddleware',
#     'django.contrib.auth.middleware.AuthenticationMiddleware',
#     'django.contrib.messages.middleware.MessageMiddleware',
#     'django.middleware.clickjacking.XFrameOptionsMiddleware',
#     'ecommerce.middlewares.custommiddlewares.RecentlyViewedProductsMiddleware',
#     # 'social_django.middleware.SocialAuthExceptionMiddleware',
# ]


# Authentication Backends
# AUTHENTICATION_BACKENDS = (
#     'social_core.backends.google.GoogleOAuth2',
#     'social_core.backends.facebook.FacebookOAuth2',
#     'django.contrib.auth.backends.ModelBackend',
# )

# Google and Facebook OAuth settings
# SOCIAL_AUTH_GOOGLE_OAUTH2_KEY = 'YOUR_GOOGLE_CLIENT_ID'
# SOCIAL_AUTH_GOOGLE_OAUTH2_SECRET = 'YOUR_GOOGLE_CLIENT_SECRET'
# SOCIAL_AUTH_FACEBOOK_KEY = 'YOUR_FACEBOOK_APP_ID'
# SOCIAL_AUTH_FACEBOOK_SECRET = 'YOUR_FACEBOOK_APP_SECRET'
#
# # Facebook Permissions (scope)
# SOCIAL_AUTH_FACEBOOK_SCOPE = ['email']  # Request email; adjust according to what you need (e.g., public_profile,
# # user_birthday)
#
# # Facebook Profile Fields
# # Specify which fields to retrieve from the Facebook user profile
# SOCIAL_AUTH_FACEBOOK_PROFILE_EXTRA_PARAMS = {
#     'fields': 'email, first_name, last_name',  # Adjust as needed
# }

# URL Redirects for social auth
# LOGIN_REDIRECT_URL = '/'
# LOGOUT_REDIRECT_URL = '/'
#
# # Additional configuration for PSA (Python Social Auth)
# SOCIAL_AUTH_JSONFIELD_ENABLED = True
# SOCIAL_AUTH_PIPELINE = (
#     'social_core.pipeline.social_auth.social_details',
#     'social_core.pipeline.social_auth.social_uid',
#     'social_core.pipeline.social_auth.auth_allowed',
#     'social_core.pipeline.social_auth.social_user',
#     'social_core.pipeline.user.get_username',
#     'social_core.pipeline.social_auth.associate_by_email',
#     'social_core.pipeline.user.create_user',
#     'social_core.pipeline.social_auth.associate_user',
#     'social_core.pipeline.social_auth.load_extra_data',
#     'social_core.pipeline.user.user_details',
# )

ROOT_URLCONF = 'payarena.urls'

TEMPLATES = [
    {
        'BACKEND': 'django.template.backends.django.DjangoTemplates',
        'DIRS': [BASE_DIR / 'templates'],
        'APP_DIRS': True,
        'OPTIONS': {
            'context_processors': [
                'django.template.context_processors.debug',
                'django.template.context_processors.request',
                'django.contrib.auth.context_processors.auth',
                'django.contrib.messages.context_processors.messages',
            ],
        },
    },
]

WSGI_APPLICATION = 'payarena.wsgi.application'

# Password validation
# https://docs.djangoproject.com/en/4.0/ref/settings/#auth-password-validators

AUTH_PASSWORD_VALIDATORS = [
    {
        'NAME': 'django.contrib.auth.password_validation.UserAttributeSimilarityValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.MinimumLengthValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.CommonPasswordValidator',
    },
    {
        'NAME': 'django.contrib.auth.password_validation.NumericPasswordValidator',
    },
]

# Internationalization
# https://docs.djangoproject.com/en/4.0/topics/i18n/

LANGUAGE_CODE = 'en-us'

TIME_ZONE = 'Africa/Lagos'

USE_I18N = True

USE_L10N = True

USE_TZ = True

# Static files (CSS, JavaScript, Images)
# https://docs.djangoproject.com/en/4.0/howto/static-files/

STATIC_URL = 'static/'
STATIC_ROOT = os.path.join(BASE_DIR, 'static')

MEDIA_URL = 'media/'
MEDIA_ROOT = os.path.join(BASE_DIR, 'media')

# MEDIA_ROOT = f"{BASE_DIR}/media"
# MEDIA_URL = "/media/"
# Default primary key field type
# https://docs.djangoproject.com/en/4.0/ref/settings/#default-auto-field

DEFAULT_AUTO_FIELD = 'django.db.models.BigAutoField'

# logging.basicConfig(
#     filename='payarenamall.log',
#     filemode='a',
#     level=logging.DEBUG,
#     format='[{asctime}] {levelname} {module} {thread:d} - {message}',
#     datefmt='%d-%m-%Y %H:%M:%S',
#     style='{',
# )
#
# LOGGING = {
#     'version': 1,
#     'disable_existing_loggers': False,
#     'formatters': {
#         'verbose': {
#             'format': '[{asctime}] {levelname} {module} {thread:d} - {message}',
#             'style': '{',
#             'datefmt': '%d-%m-%Y %H:%M:%S'
#         },
#     },
#     'handlers': {
#         'file': {
#             'level': 'INFO',
#             'class': 'logging.FileHandler',
#             'filename': 'payarenamall.log',
#             'formatter': 'verbose',
#         },
#     },
#     'root': {
#         'handlers': ['file'],
#         'level': 'INFO',
#     },
#     'loggers': {
#         'django': {
#             'handlers': ['file'],
#             'level': 'INFO',
#             'propagate': True,
#         },
#         'django.server': {
#             'handlers': ['file'],
#             'level': 'INFO',
#             'propagate': True,
#         },
#         'django.request': {
#             'handlers': ['file'],
#             'level': 'INFO',
#             'propagate': True,
#         },
#     },
# }


BASE_DIR = Path(__file__).resolve().parent.parent


LOGGING = {
    'version': 1,
    'disable_existing_loggers': False,
    'formatters': {
        'verbose': {
            'format': '{levelname} [{asctime}] {module} - {message}',
            'style': '{',
        },
    },
    'handlers': {
        'buyer_log': {
            'level': 'INFO',
            'class': 'payarena.settings.logging_handlers.CustomTimedRotatingFileHandler',
            'filename_prefix': 'buyer',
            'when': 'midnight',
            'interval': 1,
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
        'shipping_log': {
            'level': 'INFO',
            'class': 'payarena.settings.logging_handlers.CustomTimedRotatingFileHandler',
            'filename_prefix': 'shipping',
            'when': 'midnight',
            'interval': 1,
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
        'merchant_log': {
            'level': 'INFO',
            'class': 'payarena.settings.logging_handlers.CustomTimedRotatingFileHandler',
            'filename_prefix': 'merchant',
            'when': 'midnight',
            'interval': 1,
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
        'admin_log': {
            'level': 'INFO',
            'class': 'payarena.settings.logging_handlers.CustomTimedRotatingFileHandler',
            'filename_prefix': 'admin',
            'when': 'midnight',
            'interval': 1,
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
        'payment_log': {
            'level': 'INFO',
            'class': 'payarena.settings.logging_handlers.CustomTimedRotatingFileHandler',
            'filename_prefix': 'payment',
            'when': 'midnight',
            'interval': 1,
            'formatter': 'verbose',
            'encoding': 'utf-8',
        },
    },
    'loggers': {
        'buyer': {'handlers': ['buyer_log'], 'level': 'INFO', 'propagate': False},
        'shipping': {'handlers': ['shipping_log'], 'level': 'INFO', 'propagate': False},
        'merchant': {'handlers': ['merchant_log'], 'level': 'INFO', 'propagate': False},
        'admin': {'handlers': ['admin_log'], 'level': 'INFO', 'propagate': False},
        'payment': {'handlers': ['payment_log'], 'level': 'INFO', 'propagate': False},
    },
}


REST_FRAMEWORK = {
    'DEFAULT_FILTER_BACKENDS': ['django_filters.rest_framework.DjangoFilterBackend'],
    'DEFAULT_AUTHENTICATION_CLASSES': (
        'rest_framework_simplejwt.authentication.JWTAuthentication',
    ),
    'DEFAULT_THROTTLE_CLASSES': [
        'rest_framework.throttling.UserRateThrottle',
        'rest_framework.throttling.AnonRateThrottle',
    ],
    'DEFAULT_THROTTLE_RATES': {
        'user': '5/minute',  # 5 requests per minute for authenticated users
        'anon': '3/minute',  # 3 requests per minute for anonymous users

        # 'signup': '5/minute',  # Limit to 5 signup requests per minute
        # 'login': '5/minute',  # Limit login attempts to 10 per minute
    },
    'DEFAULT_PERMISSION_CLASSES': ['rest_framework.permissions.IsAuthenticated']
}

# CACHING
CACHES = {
    'default': {
        'BACKEND': 'django_redis.cache.RedisCache',
        # 'BACKEND': 'django.core.cache.backends.redis.RedisCache',
        'LOCATION': env('REDIS_URL', None),
        # 'TIMEOUT': 60 * 30
    }
}

# HASHIDS_SALT = os.getenv("HASHIDS_SALT", "default-hardcoded-salt")
# SECRET_KEY = env('SECRET_KEY')
CACHE_TIMEOUT = env('CACHE_TIMEOUT', None)



# EMAIL_HOST = 'smtp.gmail.com'
# EMAIL_PORT = 587
# EMAIL_USE_TLS = True
# EMAIL_HOST_USER = os.environ.get("EMAIL_HOST_USER")
# EMAIL_HOST_PASSWORD = os.environ.get("EMAIL_HOST_PASSWORD")
#
# # Default From Email
# DEFAULT_FROM_EMAIL = EMAIL_HOST_USER
#
# # Server Email (for error notifications)
# SERVER_EMAIL = EMAIL_HOST_USER
# EMAIL_BACKEND = 'account.email_config.CustomEmailBackend'
