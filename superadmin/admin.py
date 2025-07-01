from django.contrib import admin
from superadmin.models import Role, AdminUser


admin.site.register(Role)
admin.site.register(AdminUser)


admin.site.site_header = "Payarena Administration"
admin.site.site_title = "Payarena Admin Portal"
admin.site.index_title = "Welcome to Your Payarena Admin"
