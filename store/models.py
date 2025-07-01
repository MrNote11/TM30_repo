import uuid

from django.db import models
from django.urls import reverse

from ecommerce.models import ProductCategory
from merchant.models import Seller


class Store(models.Model):
    seller = models.ForeignKey(Seller, on_delete=models.CASCADE, related_name='seller')
    slug = models.CharField(max_length=500, null=True, blank=True, editable=False)
    name = models.CharField(max_length=100, null=True, blank=True)
    logo = models.ImageField(upload_to='store-logo')
    description = models.TextField()
    categories = models.ManyToManyField(ProductCategory)
    is_active = models.BooleanField(default=False)
    on_sale = models.BooleanField(default=False)
    created_on = models.DateTimeField(auto_now_add=True)
    updated_on = models.DateTimeField(auto_now=True)

    def save(self, *args, **kwargs):
        temp_slug = f"{self.name.replace(' ', '-')}-{str(uuid.uuid4()).replace('-', '')[:8]}"

        # Always update the slug when the name changes
        if self.pk:  # Check if it's an update, not a new instance
            existing = self.__class__.objects.filter(pk=self.pk).first()
            if existing and existing.name != self.name:
                self.slug = temp_slug
        else:
            self.slug = temp_slug  # Generate slug for new instances

        super().save(*args, **kwargs)

    def __str__(self):
        return f"{self.id}: {self.seller} - {self.name}"

    def get_absolute_url(self):
        return reverse('store_detail', kwargs={'store_owner': self.seller.user.username})


