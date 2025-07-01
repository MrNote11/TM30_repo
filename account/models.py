import uuid
from django.db.models import Max, Sum
from django.contrib.auth.models import User
from django.db import models

from merchant.models import Seller
from store.models import Store
from .choices import card_from_choices, address_type_choices

from django.contrib.auth import get_user_model
from django.utils import timezone
from datetime import timedelta


class UserActivation(models.Model):
    User = get_user_model()
    user = models.OneToOneField(User, on_delete=models.CASCADE, related_name="activation")
    activation_token_expiry = models.DateTimeField(null=True, blank=True)

    def set_activation_expiry(self):
        """Set the activation token expiry to 10 minutes from now."""
        # self.activation_token = uuid.uuid4()  # Generate a new token for each resend
        self.activation_token_expiry = timezone.now() + timedelta(minutes=10)
        self.save()

    def is_expired(self):
        """Check if the activation link has expired."""
        return timezone.now() > self.activation_token_expiry

    def __str__(self):
        return f"{self.user} expires at {self.activation_token_expiry}"


class Profile(models.Model):
    user = models.OneToOneField(User, on_delete=models.CASCADE)
    has_wallet = models.BooleanField(default=False)
    phone_number = models.CharField(max_length=20, null=True, blank=True)
    profile_picture = models.ImageField(upload_to='profile-pictures', null=True, blank=True)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)
    verified = models.BooleanField(default=False)
    pay_auth = models.TextField(blank=True, null=True)
    pay_token = models.TextField(blank=True, null=True)
    wallet_pin = models.TextField(blank=True, null=True)
    verification_code = models.CharField(max_length=100, null=True, blank=True)

    following = models.ManyToManyField(Seller, blank=True, related_name='following_list')
    totp_secret = models.CharField(max_length=32, blank=True, null=True)  # For app-based 2FA
    notifications_enabled = models.BooleanField(default=False)

    code_expiration_date = models.DateTimeField(null=True, blank=True)
    recent_viewed_products = models.TextField(blank=True, null=True)

    def __str__(self):
        return str(self.user)

    def get_full_name(self):
        return f'{self.user.first_name} {self.user.last_name}'

    def first_name(self):
        return self.user.first_name

    def last_name(self):
        return self.user.last_name

    def email(self):
        return self.user.email


class UserCard(models.Model):
    profile = models.ForeignKey(Profile, on_delete=models.CASCADE)
    bank = models.CharField(max_length=50, null=True)
    card_from = models.CharField(max_length=50, null=True, choices=card_from_choices, default='paystack')
    card_type = models.CharField(max_length=50, null=True)
    bin = models.CharField(max_length=300, null=True)
    last4 = models.CharField(max_length=50, null=True)
    exp_month = models.CharField(max_length=2, null=True)
    exp_year = models.CharField(max_length=4, null=True)
    signature = models.CharField(max_length=200, null=True)
    authorization_code = models.CharField(max_length=200, null=True)
    payload = models.TextField(null=True)
    default = models.BooleanField(default=False, null=True)

    def __str__(self):
        return f"{self.id}: {self.profile}"


class Address(models.Model):
    customer = models.ForeignKey(Profile, on_delete=models.CASCADE)
    type = models.CharField(max_length=10, choices=address_type_choices, default='home')
    name = models.CharField(max_length=500)
    mobile_number = models.CharField(max_length=17)
    locality = models.CharField(max_length=500, blank=True, null=True)
    landmark = models.CharField(max_length=500, blank=True, null=True)
    country = models.CharField(max_length=100)
    state = models.CharField(max_length=100)
    city = models.CharField(max_length=100)
    town = models.CharField(max_length=100, blank=True, null=True)
    town_id = models.CharField(max_length=100, blank=True, null=True)
    postal_code = models.CharField(default=0, blank=True, null=True, max_length=50)
    longitude = models.FloatField(null=True, blank=True, default=0.0)
    latitude = models.FloatField(null=True, blank=True, default=0.0)
    is_primary = models.BooleanField(default=False)
    updated_on = models.DateTimeField(auto_now=True)

    # def get_full_address(self):
    #     addr = ""
    #     if self.locality:
    #         addr += f"{self.locality}, "
    #     if self.town:
    #         addr += f"{self.town}, "
    #     if self.city:
    #         addr += f"{self.city}, "
    #     if self.state:
    #         addr += f"{self.state}, "
    #     return addr.strip()

    @property
    def get_full_address(self):
        components = [self.type, self.name, self.landmark, self.town, self.state]
        return ', '.join(filter(None, components))

    def __str__(self):
        return "{} {} {}".format(self.type, self.name, self.landmark, self.locality)

    class Meta:
        verbose_name_plural = "Addresses"



class CustomerLoyaltyProgrammeWallet(models.Model):
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('inactive', 'Inactive'),
    ]

    customer_profile = models.OneToOneField(Profile, on_delete=models.CASCADE)
    loyalty_bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='active')
    last_updated = models.DateTimeField(auto_now=True)
    is_rolled_over = models.BooleanField(default=False)

    def is_eligible_for_bonus(self):
        today = timezone.now().date()
        year = today.year
        month = today.month

        if month == 1:
            prev_month_last_day = timezone.datetime(year - 1, 12, 31).date()
        else:
            prev_month_last_day = (timezone.datetime(year, month, 1) - timedelta(days=1)).date()

     
        current_month_fifth_day = timezone.datetime(year, month, 5).date()

        is_within_range = prev_month_last_day <= today <= current_month_fifth_day
        is_active = self.status == 'active'

        return is_within_range and is_active

   

    @classmethod
    def get_loyalty_balance(cls, profile):
        total = cls.objects.filter(profile=profile).aggregate(
            total_bonus=Sum('loyalty_bonus')
        )['total_bonus'] or 0.00
        return total


    def __str__(self):
        return f"{self.customer_profile} - Bonus: {self.loyalty_bonus} - Status: {self.status}"




class MerchantLoyaltyProgrammeWallet(models.Model):
    STATUS_CHOICES = [
        ('active', 'Active'),
        ('inactive', 'Inactive'),
    ]
    merchant_profile = models.OneToOneField(Seller, on_delete=models.CASCADE)
    loyalty_bonus = models.DecimalField(max_digits=10, decimal_places=2, default=0.00)
    status = models.CharField(max_length=10, choices=STATUS_CHOICES, default='active')
    last_updated = models.DateTimeField(auto_now=True)
    is_rolled_over = models.BooleanField(default=False)

    def is_eligible_for_bonus(self):
        today = timezone.now().date()
        year = today.year
        month = today.month

        if month == 1:
            prev_month_last_day = timezone.datetime(year - 1, 12, 31).date()
        else:
            prev_month_last_day = (timezone.datetime(year, month, 1) - timedelta(days=1)).date()

     
        current_month_fifth_day = timezone.datetime(year, month, 5).date()

        is_within_range = prev_month_last_day <= today <= current_month_fifth_day
        is_active = self.status == 'active'

        return is_within_range and is_active

   

    @classmethod
    def get_loyalty_balance(cls, profile):
        total = cls.objects.filter(profile=profile).aggregate(
            total_bonus=Sum('loyalty_bonus')
        )['total_bonus'] or 0.00
        return total


    def __str__(self):
        return f"{self.merchant_profile} - Bonus: {self.loyalty_bonus} - Status: {self.status}"


class YearlyBonusRecord(models.Model):
    customer_profile = models.ForeignKey(Profile, on_delete=models.CASCADE)
    merchant_profile = models.ForeignKey(Seller, on_delete=models.CASCADE)
    year = models.PositiveIntegerField()
    loyalty_bonus_amount = models.DecimalField(max_digits=10, decimal_places=2)
    recorded_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.profile} - {self.year} - Bonus: {self.loyalty_bonus_amount}"