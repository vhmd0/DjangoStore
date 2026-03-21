"""
Custom middleware for the SmartS3R project.
"""

from django.utils.translation import get_language


class LanguageDirectionMiddleware:
    """
    Middleware that adds LANGUAGE_DIRECTION to the request object.

    Automatically detects RTL languages and sets the direction accordingly.
    Works with Django's translation system to determine the current language.
    """

    RTL_LANGUAGE_CODES = frozenset({"ar", "he", "fa", "ur", "yi", "ps", "sd"})

    def __init__(self, get_response):
        self.get_response = get_response

    def __call__(self, request):
        language_code = get_language()
        request.LANGUAGE_DIRECTION = self._get_direction(language_code)
        return self.get_response(request)

    def _get_direction(self, language_code: str) -> str:
        """Determine text direction based on language code."""
        short_code = language_code.split("-")[0].lower()
        return "rtl" if short_code in self.RTL_LANGUAGE_CODES else "ltr"
