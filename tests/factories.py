import factory
from ecommerce.models import Order
from merchant.models import Seller
from transaction.models import MerchantTransaction
from account.models import Profile
from django.utils import timezone
from django.contrib.auth import get_user_model

User = get_user_model()


class UserFactory(factory.django.DjangoModelFactory):
    class Meta:
        skip_postgeneration_save = True
        model = User

    username = factory.Faker("user_name")
    email = factory.Faker("email")
    password = factory.PostGenerationMethodCall("set_password", "password123")


class ProfileFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Profile

    user = factory.SubFactory(UserFactory)  # ⚠️ Important fix



class SellerFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Seller

    user = factory.SubFactory(UserFactory) 
    merchant_id = factory.Faker("ean8")
    declined_reason = factory.Faker("sentence")


class OrderFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = Order

    customer = factory.SubFactory(ProfileFactory)
    payment_status = 'pending'


class MerchantTransactionFactory(factory.django.DjangoModelFactory):
    class Meta:
        model = MerchantTransaction

    order = factory.SubFactory(OrderFactory)
    merchant = factory.SubFactory(SellerFactory)
    mall_income = 5.00
    customer_reward = mall_income % 0.02
    merchant_reward = mall_income % 0.02
    system_rewards = mall_income % 0.02
    amount = 100
    delivery_fee = 0
    total = 100
    
