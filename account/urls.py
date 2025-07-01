from django.urls import path
from rest_framework_simplejwt.views import TokenRefreshView

from . import views

app_name = "account"

urlpatterns = [
    path('register/', views.RegisterView.as_view(), name='register'),

    path('login/', views.LoginUserView.as_view(), name='user-login'),  # POST
    path('refresh-token/', TokenRefreshView.as_view(), name='refresh-token'),

    # Google OAuth endpoint
    # path('auth/google/', views.GoogleSignUpView.as_view(), name='google-auth'),

    # Facebook OAuth endpoint
    # path('auth/facebook/', views.FacebookSignUpView.as_view(), name='facebook-auth'),

    path('logout/', views.LogoutView.as_view(), name="logout"),  # POST

    path('activate-email/<uid>/', views.ActivateEmailView.as_view(), name='activate-email'),
    path('set-password/<uid>/', views.SetPasswordView.as_view(), name='set-password'),

    path('forgot-password/', views.ForgotPasswordView.as_view(), name="forgot-password"),  # GET and POST
    path('change-password/', views.ChangePasswordView.as_view(), name="change-password"),  # PUT
    path('resend-verification/', views.ResendVerificationLinkView.as_view(), name="resend-verification-link"),
    path('link-verification/<str:token>/', views.EmailVerificationLinkView.as_view(), name="link-verification"),

    # Customer Address
    path('address/', views.CustomerAddressView.as_view(), name='customer-address'),
    path('address/<int:id>/', views.CustomerAddressDetailView.as_view(), name='customer-address-detail'),

    # Wallet
    path('wallet/', views.CreateCustomerWalletAPIView.as_view(), name='create-wallet'),
    path('fund-wallet/', views.FundWalletAPIView.as_view(), name='fund-wallet'),

    # Account Settings
    path('profile-picture/', views.ProfilePictureView.as_view(), name='profile-picture'),
    path('edit-profile/', views.EditProfileView.as_view(), name='edit-profile'),
    path('change-number/', views.ChangePhoneNumberView.as_view(), name='change-email'),
    path('change-email/', views.ChangeEmailView.as_view(), name='change-email'),
    path('verify-email/', views.VerifyEmailView.as_view(), name='verify-email'),
    path('email-notification/', views.EmailNotificationView.as_view(), name='email-notification'),
    path('2fa-authentication/', views.TwoFactorAuthView.as_view(), name='2fa-authentication'),
]
