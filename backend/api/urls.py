from django.urls import path
from rest_framework_simplejwt.views import TokenObtainPairView, TokenRefreshView

from .views import (
    RegisterView,
    UserProfileView,
    ForgotPasswordView,
    VerifyOTPView,
    ResetPasswordView,
)

urlpatterns = [
    path('auth/register/', RegisterView.as_view(), name='auth_register'),

    path('auth/login/', TokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('auth/token/refresh/', TokenRefreshView.as_view(), name='token_refresh'),

    path('auth/profile/', UserProfileView.as_view(), name='auth_profile'),

    # Forgot password flow
    path('auth/forgot-password/', ForgotPasswordView.as_view(), name='auth_forgot_password'),

    # OTP verification (FIXED)
    path('auth/verify-otp/', VerifyOTPView.as_view(), name='auth_verify_otp'),

    # Reset password
    path('auth/reset-password/', ResetPasswordView.as_view(), name='auth_reset_password'),
]