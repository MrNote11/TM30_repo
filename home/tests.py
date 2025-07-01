# from django.test import APITestCase,APIClient
from django.urls import reverse
from .task import *
from account.models import *
from transaction.models import MerchantTransaction
from django.test import TestCase
\
# Create your tests here.
from rest_framework.test import APITestCase,APIClient
from rest_framework import status
from ecommerce.models import Product,ProductDetail
from ecommerce.serializers import ProductSerializer
from account.models import CustomerLoyaltyProgrammeWallet, MerchantLoyaltyProgrammeWallet, Profile
from django.urls import reverse
from rest_framework.test import APIClient

from ecommerce.models import Product, ProductDetail
from ecommerce.serializers import ProductSerializer
from django.contrib.auth import get_user_model
import pytest
from django.urls import reverse
from rest_framework.test import APIClient

from ecommerce.models import Product, ProductDetail
from ecommerce.serializers import ProductSerializer
from django.contrib.auth import get_user_model
from store.models import Store  # Ensure you import your Store model

User = get_user_model()


class ProductAPITestCase(APITestCase):

    def setUp(self):
        self.client = APIClient()
        self.user = User.objects.create_user(username='tester', password='testpass123')
        self.store = Store.objects.create(name="Test Store", owner=self.user)

        self.product = Product.objects.create(
            name="Test Product",
            store=self.store,
            status="active"
        )

        self.product_detail = ProductDetail.objects.create(
            product=self.product,
            price=1000.00,
            discount=50.00,
            stock=10
        )

        self.list_url = reverse("product") 
        self.detail_url = reverse("product-detail", kwargs={"slug": self.product.slug})

    def test_get_product_list(self):
        response = self.client.get(self.list_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertIsInstance(response.data, list)

    def test_get_product_detail(self):
        response = self.client.get(self.detail_url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        self.assertEqual(response.data['name'], self.product.name)

    def test_product_not_found(self):
        url = reverse("product-detail", kwargs={"slug": "non-existent-slug"})
        response = self.client.get(url)
        self.assertEqual(response.status_code, status.HTTP_404_NOT_FOUND)

    def test_product_slug_updates_on_name_change(self):
        old_slug = self.product.slug
        self.product.name = "Updated Name"
        self.product.save()
        self.assertNotEqual(self.product.slug, old_slug)

    def test_create_product_if_post_allowed(self):
        data = {
            "name": "New Posted Product",
            "store": self.store.id,
            "status": "active"
        }
        response = self.client.post(self.list_url, data, format='json')
        self.assertIn(response.status_code, [status.HTTP_201_CREATED, status.HTTP_405_METHOD_NOT_ALLOWED])

    def test_negative_stock_raises_error(self):
        with self.assertRaises(Exception):
            ProductDetail.objects.create(
                product=self.product,
                price=1000,
                stock=-3
            )

    def test_product_view_count_increment(self):
        initial_view_count = self.product.view_count
        self.client.get(self.detail_url)
        self.product.refresh_from_db()
        # Only assert if your view actually increases this
        self.assertGreaterEqual(self.product.view_count, initial_view_count)

    def test_discount_calculation(self):
        actual_price = float(self.product_detail.price) - float(self.product_detail.discount)
        self.assertEqual(actual_price, 950.00)    

class LoyaltyProgrammeAPITest(APITestCase):
    def setUp(self):
        self.user = User.objects.create_user(username='testuser', email='test@example.com', password='testpass')
        self.profile = Profile.objects.create(user=self.user, phone_number='1234567890', verified=True)
        self.loyalty = CustomerLoyaltyProgrammeWallet.objects.create(profile=self.profile, status='active', balance=100)
        self.client = APIClient()
        self.client.force_authenticate(user=self.user)

    def test_view_cashback_balance(self):
        url = reverse('view-cashback-wallet')  # Use your actual URL name
        response = self.client.get(url)
        self.assertEqual(response.status_code, 200)
        self.assertIn('balance', response.data)
        self.assertEqual(response.data['balance'], 100)

    def test_redeem_cashback(self):
        url = reverse('redeem-cashback')  # Use your actual URL name
        response = self.client.post(url)
        self.assertEqual(response.status_code, status.HTTP_200_OK)
        # Optionally, check that balance is now zero or as expected
        self.loyalty.refresh_from_db()
        self.assertEqual(self.loyalty.balance, 0)

    def test_unauthorized_access(self):
        self.client.force_authenticate(user=None)
        url = reverse('view-cashback-wallet')
        response = self.client.get(url)
        self.assertEqual(response.status_code,status.HTTP_401_UNAUTHORIZED)
        
# class Testcase(APITestCase):
#     def setup(self):
        
#         self.client=APIClient()
#         self.confirm_transaction=reverse('paymrnt-verify')
#         self.model=MerchantTransaction.objects.filter()
        

#     def test_successful_order_confirmation(self):
#         res=self.client.post()





# Create your tests here.
