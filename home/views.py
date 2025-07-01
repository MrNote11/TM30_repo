from threading import Thread
from celery import shared_task
import requests
from django.http import HttpResponseRedirect
from django.shortcuts import render, HttpResponse
from rest_framework.views import APIView
from rest_framework.response import Response
from rest_framework import status
from django.db import transaction
from account.models import Profile
from account.utils import fund_customer_wallet
from ecommerce.utils import update_purchase
# from home.utils import log_request
from merchant.utils import get_all_banks
from rest_framework.permissions import AllowAny, IsAdminUser, IsAuthenticated
from django.conf import settings
from .task import process_loyalty_rewards
from transaction.models import Transaction, MerchantTransaction
import logging


buyer_logger = logging.getLogger('buyer')
shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')

frontend_base_url = settings.FRONTEND_URL


class HomeView(APIView):
    permission_classes = []

    def get(self, request):
        return HttpResponse('Welcome to PAYARENA MALL')


class ListAllBanksAPIView(APIView):

    def get(self, request):
        profile = Profile.objects.get(user=request.user)
        success, detail = get_all_banks(profile)
        if success is False:
            return Response({"detail": detail}, status=status.HTTP_400_BAD_REQUEST)
        return Response(detail)



class OrderPaymentVerifyAPIView(APIView):
    permission_classes = [AllowAny]

    def get(self, request):
        buyer_logger.info(request.data)
        payment_logger.info(request.data)
        admin_logger.info(request.data)
        trans_ref = request.GET.get("trxId")
        trans_status = request.GET.get("status")
        order_id = request.GET.get("order")

        # Find all transactions for the order
        transactions = MerchantTransaction.objects.filter(order__id=order_id)

        if not transactions.exists():
            return Response({"error": "Transaction not found"}, status=status.HTTP_400_BAD_REQUEST)
        try:
            with transaction.atomic():
                
                for trans in transactions:
                    
                    trans.transaction.transaction_reference = trans_ref
                    trans.transaction.transaction_detail = f"Payment for OrderID: {order_id}"
                    trans.save()

                    if trans_status == "APPROVED":
                        trans.transaction.status = "success"
                        trans.order.payment_status = "success"
                        order = trans.order
                        payment_method = trans.transaction.payment_method
                        source = trans.transaction.source

                        buyer_logger.info(f"Order: {order}, Payment: {payment_method}, Source: {source}")
                        admin_logger.info(f"Order: {order}, Payment: {payment_method}, Source: {source}")
                        payment_logger.info(f"Order: {order}, Payment: {payment_method}, Source: {source}")
                        
                        Thread(target=update_purchase, args=[order, payment_method, source]).start()
                        
                        
                        process_loyalty_rewards.delay(order.id)  # Pass order.id instead of order object

                    elif trans_status == "DECLINED":
                        trans.transaction.status = "failed"
                        trans.order.payment_status = "failed"

                    # Fetch payment details
                    url = f"https://pay.mypayloft.com/status/{trans.transaction.transaction_reference}"
                    response_json = requests.get(url)
                    trans.transaction.detailed_json = response_json.json()

                    trans.order.save()
                    trans.save()

        except Exception as err:
            buyer_logger.error(f"Error occurred: {err}")
            payment_logger.error(f"Error occurred: {err}")
            admin_logger.error(f"Error occurred: {err}")
            return Response({"error": str(err)}, status=status.HTTP_500_INTERNAL_SERVER_ERROR)

        redirect_url = f"{settings.UPDATED_FRONTEND_URL}/confirm-payment?status={trans_status}&transactionId={trans_ref}&orderId={order_id}"
        return HttpResponseRedirect(redirect_to=redirect_url)

class FundWalletVerifyAPIView(APIView):
    permission_classes = []

    def post(self, request):
        reference = request.data.get("trxId")
        trans_status = fund_customer_wallet(reference)
        # Redirect to frontend endpoint
        return HttpResponseRedirect(redirect_to=f"{frontend_base_url}/verify-wallet?status={str(trans_status)}")


