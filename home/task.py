from venv import logger
from celery import shared_task
# tasks.py
from celery import shared_task
from django.utils import timezone
from django.db import transaction
from decimal import Decimal
import requests
import logging
from datetime import timedelta

from account.models import CustomerLoyaltyProgrammeWallet, YearlyBonusRecord, MerchantLoyaltyProgrammeWallet
from transaction.models import Transaction, MerchantTransaction
from ecommerce.models import *
from .models import *

from ecommerce.utils import update_purchase


buyer_logger = logging.getLogger('buyer')
payment_logger = logging.getLogger('payment')
admin_logger = logging.getLogger('admin')

logger = logging.getLogger(__name__)

@shared_task(bind=True)
def process_loyalty_rewards(self, order_id):
    """Calculate and distribute loyalty rewards for an order"""
    try:
        order = Order.objects.get(id=order_id)
        merchant_transactions = MerchantTransaction.objects.filter(order=order)
        
        for mt in merchant_transactions:
          # Update customer loyalty wall()0.4
            customer_reward=Decimal(0.40)
            merchant_reward=Decimal(0.40)
            
            customer_wallet, _ = CustomerLoyaltyProgrammeWallet.objects.get_or_create(
                customer_profile=order.customer,
                defaults={'loyalty_bonus': 0.00}
            )
            
            # Update merchant loyalty wallet
            merchant_wallet, _ = MerchantLoyaltyProgrammeWallet.objects.get_or_create(
                merchant_profile=mt.merchant,
                defaults={'loyalty_bonus': 0.00}
            )
            
            if customer_wallet:
                customer_wallet.loyalty_bonus += Decimal(mt.commission * customer_reward)
                customer_wallet.save()
                
                # Record yearly bonus if applicable
                YearlyBonusRecord.objects.create(
                    customer_profile=order.customer,
                    year=timezone.now().year,
                    loyalty_bonus_amount=customer_wallet.loyalty_bonus
                )
                


            if merchant_wallet:
                merchant_wallet.loyalty_bonus += Decimal(mt.commission * merchant_reward)
                merchant_wallet.save()
                
                YearlyBonusRecord.objects.create(
                    merchant_profile=mt.merchant,
                    year=timezone.now().year,
                    loyalty_bonus_amount=merchant_wallet.loyalty_bonus
                )
            
            # Create CashbackRecord after updating wallets
            CashbackRecords.objects.create(
                order=order,
                merchant_transactions=mt,
                merchant_rewards=merchant_wallet,
                customer_rewards=customer_wallet
            )

    except Exception as e:
        logger.error(f"Error processing loyalty rewards for order {order_id}: {e}")
        raise self.retry(exc=e, countdown=60)



@shared_task
def check_reward_eligibility():
    """Daily check for reward eligibility and rollover processing"""
    today = timezone.now().date()
    
    # Process customer wallets
    for wallet in CustomerLoyaltyProgrammeWallet.objects.filter(status='active'):
        if not wallet.is_eligible_for_bonus() and not wallet.is_rolled_over:
            # Handle point expiration or rollover logic
            wallet.is_rolled_over = True
            wallet.save()
    
    # Process merchant wallets
    for wallet in MerchantLoyaltyProgrammeWallet.objects.filter(status='active'):
        if not wallet.is_eligible_for_bonus() and not wallet.is_rolled_over:
            wallet.is_rolled_over = True
            wallet.save()



logger = logging.getLogger(__name__)

@shared_task
def yearly_reset_loyalty_bonuses(self):
    """
    Reset all customer and merchant loyalty bonuses to zero at year-end.
    This runs on December 31st at 11:59 PM.
    """
    current_year = timezone.now().year
    logger.info(f"Starting year-end loyalty bonus reset for {current_year}")
    
    try:
        with transaction.atomic():
            # Reset customer wallets and create yearly records
            customer_wallets = CustomerLoyaltyProgrammeWallet.objects.filter(status='active')
            merchant_wallets = MerchantLoyaltyProgrammeWallet.objects.filter(status='active')

            # Loop through customer wallets and record bonuses
            for wallet in customer_wallets:
                if wallet.loyalty_bonus > 0:
                    YearlyBonusRecord.objects.create(
                        customer_profile=wallet.customer_profile,
                        year=current_year,
                        loyalty_bonus_amount=wallet.loyalty_bonus,
                        recorded_at=timezone.now()
                    )

            # Loop through merchant wallets and record bonuses
            for wallet in merchant_wallets:
                if wallet.loyalty_bonus > 0:
                    YearlyBonusRecord.objects.create(
                        merchant_profile=wallet.merchant_profile,
                        year=current_year,
                        loyalty_bonus_amount=wallet.loyalty_bonus,
                        recorded_at=timezone.now()
                    )

            
            # Bulk reset all active wallets
            updated_customers = customer_wallets.update(
                loyalty_bonus=0.00,
                is_rolled_over=False,
                last_updated=timezone.now()
            )
            
            # Reset merchant wallets
            merchant_wallets = MerchantLoyaltyProgrammeWallet.objects.filter(status='active')
            updated_merchants = merchant_wallets.update(
                loyalty_bonus=0.00,
                is_rolled_over=False,
                last_updated=timezone.now()
            )
            
            logger.info(
                f"Year-end reset completed. "
                f"Reset {updated_customers} customer wallets and {updated_merchants} merchant wallets. "
                f"All active loyalty bonuses have been reset to zero for {current_year}."
            )
            
            return {
                'year': current_year,
                'customer_wallets_reset': updated_customers,
                'merchant_wallets_reset': updated_merchants,
                'timestamp': timezone.now().isoformat()
            }
            
    except Exception as e:
        logger.error(f"Failed to perform year-end loyalty bonus reset: {e}")
        raise self.retry(exc=e, countdown=60)

