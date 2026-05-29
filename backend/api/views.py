from rest_framework import generics, permissions, status
from rest_framework.response import Response
from rest_framework.views import APIView

from django.contrib.auth.models import User
from rest_framework_simplejwt.tokens import RefreshToken

from django.core.mail import send_mail
from django.utils.crypto import get_random_string
from django.conf import settings

from .serializers import RegisterSerializer, UserSerializer


# TEMP STORAGE (replace with DB later)
RESET_TOKENS = {}
OTP_STORE = {}


# =========================
# REGISTER
# =========================
class RegisterView(generics.CreateAPIView):
    queryset = User.objects.all()
    permission_classes = (permissions.AllowAny,)
    serializer_class = RegisterSerializer

    def create(self, request, *args, **kwargs):
        serializer = self.get_serializer(data=request.data)
        serializer.is_valid(raise_exception=True)
        user = serializer.save()

        # Send mock SMS
        phone = request.data.get('phone', '')
        if phone:
            print(f"==========================================")
            print(f"SMS SENT TO: {phone}")
            print(f"MESSAGE: Welcome to Solar M7, {user.first_name}! Your account has been successfully created.")
            print(f"==========================================")

        refresh = RefreshToken.for_user(user)

        return Response({
            "user": UserSerializer(user).data,
            "tokens": {
                "refresh": str(refresh),
                "access": str(refresh.access_token),
            }
        }, status=status.HTTP_201_CREATED)


# =========================
# PROFILE
# =========================
class UserProfileView(generics.RetrieveUpdateAPIView):
    serializer_class = UserSerializer
    permission_classes = (permissions.IsAuthenticated,)

    def get_object(self):
        return self.request.user


# =========================
# FORGOT PASSWORD
# =========================
class ForgotPasswordView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        try:
            email = request.data.get("email")

            if not email:
                return Response(
                    {"success": False, "message": "Email is required"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            user = User.objects.filter(email=email).first()

            if user:
                # generate 6-digit OTP
                otp = str(get_random_string(6, allowed_chars="0123456789"))
                OTP_STORE[email] = otp
                print("OTP:", otp)

                send_mail(
                    subject="Password Reset OTP",
                    message=f"Your password reset OTP is: {otp}",
                    from_email=getattr(settings, "DEFAULT_FROM_EMAIL", "noreply@test.com"),
                    recipient_list=[email],
                    fail_silently=True,
                )

            return Response(
                {
                    "success": True,
                    "message": "If the email exists, an OTP has been sent."
                },
                status=status.HTTP_200_OK
            )

        except Exception as e:
            return Response(
                {
                    "success": False,
                    "message": "Server error occurred",
                    "error": str(e)
                },
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )


# =========================
# VERIFY OTP (FIXED)
# =========================
class VerifyOTPView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        email = request.data.get("email")
        otp = request.data.get("otp")

        if not email or not otp:
            return Response({
                "success": False,
                "message": "Email and OTP are required"
            }, status=status.HTTP_400_BAD_REQUEST)

        stored_otp = OTP_STORE.get(email)

        if stored_otp != otp:
            return Response({
                "success": False,
                "message": "Invalid OTP"
            }, status=status.HTTP_400_BAD_REQUEST)

        return Response({
            "success": True,
            "message": "OTP verified successfully"
        }, status=status.HTTP_200_OK)


# =========================
# RESET PASSWORD
# =========================
class ResetPasswordView(APIView):
    permission_classes = (permissions.AllowAny,)

    def post(self, request):
        try:
            email = request.data.get("email")
            otp = request.data.get("otp")
            password = request.data.get("password")

            if not email or not otp or not password:
                return Response(
                    {"success": False, "message": "Email, OTP, and password are required"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            stored_otp = OTP_STORE.get(email)

            if stored_otp != otp:
                return Response(
                    {"success": False, "message": "Invalid or expired OTP"},
                    status=status.HTTP_400_BAD_REQUEST
                )

            user = User.objects.get(email=email)
            user.set_password(password)
            user.save()

            del OTP_STORE[email]

            return Response(
                {"success": True, "message": "Password reset successful"},
                status=status.HTTP_200_OK
            )

        except User.DoesNotExist:
            return Response(
                {"success": False, "message": "User not found"},
                status=status.HTTP_404_NOT_FOUND
            )

        except Exception as e:
            return Response(
                {"success": False, "message": "Server error", "error": str(e)},
                status=status.HTTP_500_INTERNAL_SERVER_ERROR
            )