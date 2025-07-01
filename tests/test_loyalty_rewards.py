from home.task import process_loyalty_rewards  # import your task
from account.models import CustomerLoyaltyProgrammeWallet, MerchantLoyaltyProgrammeWallet
from unittest.mock import patch
from decimal import Decimal

def test_process_loyalty_rewards(db, order_factory, merchant_transaction_factory):
    order = order_factory()
    mt = merchant_transaction_factory(order=order, customer_reward=20, merchant_reward=15)

    # Force eligibility logic to return True
    with patch.object(CustomerLoyaltyProgrammeWallet, "is_eligible_for_bonus", return_value=True), \
         patch.object(MerchantLoyaltyProgrammeWallet, "is_eligible_for_bonus", return_value=True):
        process_loyalty_rewards.run(order.id)

    # Assert the bonuses were added
    customer_wallet = CustomerLoyaltyProgrammeWallet.objects.get(customer_profile=order.customer)
    merchant_wallet = MerchantLoyaltyProgrammeWallet.objects.get(merchant_profile=mt.merchant)

    assert customer_wallet.loyalty_bonus == Decimal(20.0)
    assert merchant_wallet.loyalty_bonus == Decimal(15.0)
