import json
import os
import secrets, time
import threading
from transaction.models import *
import pyotp
import requests
from django.contrib.auth import authenticate, logout, login
from django.core.exceptions import ObjectDoesNotExist, ValidationError
from django.db import transaction
from django.http import HttpResponse

from django.shortcuts import get_object_or_404, redirect
from django.utils.http import urlsafe_base64_encode, urlsafe_base64_decode
from rest_framework import status, generics
from rest_framework.permissions import IsAuthenticated, AllowAny
from rest_framework.reverse import reverse
from rest_framework.throttling import UserRateThrottle
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework_simplejwt.tokens import RefreshToken, AccessToken, UntypedToken
from rest_framework_simplejwt.exceptions import TokenError, InvalidToken

from rest_framework_simplejwt.token_blacklist.models import BlacklistedToken, OutstandingToken
from rest_framework.parsers import MultiPartParser

from ecommerce.models import Cart, CartProduct
from ecommerce.shopper_email import shopper_welcome_email

# from home.utils import log_request # Not in use for now

from merchant.utils import resize_and_save_image
from superadmin.models import AdminUser
from .models import *
from django.contrib.auth.models import User
from django.contrib.auth.hashers import check_password, make_password
from django.utils import timezone
from threading import Thread
from .serializers import *
from .utils import validate_email, merge_carts, create_account, send_shopper_verification_email, \
    register_payarena_user, login_payarena_user, change_payarena_user_password, get_wallet_info, \
    validate_phone_number_for_wallet_creation, create_user_wallet, make_payment_for_wallet, \
    confirm_or_create_billing_account, forget_password, reset_password, account_verification_token

from django.core.mail import send_mail
from django.utils.http import urlsafe_base64_encode
from django.utils.encoding import force_bytes, force_str
from django.contrib.sites.shortcuts import get_current_site

from django.conf import settings
from rest_framework_simplejwt.tokens import RefreshToken
from social_django.utils import psa  # Python Social Auth utilities
from social_core.exceptions import AuthException, AuthTokenError
import random
import string

from rest_framework.parsers import JSONParser
from io import BytesIO

import logging

buyer_logger = logging.getLogger('buyer')
shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')


class EmailThread(threading.Thread):
    """
    A thread to handle email sending in the background.
    """
    def __init__(self, payload, email):
        self.payload = payload
        self.email = email
        super().__init__()

    def run(self):
        try:
            response = requests.post(
                settings.EMAIL_URL,
                headers={'Content-Type': 'application/json'},
                data=json.dumps(self.payload)
            )
            if response.status_code == 200:
                buyer_logger.info(f"EmailThread - Email sent successfully to {self.email}")
                admin_logger.info(f"EmailThread - Email sent successfully to {self.email}")
            else:
                buyer_logger.debug(f"EmailThread - Failed to send email to {self.email}. Response: {response.json()}")
                admin_logger.debug(f"EmailThread - Failed to send email to {self.email}. Response: {response.json()}")
        except Exception as e:
            buyer_logger.error(f"EmailThread - Error sending email to {self.email}. Exception: {str(e)}")
            admin_logger.error(f"EmailThread - Error sending email to {self.email}. Exception: {str(e)}")


class RegisterView(APIView):
    permission_classes = [AllowAny]

    def post(self, request):
        try:
            serializer = RegisterSerializer(data=request.data)
            if serializer.is_valid():
                user = serializer.context.get('user')  # Get the user from the serializer context

                if not user:  # New user registration
                    email = serializer.validated_data['email']
                    user = User.objects.create_user(username=email, email=email, password=None)
                    user.is_active = False  # Deactivate account until email is confirmed
                    user.save()
                    UserActivation.objects.create(user=user).set_activation_expiry()

                elif user.activation.is_expired():
                    # Reset the expiry time if the link has expired
                    user.activation.set_activation_expiry()

                # Send activation email
                email_sent = self.send_activation_email(user, request)
                if email_sent:
                    buyer_logger.info("Activation email sent.")
                    admin_logger.info("Activation email sent.")
                    return Response({'message': 'Activation email sent.'}, status=status.HTTP_201_CREATED)
                else:
                    buyer_logger.debug("Failed to send activation email.")
                    admin_logger.debug("Failed to send activation email.")
                    return Response({'error': 'Failed to send activation email.'},
                                    status=status.HTTP_500_INTERNAL_SERVER_ERROR)

            buyer_logger.error(f"Failed to send activation email: {serializer.errors}")
            admin_logger.error(f"Failed to send activation email: {serializer.errors}")
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"Failed to send activation email: {err}")
            admin_logger.error(f"Failed to send activation email: {err}")
            return Response({"detail": "An unexpected error occurred", "error": {err}}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @staticmethod
    def send_activation_email(user, request):
        from django.core.mail import EmailMultiAlternatives
        from django.utils.html import format_html
        """
        Utility function for sending activation emails
        """
        uid = urlsafe_base64_encode(force_bytes(user.pk))
        activation_url = reverse('account:activate-email', kwargs={'uid': uid})
        protocol = 'https' if request.is_secure() else 'http'
        full_url = f"{protocol}://{get_current_site(request).domain}{activation_url}"

        # Email content
        subject = 'Activate Your Account'
        html_content = format_html(
            '''
            <p>Hey there,</p>
            <br>
            
            <p>Ready to dive in? You're almost there! Click this button to activate your account and unlock a world of 
            [Benefit or Feature]:</p>
            <br>
             
            <p><a href="{0}" style="display: inline-block; padding: 10px 10px; font-size: 13px; color: white;
            background-color: #4CAF50; text-decoration: none; border-radius: 5px;">Activate Account</a></p>
            <br>

            <p>We can't wait to have you join us!</p>
            <br>
            
            <p>If you didn’t request this email, please ignore it.</p>
            <br>

            <p>Best</p>
            ''',
            full_url
        )
        # # Prepare the email
        # subject = 'Activate Your Account'
        # text_content = f'Please click the following link to activate your account: {full_url}'
        #
        # email = EmailMultiAlternatives(
        #     subject=subject,
        #     body=text_content,  # Plain text body as fallback
        #     from_email=settings.EMAIL_HOST_USER,
        #     to=[user.email]
        # )
        # email.attach_alternative(html_content, "text/html")  # Attach HTML version
        # try:
        #     email.send()
        #     log_request("Activation email sent")
        #     return True
        #
        # except Exception as e:
        #     log_request(f"Failed to send activation email: {str(e)}")
        #     return False

        payload = {
            "Message": html_content,
            "address": user.email,
            "Subject": subject
        }

        # Start a new thread to send the email
        email_thread = EmailThread(payload, user.email)
        email_thread.start()

        # Return True to indicate the email task has been queued
        return True


class ActivateEmailView(APIView):
    permission_classes = [AllowAny]

    def get(self, request, uid):
        try:
            user_id = urlsafe_base64_decode(uid).decode()
            user = User.objects.get(pk=user_id)

            user_activation = UserActivation.objects.get(user=user)
            if user_activation.is_expired():
                message = "Activation link expired. Please request a new one."
                # Redirect to the React frontend URL with the user identifier
                frontend_url = f"{settings.UPDATED_FRONTEND_URL}/sign-up?message={message}"
                buyer_logger.info(f"Activation link expired. Please request a new one: {user}")
                admin_logger.info(f"Activation link expired. Please request a new one: {user}")
                return redirect(frontend_url)

            if user.is_active:
                # Redirect with a message indicating the account is already active
                message = "Your account is already active."
                buyer_logger.info(f"{message} : {user}")
                admin_logger.info(f"{message} : {user}")
            else:
                user.is_active = True
                user.save()
                message = "Account successfully activated. Please complete your profile."

            # Redirect to the React frontend URL with the user identifier
            frontend_url = f"{settings.UPDATED_FRONTEND_URL}/activate-email/?uid={uid}&message={message}"
            buyer_logger.info(f"Account successfully activated. Please complete your profile {uid} : {user}")
            admin_logger.info(f"Account successfully activated. Please complete your profile {uid} : {user}")
            return redirect(frontend_url)

        except (User.DoesNotExist, ValueError, TypeError) as err:
            buyer_logger.error(f"Invalid activation link : {err}")
            admin_logger.error(f"Invalid activation link : {err}")
            return Response({'error': 'Invalid activation link.'}, status=status.HTTP_400_BAD_REQUEST)


class SetPasswordView(APIView):
    permission_classes = [AllowAny]

    @transaction.atomic
    def post(self, request, uid):
        serializer = SetPasswordSerializer(data=request.data)
        if serializer.is_valid():
            try:
                user_id = urlsafe_base64_decode(uid).decode()
                user = User.objects.get(pk=user_id)

                if not user.is_active:
                    buyer_logger.error(f"Account is not active: {user}")
                    admin_logger.error(f"Account is not active: {user}")
                    return Response({'error': 'Account is not activated yet.'}, status=status.HTTP_400_BAD_REQUEST)

                if Profile.objects.filter(user=user).exists():
                    buyer_logger.error(f"Account already set up: {user}")
                    admin_logger.error(f"Account already set up: {user}")
                    return Response({'error': 'Account already exists and has been set up.'},
                                    status=status.HTTP_400_BAD_REQUEST)

                # Wrap in a transaction to ensure atomicity
                with transaction.atomic():
                    phone_number = serializer.validated_data['phone_number']
                    user.first_name = serializer.validated_data['first_name']
                    user.last_name = serializer.validated_data['last_name']
                    user.set_password(serializer.validated_data['password'])
                    user.save()

                    # Register the user on PayArena (external service)
                    success, detail = register_payarena_user(
                        user.email, user.email, phone_number,
                        user.first_name, user.last_name,
                        serializer.validated_data['password'], serializer.validated_data['password']
                    )

                    if not success:
                        buyer_logger.error(f"PayArena registration failed: {detail}")
                        admin_logger.error(f"PayArena registration failed: {detail}")
                        transaction.set_rollback(True)  # Rollback in case of failure
                        return Response({"detail": f"PayArena registration failed. {detail}"},
                                        status=status.HTTP_400_BAD_REQUEST)

                    # Delete UserActivation record if it exists
                    try:
                        user_activation = UserActivation.objects.get(user=user)
                        user_activation.delete()
                    except UserActivation.DoesNotExist:
                        buyer_logger.error(f"UserActivation entry missing for user {user.email}")
                        admin_logger.error(f"UserActivation entry missing for user {user.email}")
                        transaction.set_rollback(True)  # Rollback in case of failure
                        return Response({"error": f"User Activation entry missing for user {user.email}"},
                                        status=status.HTTP_400_BAD_REQUEST)

                    # Create user profile (only if it doesn’t exist)
                    Profile.objects.get_or_create(user=user, defaults={'phone_number': phone_number, 'verified': True})

                # Transaction committed if no errors occurred
                buyer_logger.info(f"Account created successfully: {user.email}")
                admin_logger.info(f"Account created successfully: {user.email}")
                return Response({'message': 'Account created successfully. You can now log in.'},
                                status=status.HTTP_200_OK)

            except User.DoesNotExist as err:
                buyer_logger.error(f"Invalid user: {err}")
                admin_logger.error(f"Invalid user: {err}")
                return Response({'error': 'Invalid user.'}, status=status.HTTP_400_BAD_REQUEST)

            except Exception as err:
                buyer_logger.error(f"Error during signup: {str(err)}")
                admin_logger.error(f"Error during signup: {str(err)}")
                return Response({"error": f"An unexpected error occurred: {str(err)}"},
                                status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        buyer_logger.error(f"Error in SetPasswordView: {serializer.errors}")
        admin_logger.error(f"Error in SetPasswordView: {serializer.errors}")
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class LoginUserView(APIView):
    permission_classes = []

    def get(self, request):
        try:
            email = request.query_params.get('email', None)

            # Validate inputs
            if not email:
                return Response({"detail": "Email is required."}, status=status.HTTP_400_BAD_REQUEST)

            user_email = User.objects.get(email=email)
            if not user_email.is_active:
                return Response({"detail": "Email has not been verified."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Ensure a valid email format if '@' is present
            if '@' in email and not validate_email(email):
                return Response({"detail": "Email is not valid."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Prevent admin login via customer flow
            if AdminUser.objects.filter(user__email=email).exists():
                return Response({"detail": "Invalid customer credential"}, status=status.HTTP_400_BAD_REQUEST)

            return Response({"message": "Success"}, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def post(self, request, *args, **kwargs):
        response_data = {}
        try:
            email = request.data.get('email', None)
            password = request.data.get('password', None)
            session_key = request.data.get("session_key", None)

            if session_key:
                request.session["session_key"] = session_key  # Save the session_key for future use

            # Validate inputs
            if not email or not password:
                return Response({"detail": "Email and password are required."}, status=status.HTTP_400_BAD_REQUEST)

            user_email = User.objects.get(email=email)
            if not user_email.is_active:
                buyer_logger.error(f"LoginUserView - Email has not been verified: {user_email}")
                admin_logger.error(f"LoginUserView - Email has not been verified: {user_email}")
                return Response({"detail": "Email has not been verified."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Ensure a valid email format if '@' is present
            if '@' in email and not validate_email(email):
                return Response({"detail": "Email is not valid."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Prevent admin login via customer flow
            if AdminUser.objects.filter(user__email=email).exists():
                return Response({"detail": "Invalid customer credential"}, status=status.HTTP_400_BAD_REQUEST)

            # Authenticate user using Django's authenticate method
            user = authenticate(request, username=email, password=password)

            # Handle authentication failure
            if not user:
                profile = login_payarena_user(profile=None, email=email, password=password)
                if not profile:
                    buyer_logger.error(f"LoginUserView - Incorrect login details: {profile}")
                    admin_logger.error(f"LoginUserView - Incorrect login details.: {profile}")
                    return Response({"detail": "Incorrect login details."}, status=status.HTTP_400_BAD_REQUEST)

                user = profile
                # user = profile.user
            else:
                # User authenticated successfully; retrieve associated profile
                profile = Profile.objects.get(user=user)

            if not profile.verified:
                return Response({"detail": "User not verified, please request a verification link."},
                                status=status.HTTP_400_BAD_REQUEST)

            # Merge session cart into user cart upon successful login
            self.merge_session_cart_into_user_cart(request, user, session_key)

            # Perform asynchronous tasks (like login to PayArena and billing account creation)
            Thread(target=login_payarena_user, args=[profile, email, password]).start()
            time.sleep(2)
            wallet_balance = get_wallet_info(profile)

            Thread(target=confirm_or_create_billing_account, args=[profile, email, password]).start()

            # Return response with user data, wallet info, and JWT tokens
            response_data["detail"] = "Login successful"
            response_data["token"] = str(AccessToken.for_user(user))
            response_data["refresh_token"] = str(RefreshToken.for_user(user))
            response_data["data"] = ProfileSerializer(profile, context={"request": request}).data
            response_data["wallet_information"] = wallet_balance

        except (ValueError, TypeError, ValidationError, OverflowError) as e:
            buyer_logger.error(f"Validation error during login: {e}")
            admin_logger.error(f"Validation error during login: {e}")
            return Response({"detail": "Invalid data", "error": f"ValidationError: {e}"}, status=status.HTTP_400_BAD_REQUEST)

        except ObjectDoesNotExist as e:
            buyer_logger.error(f"Object not found: {e}")
            admin_logger.error(f"Object not found: {e}")
            return Response({"detail": "Login error, please confirm email and password are correct", "error": str(e)},
                            status=status.HTTP_400_BAD_REQUEST)

        except KeyError as ke:
            return Response({"error": f"Missing key: {str(ke)}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as e:
            buyer_logger.error(f"Unexpected error during login: {e}")
            admin_logger.error(f"Unexpected error during login: {e}")
            return Response({
                "detail": "Login error, please confirm email and password are correct",
                "error": f"An unexpected error occurred: {e}"
            }, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        buyer_logger.info(f"response_data: {response_data}")
        admin_logger.info(f"response_data: {response_data}")
        return Response(response_data, status=status.HTTP_200_OK)

    @staticmethod
    def merge_session_cart_into_user_cart(request, user, session_key):
        """
        Merge products from a guest cart into the logged-in user's cart.
        """
        try:
            # Get guest cart using session key
            cart_uid = session_key
            if cart_uid:
                request.session["session_key"] = cart_uid  # Save the session_key for future use

            guest_cart = Cart.objects.filter(cart_uid=cart_uid, status='open').first()

            if guest_cart:
                # Get or create user's cart
                user_cart, created = Cart.objects.get_or_create(user=user, status='open')

                # Merge CartProducts from guest cart to user cart
                guest_cart_products = CartProduct.objects.filter(cart=guest_cart)

                for guest_product in guest_cart_products:
                    if guest_product.quantity <= 0:
                        buyer_logger.info(f"Skipped item with invalid quantity: {guest_product}")
                        buyer_logger.info(f"Skipped item with invalid quantity: {guest_product}")
                        guest_product.delete()
                        # Skip products with invalid quantities
                        continue
                    # Check if the product already exists in the user's cart
                    user_cart_product = CartProduct.objects.filter(
                        cart=user_cart, product_detail=guest_product.product_detail
                    ).first()

                    if user_cart_product:
                        # Update quantity and price if product exists
                        user_cart_product.quantity += guest_product.quantity
                        user_cart_product.price = guest_product.price  # Optional: Update to latest price
                        user_cart_product.save()
                    else:
                        # Transfer the product to the user's cart
                        guest_product.cart = user_cart
                        guest_product.save()

                # Delete the guest cart
                guest_cart.delete()

        except Exception as e:
            buyer_logger.error(f"Error merging carts: {str(e)}")
            admin_logger.error(f"Error merging carts: {str(e)}")


class GoogleSignUpView(APIView):
    permission_classes = [AllowAny]

    @psa('social:complete')
    def post(self, request, *args, **kwargs):
        token = request.data.get('token')
        if not token:
            return Response({"error": "No token provided"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Validate and get user info from Google
            backend = request.backend  # OAuth backend instance (GoogleOAuth2)
            user_info = backend.do_auth(token)

            if user_info and user_info.get('email'):
                email = user_info['email']
                first_name = user_info.get('given_name', '')
                last_name = user_info.get('family_name', '')

                # Check if user exists
                user, created = User.objects.get_or_create(
                    email=email,
                    defaults={
                        "username": email,
                        "first_name": first_name,
                        "last_name": last_name,
                        "password": self.generate_random_password()
                    }
                )

                if created:
                    # Register the user on PayArena (external service)
                    success, detail = register_payarena_user(
                        user.email, user.email, ("" or None),
                        user.first_name, user.last_name,
                        self.generate_random_password(), self.generate_random_password()
                    )
                    if not success:
                        buyer_logger.error(f"PayArena registration failed: {detail}")
                        admin_logger.error(f"PayArena registration failed: {detail}")
                        return Response({"detail": f"PayArena registration failed. {detail}"},
                                        status=status.HTTP_400_BAD_REQUEST)

                    # Create profile
                    Profile.objects.get_or_create(user=user, defaults={'phone_number': "", 'verified': True})

                # Generate JWT tokens for the user
                refresh = RefreshToken.for_user(user)
                access_token = refresh.access_token

                return Response({
                    "detail": "Sign-up successful",
                    "token": str(access_token),
                    "refresh_token": str(refresh),
                    "data": {"email": email, "first_name": first_name, "last_name": last_name},
                }, status=status.HTTP_200_OK)

            return Response({"error": "Could not authenticate user"}, status=status.HTTP_400_BAD_REQUEST)

        except (AuthException, AuthTokenError) as auth_error:
            buyer_logger.error(f"Google authentication error: {str(auth_error)}")
            admin_logger.error(f"Google authentication error: {str(auth_error)}")
            return Response({"error": "Authentication failed"}, status=status.HTTP_401_UNAUTHORIZED)

        except Exception as e:
            buyer_logger.error(f"Unhandled exception during Google sign-up: {str(e)}")
            admin_logger.error(f"Unhandled exception during Google sign-up: {str(e)}")
            return Response({"error": "Internal server error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @staticmethod
    def generate_random_password(length=12):
        """Generate a secure random password."""
        characters = string.ascii_letters + string.digits + string.punctuation
        return ''.join(random.choices(characters, k=length))


class FacebookSignUpView(APIView):
    permission_classes = [AllowAny]

    @psa('social:complete')
    def post(self, request, *args, **kwargs):
        token = request.data.get('token')
        if not token:
            return Response({"error": "No token provided"}, status=status.HTTP_400_BAD_REQUEST)

        try:
            # Validate and get user info from Facebook
            backend = request.backend  # OAuth backend instance (Facebook)
            user_info = backend.do_auth(token)

            if user_info and user_info.get('email'):
                email = user_info['email']
                first_name = user_info.get('first_name', '')
                last_name = user_info.get('last_name', '')

                # Check if user exists
                user, created = User.objects.get_or_create(
                    email=email,
                    defaults={
                        "username": email,
                        "first_name": first_name,
                        "last_name": last_name,
                        "password": self.generate_random_password()
                    }
                )

                if created:
                    # Register the user on PayArena (external service)
                    success, detail = register_payarena_user(
                        user.email, user.email, ("" or None),
                        user.first_name, user.last_name,
                        self.generate_random_password(), self.generate_random_password()
                    )
                    if not success:
                        buyer_logger.error(f"PayArena registration failed: {detail}")
                        return Response({"detail": f"PayArena registration failed. {detail}"},
                                        status=status.HTTP_400_BAD_REQUEST)

                    # Create profile
                    Profile.objects.get_or_create(user=user, defaults={'phone_number': "", 'verified': True})

                # Generate JWT tokens for the user
                refresh = RefreshToken.for_user(user)
                access_token = refresh.access_token

                return Response({
                    "detail": "Sign-up successful",
                    "token": str(access_token),
                    "refresh_token": str(refresh),
                    "data": {"email": email, "first_name": first_name, "last_name": last_name},
                }, status=status.HTTP_200_OK)

            return Response({"error": "Could not authenticate user"}, status=status.HTTP_400_BAD_REQUEST)

        except (AuthException, AuthTokenError) as auth_error:
            admin_logger.error(f"Facebook authentication error: {str(auth_error)}")
            return Response({"error": "Authentication failed"}, status=status.HTTP_401_UNAUTHORIZED)

        except Exception as e:
            buyer_logger.error(f"Unhandled exception during Facebook sign-up: {str(e)}")
            return Response({"error": "Internal server error"}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    @staticmethod
    def generate_random_password(length=12):
        """Generate a secure random password."""
        characters = string.ascii_letters + string.digits + string.punctuation
        return ''.join(random.choices(characters, k=length))


class LogoutView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            # Extract the refresh token from the request data
            refresh_token = request.data.get("refresh_token")
            if not refresh_token:
                return Response({"detail": "Refresh token required"}, status=status.HTTP_400_BAD_REQUEST)

            # Blacklist the refresh token to invalidate it
            token = RefreshToken(refresh_token)
            token.blacklist()

            return Response({"detail": "Logout successful"}, status=status.HTTP_200_OK)

        except (TokenError, InvalidToken) as e:
            # Handle any errors with invalid tokens
            return Response({"detail": "Invalid or expired token", "error": str(e)},
                            status=status.HTTP_400_BAD_REQUEST)
        except Exception as e:
            # Log any unexpected errors for troubleshooting
            # Customize this with your logging setup if needed
            buyer_logger.error(f"Logout error: {str(e)}")
            return Response({"detail": "An error occurred during logout",
                             "error": f"{str(e)}"},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# Pending the flow for Forgot Password.
class ForgotPasswordView(APIView):
    permission_classes = []

    def get(self, request):
        email = request.GET.get("email")

        if not email:
            return Response({"detail": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)

        if not validate_email(email):
            return Response({"detail": "Invalid Email Format"}, status=status.HTTP_400_BAD_REQUEST)

        # Call UP to send email with OTP to email
        Thread(target=forget_password, args=[email]).start()
        return Response({"detail": "An OTP has been sent to your email address"})

    def post(self, request):
        otp = request.data.get("otp")
        email = request.data.get("email")
        password = request.data.get("password")
        password_confirm = request.data.get("password_confirm")
        response_status = status.HTTP_400_BAD_REQUEST

        if not all([otp, email, password]):
            return Response({"detail": "otp, email, and password are required"}, status=response_status)

        if password != password_confirm:
            return Response({"detail": "Passwords mismatch"}, status=response_status)

        try:
            user = User.objects.get(email=email)
        except (Exception,) as err:
            buyer_logger.error(f"ForgotPasswordView Error: {err}")
            admin_logger.error(f"ForgotPasswordView Error: {err}")
            return Response({"detail": f"{err}"}, status=response_status)

        success, detail = reset_password(otp, password, email, user)
        if success is True:
            response_status = status.HTTP_200_OK

        buyer_logger.info(f"ForgotPasswordView detail: {detail}")
        admin_logger.info(f"ForgotPasswordView detail: {detail}")
        return Response({"detail": f"{detail}"}, status=response_status)


class ChangePasswordView(APIView):
    permission_classes = [IsAuthenticated]

    def put(self, request):
        try:
            old_password, new_password = request.data.get("old_password", None), request.data.get("new_password", None)
            confirm_new_password = request.data.get("confirm_new_password", None)

            if not all([old_password, new_password, confirm_new_password]):
                return Response({"detail": "All password fields are required"}, status=status.HTTP_400_BAD_REQUEST)

            if new_password != confirm_new_password:
                return Response({"detail": "Password does not match"}, status=status.HTTP_400_BAD_REQUEST)

            if not check_password(old_password, request.user.password):
                return Response({"detail": "Old password does not match your current password"},
                                status=status.HTTP_400_BAD_REQUEST)
            user = request.user
            user_profile = Profile.objects.get(user=user)
            # Change Password on PayArena Auth Engine
            success, message = change_payarena_user_password(user_profile, old_password, new_password)
            if success is False:
                buyer_logger.info(f"ChangePasswordView error: {message}")
                admin_logger.info(f"ChangePasswordView error: {message}")
                return Response({"detail": "An error occurred while changing password, please try again later",
                                 "error": str(message)}, status=status.HTTP_400_BAD_REQUEST)
            user.password = make_password(confirm_new_password)
            user.save()

        except (Exception,) as err:
            buyer_logger.error(f"ChangePasswordView Error: {err}")
            admin_logger.error(f"ChangePasswordView Error: {err}")
            # Log
            return Response({"detail": f"Error: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        else:
            return Response({"detail": "Password has been changed"}, status=status.HTTP_201_CREATED)


class ResendVerificationLinkView(APIView):
    permission_classes = []

    def post(self, request):
        try:
            email = request.data.get("email", None)
            source = request.data.get("source", "payarena")
            if not email:
                return Response({"detail": "Email is required"}, status=status.HTTP_400_BAD_REQUEST)

            profile = Profile.objects.get(user__email=email)

            if profile is not None:
                if send_shopper_verification_email(email=email, profile=profile, source=source):
                    return Response({"detail": "Verification link has been sent to the specified Email"},
                                    status=status.HTTP_200_OK)
                else:
                    return Response({"detail": "An error occurred while send verification link"},
                                    status=status.HTTP_400_BAD_REQUEST)

            return Response({"detail": "No Profile is linked to the Provided email"},
                            status=status.HTTP_400_BAD_REQUEST)
        except (Exception,) as err:
            buyer_logger.error(f"ResendVerificationLinkView detail: {err}")
            admin_logger.error(f"ResendVerificationLinkView detail: {err}")
            return Response({"detail": f"{err}"}, status=status.HTTP_400_BAD_REQUEST)


class EmailVerificationLinkView(APIView):
    permission_classes = []

    def post(self, request, token=None):
        source = request.data.get("source", "payarena")
        if not Profile.objects.filter(verification_code=token).exists():
            return Response({"detail": "Invalid Verification code"}, status=status.HTTP_400_BAD_REQUEST)

        user_profile = Profile.objects.get(verification_code=token)
        if timezone.now() > user_profile.code_expiration_date:
            return Response({"detail": "Verification code has expired"}, status=status.HTTP_400_BAD_REQUEST)

        user_profile.verified = True
        user_profile.verification_code = ""
        user_profile.save()

        # Send Email to user
        email = user_profile.user.email
        Thread(target=shopper_welcome_email, args=[email, source]).start()
        return Response({"detail": "Your Email has been verified successfully"}, status=status.HTTP_200_OK)


class CustomerAddressView(generics.ListCreateAPIView):
    serializer_class = CreateCustomerAddressSerializer

    def get_queryset(self):
        return Address.objects.filter(customer__user=self.request.user)


class CustomerAddressDetailView(generics.RetrieveUpdateDestroyAPIView):
    serializer_class = CustomerAddressSerializer
    lookup_field = "id"

    def update(self, request, *args, **kwargs):
        address_id = self.kwargs.get("id")
        address = get_object_or_404(Address, customer__user=request.user, id=address_id)
        serializer = CustomerAddressSerializer(instance=address, data=request.data,
                                               context=self.get_serializer_context())
        if serializer.is_valid():
            serializer.save()
            data = CustomerAddressSerializer(address).data
            return Response(data)
        else:
            return Response({"detail": "An error has occurred", "error": str(serializer.errors)})

    def get_queryset(self):
        return Address.objects.filter(customer__user=self.request.user)


class CreateCustomerWalletAPIView(APIView):

    def get(self, request):
        try:
            profile = Profile.objects.get(user=request.user)
            if profile.has_wallet is True:
                return Response({"detail": "This account already has a wallet"}, status=status.HTTP_400_BAD_REQUEST)
            response = validate_phone_number_for_wallet_creation(profile)
            buyer_logger.error(f"CreateCustomerWalletAPIView detail: {response}")
            admin_logger.error(f"CreateCustomerWalletAPIView detail: {response}")
            return Response({"detail": str(response)})
        except Exception as err:
            buyer_logger.error(f"CreateCustomerWalletAPIView detail: {err}")
            admin_logger.error(f"CreateCustomerWalletAPIView detail: {err}")
            return Response({"detail": "An error has occurred", "error": str(err)}, status=status.HTTP_400_BAD_REQUEST)

    def post(self, request):
        try:
            wallet_pin = request.data.get("wallet_pin")
            otp = request.data.get("otp")

            profile = Profile.objects.get(user=request.user)
            success, response = create_user_wallet(profile, wallet_pin, otp)
            if success is False:
                return Response({"detail": response}, status=status.HTTP_400_BAD_REQUEST)
            buyer_logger.error(f"CreateCustomerWalletAPIView detail: {response}")
            admin_logger.error(f"CreateCustomerWalletAPIView detail: {response}")
            return Response({"CreateCustomerWalletAPIView detail": response})
        except Exception as ex:
            buyer_logger.error(f"CreateCustomerWalletAPIView detail: {ex}")
            admin_logger.error(f"CreateCustomerWalletAPIView detail: {ex}")
            return Response({"detail": "An error has occurred", "error": str(ex)}, status=status.HTTP_400_BAD_REQUEST)


class FundWalletAPIView(APIView):

    def post(self, request):
        amount = request.data.get("amount")
        pin = request.data.get("pin")
        if not all([amount, pin]):
            return Response({"detail": "Amount and PIN are required"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            payment_link, payment_id = make_payment_for_wallet(request, amount, pin)
            if payment_link is None:
                return Response({"detail": "Error occurred while generating payment link"})
            return Response({"detail": payment_link})
        except Exception as ex:
            buyer_logger.error(f"FundWalletAPIView detail: {ex}")
            admin_logger.error(f"FundWalletAPIView detail: {ex}")
            return Response(
                {"detail": "Error occurred while generating payment link", "error": str(ex)},
                status=status.HTTP_400_BAD_REQUEST
            )


# class UserProfileView(APIView):
#     permission_classes = [IsAuthenticated]
#
#     def get(self, request):
#         user_profile = request.user.userprofile
#         serializer = UserProfileSerializer(user_profile)
#         return Response(serializer.data)
#
#     def post(self, request):
#         serializer = UserProfileSerializer(request.user.userprofile, data=request.data, partial=True)
#         if serializer.is_valid():
#             serializer.save()
#             return Response({"detail": "Profile updated successfully"})
#         return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class ProfilePictureView(APIView):
    permission_classes = [IsAuthenticated]
    parser_classes = [MultiPartParser]

    def post(self, request):
        try:
            # Upload or replace profile picture
            user = request.user
            if 'profile_picture' not in request.FILES:
                return Response({"error": "Profile picture file not provided."}, status=status.HTTP_400_BAD_REQUEST)

            # Delete old profile picture file if exists
            if user.profile.profile_picture:
                old_path = user.profile.profile_picture.path
                if os.path.exists(old_path):
                    os.remove(old_path)

            image = request.FILES['profile_picture']
            resized_image = resize_and_save_image(image, 300, 300)
            if not resized_image:
                return Response({"detail": "No valid images were uploaded."}, status=status.HTTP_400_BAD_REQUEST)

            # Save new profile picture
            user.profile.profile_picture = resized_image
            user.profile.save()
            return Response({"detail": "Profile picture updated successfully."}, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"detail: {err}")
            admin_logger.error(f"detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"detail: {err}")
            admin_logger.error(f"detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request):
        try:
            # Delete profile picture
            user = request.user
            if user.profile.profile_picture:
                old_path = user.profile.profile_picture.path
                user.profile.profile_picture.delete()
                if os.path.exists(old_path):
                    os.remove(old_path)
                return Response({"detail": "Profile picture deleted successfully."}, status=status.HTTP_200_OK)
            return Response({"error": "No profile picture found."}, status=status.HTTP_404_NOT_FOUND)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"detail: {err}")
            admin_logger.error(f"detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"detail: {err}")
            admin_logger.error(f"detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class EditProfileView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        try:
            serializer = EditProfileSerializer(data=request.data)
            if serializer.is_valid():
                user = request.user
                user.first_name = serializer.validated_data['first_name']
                user.last_name = serializer.validated_data['last_name']
                user.profile.phone_number = serializer.validated_data['phone_number']
                user.save()
                return Response({"detail": "Profile updated successfully."}, status=status.HTTP_200_OK)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"EditProfileView detail: {err}")
            admin_logger.error(f"EditProfileView detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"EditProfileView detail: {err}")
            admin_logger.error(f"EditProfileView detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ChangePhoneNumberView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            old_phone = request.data.get('old_phone_number')
            new_phone = request.data.get('new_phone_number')
            user_profile = request.user.profile

            if user_profile.phone_number != old_phone:
                return Response({"detail": "Old phone number does not match."}, status=status.HTTP_400_BAD_REQUEST)

            user_profile.phone_number = new_phone
            user_profile.save()
            return Response({"detail": "Phone number updated successfully."}, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"ChangePhoneNumberView detail: {err}")
            admin_logger.error(f"ChangePhoneNumberView detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"ChangePhoneNumberView detail: {err}")
            admin_logger.error(f"ChangePhoneNumberView detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class ChangeEmailView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):

        serializer = ChangeEmailSerializer(data=request.data)
        if serializer.is_valid():
            old_email = serializer.validated_data['old_email']
            new_email = serializer.validated_data['new_email']

            if request.user.email != old_email:
                return Response({"detail": "Old email does not match."}, status=status.HTTP_400_BAD_REQUEST)

            # Prepare email content for confirmation
            subject = 'Confirm Your Email Address'
            message = f"Hi, click the link to confirm your new email address: {new_email}"
            payload = {
                "Message": message,
                "address": new_email,
                "Subject": subject
            }

            # Start a new thread to send the email
            email_thread = EmailThread(payload, new_email)
            email_thread.start()

            request.user.email = new_email
            request.user.profile.email_confirmed = False
            request.user.save()
            return Response({"detail": "New email requires confirmation."})
        return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)


class VerifyEmailView(APIView):
    permission_classes = []  # Allow access without authentication

    def get(self, request, uidb64, token):
        try:
            uid = force_str(urlsafe_base64_decode(uidb64))
            user = get_object_or_404(User, pk=uid)

            if account_verification_token.check_token(user, token):
                user.is_email_verified = True
                user.save()
                return Response({"detail": "Email successfully verified."}, status=status.HTTP_200_OK)
            else:
                return Response({"error": "Invalid or expired token."}, status=status.HTTP_400_BAD_REQUEST)

        except (TypeError, ValueError, OverflowError, User.DoesNotExist) as err:
            buyer_logger.error(f"VerifyEmailView detail: {err}")
            admin_logger.error(f"VerifyEmailView detail: {err}")
            return Response({"error": "Verification failed."}, status=status.HTTP_400_BAD_REQUEST)


class EmailNotificationView(APIView):
    permission_classes = [IsAuthenticated]

    def patch(self, request):
        try:
            notifications_enabled = request.data.get('notifications_enabled')
            if notifications_enabled is None:
                return Response({"error": "notifications_enabled field is required."}, status=status.HTTP_400_BAD_REQUEST)

            request.user.profile.notifications_enabled = bool(notifications_enabled)
            request.user.profile.save()
            return Response({"detail": "Email notification settings updated successfully."}, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"EmailNotificationView detail: {err}")
            admin_logger.error(f"EmailNotificationView detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"EmailNotificationView detail: {err}")
            admin_logger.error(f"EmailNotificationView detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


class TwoFactorAuthView(APIView):
    permission_classes = [IsAuthenticated]

    def post(self, request):
        try:
            method = request.data.get("2_fa_authentication")

            if method == "2_fa_authentication":
                # Generate and show the user a TOTP QR code for authenticator app setup

                user = request.user
                if not user.profile.totp_secret:
                    # Generate and save a new TOTP secret if one doesn't exist
                    user.profile.totp_secret = pyotp.random_base32()
                    user.profile.save()

                totp = pyotp.TOTP(user.profile.totp_secret)

                qr_code_data = totp.now()
                return Response({"detail": "Use an authenticator app to scan this QR code.",
                                 "qr_code_data": qr_code_data},
                                status=status.HTTP_200_OK)

            return Response({"error": "Invalid 2FA method specified."}, status=status.HTTP_400_BAD_REQUEST)
        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"TwoFactorAuthView detail: {err}")
            admin_logger.error(f"TwoFactorAuthView detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"TwoFactorAuthView detail: {err}")
            admin_logger.error(f"TwoFactorAuthView detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)

    def delete(self, request):
        try:
            # Disable 2FA by removing tokens or deactivating 2FA settings
            request.user.profile.two_factor_enabled = False
            request.user.profile.save()
            return Response({"detail": "Two-factor authentication disabled."}, status=status.HTTP_200_OK)

        except (TypeError, ValueError, OverflowError) as err:
            buyer_logger.error(f"TwoFactorAuthView detail: {err}")
            admin_logger.error(f"TwoFactorAuthView detail: {err}")
            return Response({"error": f"Process failed: {err}"}, status=status.HTTP_400_BAD_REQUEST)

        except Exception as err:
            buyer_logger.error(f"TwoFactorAuthView detail: {err}")
            admin_logger.error(f"TwoFactorAuthView detail: {err}")
            return Response({"error": str(err)},
                            status=status.HTTP_500_INTERNAL_SERVER_ERROR)


# class ChangePasswordView(APIView):
#     permission_classes = [IsAuthenticated]
#
#     def post(self, request):
#         old_password = request.data.get("old_password")
#         new_password = request.data.get("new_password")
#
#         if not request.user.check_password(old_password):
#             return Response({"error": "Old password is incorrect."}, status=status.HTTP_400_BAD_REQUEST)
#
#         try:
#             validate_password(new_password, request.user)
#         except ValidationError as e:
#             return Response({"error": e.messages}, status=status.HTTP_400_BAD_REQUEST)
#
#         request.user.set_password(new_password)
#         request.user.save()
#         return Response({"detail": "Password changed successfully."}, status=status.HTTP_200_OK)


# class ToggleEmailNotificationsView(APIView):
#     permission_classes = [IsAuthenticated]
#
#     def post(self, request):
#         user_profile = request.user.userprofile
#         email_notifications = request.data.get('email_notifications', user_profile.email_notifications)
#         user_profile.email_notifications = email_notifications
#         user_profile.save()
#         return Response({"detail": "Email notification settings updated."})


# View to turn on/off cashback bonus status
