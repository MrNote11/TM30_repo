import pytest
from tests.factories import OrderFactory, MerchantTransactionFactory

@pytest.fixture
def order_factory():
    return OrderFactory

@pytest.fixture
def merchant_transaction_factory():
    return MerchantTransactionFactory
