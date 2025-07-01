from django.contrib import admin
from account.models import Profile, Address, UserActivation, CustomerLoyaltyProgrammeWallet, YearlyBonusRecord, MerchantLoyaltyProgrammeWallet


class AddressStackInlineAdmin(admin.StackedInline):
    model = Address


class ProfileAdmin(admin.ModelAdmin):
    list_display = ["user", "phone_number"]
    search_fields = ["user__first_name", "user__email"]
    list_filter = ["created_on"]
    inlines = [AddressStackInlineAdmin]

class CustomerLoyaltyProgrammeWalletAdmin(admin.ModelAdmin):
    list_display = ["customer_profile", "loyalty_bonus", "status", "last_updated", "is_rolled_over"]
    search_fields = ["user__first_name", "user__email"]
    list_filter = ["status", "is_rolled_over"]
    
class MerchantLoyaltyProgrammeWalletAdmin(admin.ModelAdmin):
    list_display = ["merchant_profile", "loyalty_bonus", "status", "last_updated", "is_rolled_over"]
    search_fields = ["user__first_name", "user__email"]
    list_filter = ["status", "is_rolled_over"]    
    
class YearlyBonusRecordAdmin(admin.ModelAdmin):
    list_display = ["merchant_profile", "customer_profile", "year", "loyalty_bonus_amount", "recorded_at"]
    search_fields = ["profile__user__first_name", "profile__user__email", "recorded_at"]
    list_filter = ["year"]

admin.site.register(Profile, ProfileAdmin)
admin.site.register(UserActivation)
admin.site.register(MerchantLoyaltyProgrammeWallet, MerchantLoyaltyProgrammeWalletAdmin)
admin.site.register(CustomerLoyaltyProgrammeWallet, CustomerLoyaltyProgrammeWalletAdmin)
admin.site.register(YearlyBonusRecord, YearlyBonusRecordAdmin)
