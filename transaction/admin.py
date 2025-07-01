from django.contrib import admin
from .models import Transaction, MerchantTransaction


class TransactionModelAdmin(admin.ModelAdmin):
    list_display = ["order", "payment_method", "transaction_reference", "status"]
    list_filter = ["payment_method", "status"]
    search_fields = ["transaction_reference"]


admin.site.register(Transaction, TransactionModelAdmin)
admin.site.register(MerchantTransaction)

