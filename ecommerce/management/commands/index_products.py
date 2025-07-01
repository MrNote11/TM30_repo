from django.core.management.base import BaseCommand
from django.contrib.postgres.search import SearchVector
from ecommerce.models import Product


class Command(BaseCommand):
    help = "Update search_vector field for existing products wit empty values"

    def handle(self, *args, **kwargs):
        products_without_vector = Product.objects.filter(search_vector__isnull=True)

        for product in products_without_vector:
            product.search_vector = SearchVector('name', 'description', "tags")
            product.save(update_fields=["search_vector"])

        self.stdout.write(
            self.style.SUCCESS(f"Updated search_vector for {products_without_vector.count()} products")
        )
