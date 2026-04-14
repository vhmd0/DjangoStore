from django.db import transaction
from django.db.models.signals import post_save, post_delete
from django.dispatch import receiver

from .models import Banner


def invalidate_banner_cache():
    from django.core.cache import cache

    cache.delete("home_banners")


@receiver(post_save, sender=Banner)
def banner_post_save(sender, instance, **kwargs):
    transaction.on_commit(invalidate_banner_cache)


@receiver(post_delete, sender=Banner)
def banner_post_delete(sender, instance, **kwargs):
    transaction.on_commit(invalidate_banner_cache)
