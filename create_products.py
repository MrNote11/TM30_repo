import os
import requests
import uuid
from django.utils.text import slugify
from django.core.management import execute_from_command_line
import django


# Set up Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'payarena.settings.dev')  # Replace with your actual settings module

django.setup()

from ecommerce.models import Product, ProductDetail, ProductImage, Image, \
    ProductCategory  # Replace with your actual app name
from django.contrib.postgres.search import SearchVector


# def fetch_and_save_products():
#     url = "https://fakestoreapi.com/products/"
#     response = requests.get(url)
#     data = response.json()
#
#     # Limit to the first 10 products
#     products_to_save = data[:20]
#
#     for product in products_to_save:
#         # Extract relevant data from the API response
#         title = product["title"]
#         price = product["price"]
#         description = product["description"]
#         rating = product.get("rating", {})
#         category_name = product.get("category", "Uncategorized")  # Handle missing category
#         image_url = product.get("image", None)  # Handle missing image
#
#         # Create or retrieve a Category object
#         category, created = ProductCategory.objects.get_or_create(name=category_name)
#
#         # Create Product instance
#         new_product = Product.objects.create(
#             name=title,
#             description=description,
#             category=category,
#             slug=slugify(f'{title}-{uuid.uuid4()}'),  # Generate unique slug
#             view_count=rating.get("count", 0),  # Example of using count field in rating
#         )
#         new_product.save()
#
#         # Create ProductDetail with default values for missing data
#         product_detail = ProductDetail(
#             product=new_product,
#             sku=str(uuid.uuid4()),  # Generate a unique SKU
#             stock=10,  # Default stock value
#             weight=1.0,  # Default weight
#             price=price,
#             size="M",  # Default size
#         )
#         product_detail.save()
#
#         # Handle image
#         if image_url:
#             # Download image data
#             image_response = requests.get(image_url, stream=True)
#             if image_response.status_code == 200:
#                 # Generate a unique filename
#                 filename = str(uuid.uuid4()) + '.jpg'
#
#                 # Create directory for images if not exists
#                 os.makedirs('images/product_images', exist_ok=True)
#
#                 # Save the image to the file system
#                 with open(f'images/product_images/{filename}', 'wb') as f:
#                     for chunk in image_response.iter_content(1024):
#                         f.write(chunk)
#
#                 # Create an Image instance
#                 image_instance = Image.objects.create(
#                     image=f'product_images/{filename}'
#                 )
#
#                 # Create ProductImage linking to ProductDetail
#                 product_image = ProductImage(
#                     product_detail=product_detail,
#                     image=image_instance
#                 )
#                 product_image.save()
#
#     print("Products and details saved successfully.")


def update_search_vector():
    # Update search vector for all products
    Product.objects.update(search_vector=SearchVector('name', 'description', 'tags'))


if __name__ == "__main__":
    # fetch_and_save_products()
    update_search_vector()
