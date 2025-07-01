import logging
import uuid

from django.conf import settings
from django.contrib.auth import user_logged_in
from django.contrib.postgres.search import SearchVector
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver
from django.utils.text import slugify
# from elasticsearch import ElasticsearchException, Elasticsearch
from rest_framework.response import Response

# from ecommerce.document import ProductDocument
from ecommerce.models import Promo, Product

from rest_framework.test import APIRequestFactory

# from home.utils import log_request
import logging

buyer_logger = logging.getLogger('buyer')
shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')


@receiver(signal=post_save, sender=Promo)
def property_post_save(sender, instance, **kwargs):
    property_obj = Promo.objects.filter(id=instance.id)
    if not instance.slug:
        slug = slugify(f"{instance.title}-{instance.id}{str(uuid.uuid4())[:5]}")
        property_obj.update(slug=slug)


@receiver(post_save, sender=Product)
def update_search_vector(sender, instance, **kwargs):
    update_fields = kwargs.get('update_fields', [])

    # Ensure update_fields is iterable and 'search_vector' isn't in it
    if isinstance(update_fields, (list, tuple, set)) and 'search_vector' in update_fields:
        return  # Prevent recursion

    try:
        # Temporarily disconnect the signal to avoid recursion
        post_save.disconnect(update_search_vector, sender=Product)

        # Update the search vector
        instance.search_vector = SearchVector('name', 'description', 'tags')
        instance.save(update_fields=['search_vector'])
        #         # Directly update using a query without saving the model again
        #         sender.objects.filter(pk=instance.pk).update(
        #             search_vector=SearchVector('name', 'description', 'tags')
        #         )

    except Exception as e:
        admin_logger.error(f"An error occurred while updating the search vector: {e}")
        return str(e)

    finally:
        # Reconnect the signal
        post_save.connect(update_search_vector, sender=Product)

