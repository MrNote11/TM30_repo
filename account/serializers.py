import re

from django.core.exceptions import MultipleObjectsReturned
from rest_framework import serializers

from ecommerce.models import Cart, OrderProduct, Product
from ecommerce.serializers import ProductSerializer
from merchant.models import Seller
from store.serializers import CartSerializer
from .models import Profile, Address
from django.contrib.auth.models import User

from disposable_email_domains import blocklist
from .utils import validate_email


class RegisterSerializer(serializers.ModelSerializer):
    email = serializers.EmailField()

    class Meta:
        model = User
        fields = ['email']

    def validate_email(self, value):
        """
        Validate email for temporary domains and proper Gmail formatting.
        """
        # Clean Gmail addresses
        cleaned_email = self.clean_gmail_email(value)

        # Check if the email domain is in the blocklist
        domain = cleaned_email.split('@')[-1].lower()
        if domain in blocklist or self.is_temporary_email(cleaned_email):
            raise serializers.ValidationError("Temporary email addresses are not allowed.")

        # Check if the cleaned email is already registered
        try:
            user = User.objects.get(email=cleaned_email)

            if user.is_active:
                raise serializers.ValidationError("Email is already registered.")

            # Handle existing but inactive users
            try:
                user_activation = user.activation
                if not user_activation.is_expired():
                    raise serializers.ValidationError(
                        "An activation link has already been sent. Please check your email."
                    )
                user_activation.set_activation_expiry()
                self.context['user'] = user  # Store user in serializer context for later use
            except AttributeError:
                pass  # If activation does not exist, continue

        except User.DoesNotExist:
            self.context['user'] = None  # No user found, will create a new one in the view

        except MultipleObjectsReturned:
            raise serializers.ValidationError("Multiple accounts found with this email. Please contact support.")

        return cleaned_email

    @staticmethod
    def clean_gmail_email(email):
        """
        Standardize Gmail email by removing modifiers after `+`.
        """
        if email.endswith('@gmail.com'):
            local_part, domain = email.split('@')
            local_part = local_part.split('+')[0]  # Remove any `+modifiers`
            email = f"{local_part}@{domain}"
        return email

    @staticmethod
    def is_temporary_email(email):
        """
        Check if the email belongs to a known temporary email provider.
        """
        domain = email.split('@')[-1].lower()
        blocklist = {
            "rabitex.com",
            "temp-mail.org",
            "10minutemail.com",
            # Add more domains as needed
            "mailinator.com",
            "trashmail.com",
            "temp - mail.org",
            "10minutemail.com",
            "guerrillamail.com",
            "tempmail.net",
            "emailondeck.com",
            "throwawaymail.com",
            "fakemailgenerator.com",
            "getnada.com",
            "yopmail.com",
            "maildrop.cc",
            "burnermail.io",
            "mozmail.com",
            "kvegg.com"
        }
        return domain in blocklist


class SetPasswordSerializer(serializers.Serializer):
    first_name = serializers.CharField(write_only=True)
    last_name = serializers.CharField(write_only=True)
    phone_number = serializers.RegexField(
        regex=r'^\d{1,12}$',  # Allows only digits, with a maximum length of 12
        max_length=12,
        error_messages={
            "invalid": "Phone number must contain only digits and be at most 12 digits long."
        },
        write_only=True
    )

    password = serializers.CharField(write_only=True)
    confirm_password = serializers.CharField(write_only=True)

    def validate(self, data):
        if not data.get("first_name") and data.get("last_name"):
            raise serializers.ValidationError("First last and last name are required.")

        if data['password'] != data['confirm_password']:
            raise serializers.ValidationError("Passwords do not match.")

        if len(data['password']) < 8:
            raise serializers.ValidationError("Password length can't be less than 8.")

        if Profile.objects.filter(phone_number=data["phone_number"]).exists():
            raise serializers.ValidationError("Phone number has been used.")

        # Regular expression pattern to check for at least one uppercase letter, one lowercase letter, one digit,
        # and one special character

        password_regex = re.compile(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[^\w\s])[A-Za-z\d\W]{8,}$')
        if not password_regex.match(data['password']):
            raise serializers.ValidationError("Password is in invalid format. It must have at least one uppercase "
                                              "letter, one lowercase letter, one digit, and one special character")

        return data


class UserSerializer(serializers.ModelSerializer):
    phone_number = serializers.SerializerMethodField()

    def get_phone_number(self, obj):
        phone_no = None
        if Profile.objects.filter(user=obj).exists():
            phone_no = Profile.objects.get(user=obj).phone_number
        return phone_no

    class Meta:
        model = User
        fields = ['first_name', 'last_name', 'email', 'phone_number', 'date_joined']


class CustomerAddressSerializer(serializers.ModelSerializer):
    auth_user = serializers.HiddenField(default=serializers.CurrentUserDefault())
    is_primary = serializers.BooleanField()

    class Meta:
        model = Address
        exclude = []

    def update(self, instance, validated_data):
        is_primary = validated_data.get("is_primary")
        auth_user = validated_data.get("auth_user")

        address = super(CustomerAddressSerializer, self).update(instance, validated_data)
        if is_primary:
            address.is_primary = is_primary

        if is_primary is True:
            # Get all customer address and set their primary to false
            Address.objects.filter(customer__user=auth_user).exclude(id=instance.id).update(is_primary=False)
        address.save()
        return CustomerAddressSerializer(address, context=self.context).data


class CreateCustomerAddressSerializer(serializers.ModelSerializer):
    class Meta:
        model = Address
        exclude = []


class ProfileSerializer(serializers.ModelSerializer):
    profile_picture = serializers.SerializerMethodField()
    addresses = serializers.SerializerMethodField()
    user = UserSerializer()
    is_merchant = serializers.SerializerMethodField()
    is_licensed = serializers.SerializerMethodField()
    is_declined_merchant = serializers.SerializerMethodField()
    # cart = serializers.SerializerMethodField()
    total_purchase_count = serializers.SerializerMethodField()
    # recently_viewed_products = serializers.SerializerMethodField()

    # def get_recently_viewed_products(self, obj):
    #     if not obj.recent_viewed_products:
    #         return None
    #     shopper_views = obj.recent_viewed_products.split(",")[1:]
    #     products = Product.objects.filter(
    #         id__in=shopper_views, status="active", store__is_active=True
    #     ).order_by("?")[:10]
    #     return ProductSerializer(
    #         products, many=True, context={"request": self.context.get("request")}
    #     ).data

    def get_total_purchase_count(self, obj):
        return OrderProduct.objects.filter(
            order__customer=obj, order__payment_status="success", status="closed"
        ).count()

    # def get_cart(self, obj):
    #     if not obj.user:
    #         return None
    #     request = self.context.get("request")
    #     cart = Cart.objects.filter(user=obj.user, status="open").last()
    #     return CartSerializer(cart, context={"request": request}).data if cart else None

    def get_is_merchant(self, obj):
        if Seller.objects.filter(user=obj.user).exists():
            return True
        return False

    def get_is_licensed(self, obj):
        seller = Seller.objects.filter(user=obj.user).first()  # Get the first Seller object, or None if it doesn't exist
        if seller and (seller.status == "approve" or seller.status == "active"):
            return True
        return False

    def get_is_declined_merchant(self, obj):
        seller = Seller.objects.filter(user=obj.user).first()
        if seller and (seller.status == "declined"):
            return True
        return False

    def get_profile_picture(self, obj):
        return obj.profile_picture.url if obj.profile_picture else None

    def get_addresses(self, obj):
        addresses = Address.objects.filter(customer=obj)
        return CustomerAddressSerializer(addresses, many=True).data if addresses else None

    class Meta:
        model = Profile
        fields = [
            "id",
            "user",
            "profile_picture",
            "addresses",
            "verified",
            "has_wallet",
            "is_merchant",
            # "cart",
            "total_purchase_count",
            # "recently_viewed_products",
            "following",
            "is_licensed",
            "is_declined_merchant",
        ]


class EditProfileSerializer(serializers.Serializer):
    first_name = serializers.CharField(required=True, max_length=50)
    last_name = serializers.CharField(required=True, max_length=50)
    phone_number = serializers.CharField(required=True, max_length=15)


class ChangeEmailSerializer(serializers.Serializer):
    old_email = serializers.EmailField()
    new_email = serializers.EmailField()



    



  