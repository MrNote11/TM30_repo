from django.db import models
from transaction.models import *
from ecommerce.models import *
from account.models import *
#
#
# class Shipper(models.Moodel):
#     name = models.CharField(max_)

class CashbackRecords(models.Model):
    order = models.ForeignKey(Order, on_delete=models.SET_NULL, null=True)
    merchant_transactions = models.ForeignKey(MerchantTransaction, on_delete=models.SET_NULL, null=True)
    merchant_rewards = models.ForeignKey(MerchantLoyaltyProgrammeWallet, on_delete=models.SET_NULL, null=True)
    customer_rewards = models.ForeignKey(CustomerLoyaltyProgrammeWallet, on_delete=models.SET_NULL, null=True)
    
    def __str__(self):
        return f"{self.order}-{self.merchant_transactions}"
    