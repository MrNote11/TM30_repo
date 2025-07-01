import json

from django.contrib.auth.models import AnonymousUser
from django.db import transaction
from django.utils.deprecation import MiddlewareMixin
from rest_framework_simplejwt.authentication import JWTAuthentication

from account.models import Profile
from ecommerce.models import Cart, CartProduct

from home.utils import log_request


# class RecentlyViewedProductsMiddleware(MiddlewareMixin):
#     def process_view(self, request, view_func, view_args, view_kwargs):
#         # Check if the view has a 'slug' argument (i.e., a product ID)
#         if 'slug' in view_kwargs:
#             product_slug = str(view_kwargs['slug'])
#
#             # Get the user via JWT or session-based authentication
#             user = self.get_jwt_user(request)
#
#             if user and user.is_authenticated:
#                 try:
#                     # Access or create user profile
#                     user_profile = user
#
#                     # Retrieve the current recently viewed products from the user profile
#                     recently_viewed_products = json.loads(user_profile.recent_viewed_products or "[]")
#
#                     # Remove the product if it already exists to avoid duplicates
#                     if product_slug in recently_viewed_products:
#                         recently_viewed_products.remove(product_slug)
#
#                     # Add the new product at the start of the list
#                     recently_viewed_products.insert(0, product_slug)
#
#                     # Limit the list to the last 20 viewed products
#                     recently_viewed_products = recently_viewed_products[:20]
#
#                     # Save the updated list back to the user's profile
#                     user_profile.recent_viewed_products = json.dumps(recently_viewed_products)
#                     user_profile.save()
#
#                 except Profile.DoesNotExist:
#                     log_request("User profile does not exist")
#                     return None
#                 log_request("Adding products to recently viewed")
#             else:
#                 # Session-based handling if the user is anonymous
#                 recently_viewed_products = request.session.get('recently_viewed_products', [])
#
#                 if product_slug in recently_viewed_products:
#                     recently_viewed_products.remove(product_slug)
#
#                 recently_viewed_products.insert(0, product_slug)
#
#                 # Limit the list to the last 20 viewed products
#                 recently_viewed_products = recently_viewed_products[:20]
#
#                 request.session['recently_viewed_products'] = recently_viewed_products
#
#         return None
#
#     def get_jwt_user(self, request):
#         from rest_framework.authentication import get_authorization_header
#         from rest_framework_simplejwt.authentication import JWTAuthentication
#
#         auth = get_authorization_header(request).split()
#         if len(auth) == 2 and auth[0].lower() == b"bearer":
#             try:
#                 validated_user = JWTAuthentication().authenticate(request)
#                 if validated_user:
#                     request.user.profile = validated_user[0]
#                 else:
#                     AnonymousUser()
#             except Exception as e:
#                 log_request(f"JWT authentication error: {str(e)}")
#                 return AnonymousUser()


class RecentlyViewedProductsMiddleware:
    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        # Ensure resolver_match exists and contains kwargs with 'slug'
        if hasattr(request, 'resolver_match') and request.resolver_match is not None:
            # Check if 'slug' is in the URL parameters (view kwargs)
            if 'slug' in request.resolver_match.kwargs:
                product_slug = str(request.resolver_match.kwargs['slug'])

                if request.user and not isinstance(request.user, AnonymousUser):
                    # Access or create user profile
                    user_profile = request.user.profile

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

                else:
                    # Session-based handling if the user is anonymous
                    recently_viewed_products = request.session.get('recently_viewed_products', [])

                    if product_slug in recently_viewed_products:
                        recently_viewed_products.remove(product_slug)

                    recently_viewed_products.insert(0, product_slug)

                    # Limit the list to the last 20 viewed products
                    recently_viewed_products = recently_viewed_products[:20]

                    request.session['recently_viewed_products'] = recently_viewed_products

        # Pass the request to the next middleware or view
        response = self.get_response(request)

        return response
