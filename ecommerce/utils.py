import base64
import datetime
import decimal
import json
import uuid
from threading import Thread

import requests
from Crypto.Cipher import AES
from Crypto.Util.Padding import pad, unpad
from cryptography.fernet import Fernet
from django.conf import settings
from django.db import transaction
from django.db.models import Avg, Sum
from django.http import JsonResponse
from django.shortcuts import get_object_or_404
from django.urls import reverse
from django.utils import timezone
from requests import RequestException
from account.models import Address
from home.utils import get_week_start_and_end_datetime, get_month_start_and_end_datetime, get_next_date, \
    get_year_start_and_end_datetime, get_previous_month_date
from merchant.merchant_email import merchant_order_placement_email
from module.billing_service import BillingService
from module.shipping_service import ShippingService
from transaction.models import Transaction, MerchantTransaction
from .models import Cart, Product, ProductDetail, CartProduct, ProductReview, Order, OrderProduct
from django.db import transaction
from django.conf import settings
import logging


from .shopper_email import shopper_order_placement_email

encryption_key = bytes(settings.PAYARENA_CYPHER_KEY, "utf-8")
encryption_iv = bytes(settings.PAYARENA_IV, "utf-8")


admin_logger = logging.getLogger('admin')
buyer_logger = logging.getLogger('buyer')

payment_logger = logging.getLogger('payment')


def sorted_queryset(order_by, query):
    queryset = Product.objects.filter(query).distinct()
    if order_by == "latest":
        queryset = Product.objects.filter(query).order_by('-published_on').distinct()
    if order_by == 'highest_price':
        queryset = Product.objects.filter(query).order_by('-productdetail__price').distinct()
    if order_by == 'lowest_price':
        queryset = Product.objects.filter(query).order_by('productdetail__price').distinct()
    if order_by == 'highest_discount':
        queryset = Product.objects.filter(query).order_by('-productdetail__discount').distinct()
    if order_by == 'lowest_discount':
        queryset = Product.objects.filter(query).order_by('productdetail__discount').distinct()
    if order_by == 'highest_rating':
        queryset = Product.objects.filter(query).order_by('-productreview__rating').distinct()
    if order_by == 'lowest_rating':
        queryset = Product.objects.filter(query).order_by('productreview__rating').distinct()
    return queryset


def check_cart(user=None, cart_id=None, cart_uid=None):
    if cart_uid is not None:
        cart_check = Cart.objects.filter(cart_uid=cart_uid, status="open").exists()
        return cart_check, Cart.objects.filter(cart_uid=cart_uid, status="open")

    if cart_id is not None:
        return Cart.objects.filter(id=cart_id, status="open").exists(), Cart.objects.filter(id=cart_id, status="open")

    if Cart.objects.filter(user=user, status="open").exists():
        return True, Cart.objects.filter(user=user, status="open")

    return False, "Cart not found"


def create_or_update_cart_product(variant, cart):
    for variation_obj in variant:
        variation_id = variation_obj.get('variant_id', '')
        quantity = variation_obj.get('quantity', 1)

        with transaction.atomic():
            product_detail = get_object_or_404(ProductDetail.objects.select_for_update(), id=variation_id)

        # try:
        if quantity > 0:
            if product_detail.stock <= 0:
                return False, f"Selected product: ({product_detail.product.name}) is out of stock"

            if product_detail.stock < quantity:
                return False, f"Selected product: ({product_detail.product.name}) quantity cannot be greater than available"

            if product_detail.product.status != "active":
                return False, f"Selected product: ({product_detail.product.name}) is not available"

            if product_detail.product.store.is_active is False:
                return False, f"Selected product: ({product_detail.product.name}) is not available"

        # Create Cart Product
        # print(cart)
        cart.refresh_from_db()
        cart_product, _ = CartProduct.objects.get_or_create(cart=cart, product_detail=product_detail)
        cart_product.price = product_detail.price * quantity
        cart_product.discount = product_detail.discount * quantity
        if product_detail.discount > 0:
            cart_product.price = product_detail.discount * quantity
        cart_product.quantity = quantity
        cart_product.save()

        # Remove cart_product if quantity is 0
        if cart_product.quantity < 1:
            cart_product.delete()

        # cart_product = CartProduct.objects.create(
        #     cart=cart, product_detail=product_detail, price=product_detail.price,
        #     discount=product_detail.discount, quantity=1)
    return True, "Cart updated"
    # except (Exception,) as err:
    #     return False, f"{err}"


def perform_operation(operation_param, product_detail, cart_product):
    # what operation to perform ?
    if operation_param not in ("+", "-", "remove"):
        buyer_logger.info("Invalid operation parameter expecting -, +, remove")
        admin_logger.info("Invalid operation parameter expecting -, +, remove")
        return False, "Invalid operation parameter expecting -, +, remove"

    if operation_param == "+":
        if product_detail.stock > cart_product.quantity + 1:
            cart_product.quantity += 1
            cart_product.price += product_detail.price
            cart_product.save()
            return True, "Added product to cart"
        else:
            # product is out of stock
            return False, "Product is out of stock"

    if operation_param == "-":
        if cart_product.quantity == 1:
            # remove from cart and give response.
            cart_product.delete()
            return True, "Cart product has been removed"

        if cart_product.quantity > 1:
            #   reduce prod_cart and give responses.
            cart_product.quantity -= 1
            cart_product.price -= product_detail.price
            cart_product.save()
            return True, "Cart product has been reduced"

        # Product not available
        return False, "Product is not in cart"

    if operation_param == "remove":
        # remove product and give response
        cart_product.delete()
        return True, "Cart product has been removed"


def top_weekly_products(request):
    top_products = []
    current_date = timezone.now()
    week_start, week_end = get_week_start_and_end_datetime(current_date)
    query_set = Product.objects.filter(
        created_on__gte=week_start, created_on__lte=week_end, status='active', store__is_active=True).order_by(
        "-sale_count"
    )[:10]
    for product in query_set:
        image = None
        if product.image:
            image = request.build_absolute_uri(product.image.image.url),
        review = ProductReview.objects.filter(product=product).aggregate(Avg('rating'))['rating__avg'] or 0
        product_detail = ProductDetail.objects.filter(product=product).last()
        top_products.append(
            {"id": product.id, "name": product.name, "image": image, "rating": review, "stock": product_detail.stock,
             "product_detail_id": product_detail.id, "store_name": product.store.name, "product_slug": product.slug,
             "price": product_detail.price, "discount": product_detail.discount, "store_slug": product.store.slug,
             "featured": product.is_featured, "low_stock_threshold": product_detail.low_stock_threshold})
    return top_products


def top_monthly_categories(request):
    top_categories = []
    today_date = timezone.now()
    # month_start, month_end = get_year_start_and_end_datetime(today_date)
    # queryset = Product.objects.filter(
    #     created_on__gte=month_start, created_on__lte=month_end, status='active', store__is_active=True
    # ).order_by("-sale_count").values("category__id", "category__name", "category__image").annotate(Sum("sale_count")).order_by(
    #     "-sale_count__sum")[:100]

    date_end = get_previous_month_date(today_date, 8)
    queryset = Product.objects.filter(
        status='active', store__is_active=True
        # created_on__gte=date_end, created_on__lte=today_date, status='active', store__is_active=True
    ).order_by("-sale_count").values("category__id", "category__name", "category__image", "category__slug").annotate(
        Sum("sale_count")).order_by(
        "-sale_count__sum")[:20]
    for product in queryset:
        category = dict()
        category['id'] = product['category__id']
        category['name'] = product['category__name']
        category['slug'] = product['category__slug']
        category['total_sold'] = product['sale_count__sum']
        # category['image'] = f"{request.scheme}://{request.get_host()}/media/{product['category__image']}"
        # category['image'] = request.build_absolute_uri(product['category__image'])
        category[
            'image'] = f"{settings.AWS_S3_ENDPOINT_URL}{settings.AWS_STORAGE_BUCKET_NAME}/payarena/{product['category__image']}"
        # {{AWS_S3_ENDPOINT_URL}}/payarena/category-images/fashion_mall_1_6m9JLAJ.jpeg
        # category['image'] = request.build_absolute_uri(product.category.image.url)
        # category['image'] = product['category__image']
        top_categories.append(category)
    return top_categories


def validate_product_in_cart(customer):
    response = list()
    cart = Cart.objects.get(user=customer.user, status="open")
    cart_products = CartProduct.objects.filter(cart=cart, selected=True)
    for product in cart_products:
        product_detail = product.product_detail
        if product_detail.product.status != "active" or product_detail.product.store.is_active is False:
            response.append({"product_name": f"{product_detail.product.name}",
                             "detail": "Product is not available for delivery at the moment"})

        if product_detail.stock == 0:
            response.append({"product_name": f"{product_detail.product.name}",
                             "detail": "Product is out of stock"})

        if product.quantity > product_detail.stock:
            response.append(
                {"product_name": f"{product_detail.product.name}",
                 "detail": f"Requested quantity is more than the available in stock: {product_detail.stock}"}
            )

    return response


def get_shipping_rate(customer, address_id=None):
    response = []
    sellers_products = []

    # Efficiently get the address, prefer primary, fall back to the first address
    address = (
            Address.objects.filter(id=address_id, customer=customer).first()
            or Address.objects.filter(customer=customer, is_primary=True).first()
            or Address.objects.filter(customer=customer).first()
    )

    if not address:
        return response  # If no address, return an empty response

    # Get open cart for the customer
    cart = Cart.objects.get(user=customer.user, status="open")

    # Get products and related sellers efficiently
    cart_products = (
        CartProduct.objects.filter(cart=cart)
        .select_related('product_detail__product__store__seller')
        .distinct()
    )

    # Group products by sellers
    sellers_in_cart = {product.product_detail.product.store.seller for product in cart_products}

    for seller in sellers_in_cart:
        products_for_seller = {
            'seller': seller,
            'seller_id': seller.id,
            'products': [
                {
                    'merchant_id': cart_product.product_detail.product.store.seller.id,
                    'quantity': cart_product.quantity,
                    'weight': cart_product.product_detail.weight,
                    'price': cart_product.product_detail.price,
                    'product': cart_product.product_detail.product,
                    'detail': cart_product.product_detail.product.description,
                }
                for cart_product in cart_products
                if cart_product.product_detail.product.store.seller == seller
            ],
        }
        sellers_products.append(products_for_seller)

    # Call the shipping API
    rating = ShippingService.rating(
        sellers=sellers_products, customer=customer, customer_address=address
    )

    # Process the API response
    result = []
    for rate in rating:
        total_price = decimal.Decimal(rate.get("TotalPrice", 0))
        if total_price > 0:
            quote_list = rate.get("QuoteList", [])
            for item in quote_list:
                from store.models import Store
                if item.get("Id"):
                    store_name = Store.objects.filter(seller_id=item["Id"]).values_list('name', flat=True).first()
                    result.append({
                        "store_name": store_name,
                        "shipper": rate["ShipperName"],
                        "company_id": item["CompanyID"],
                        "shipping_fee": item["Total"],
                    })

    # Group results by store
    store_shipping_info = {}
    for item in result:
        store_name = item['store_name']
        if store_name not in store_shipping_info:
            store_shipping_info[store_name] = []

        store_shipping_info[store_name].append({
            "shipper": item['shipper'],
            "shipping_fee": item['shipping_fee'],
            "company_id": item['company_id'],
        })

    # Format the final response
    for store_name, shipping_info in store_shipping_info.items():
        cart_product_ids = [
            cart_product.id
            for cart_product in cart_products
            if cart_product.product_detail.product.store.name == store_name
        ]
        response.append({
            "store_name": store_name,
            "shipping_information": [
                {**info, "cart_product_id": cart_product_ids, "uid": str(index + 1)}
                for index, info in enumerate(shipping_info)
            ],
        })

    return response



@transaction.atomic
def order_payment(request, payment_method, delivery_amount, order, source, address, pin=None):
    from account.utils import get_wallet_info
    from django.db.models import F
    import requests
    import random

    # create Transaction
    # get order amount
    subtotal = CartProduct.objects.filter(cart__order=order, selected=True).aggregate(
        subtotal=Sum(F("price") * F("quantity"))
    )["subtotal"] or 0
    rate = 0.05
    amount = float(subtotal + delivery_amount)
    
    
    trans, created = Transaction.objects.get_or_create(
        order=order, payment_method=payment_method, amount=subtotal, source=source
    )

    
    
    merchant = MerchantTransaction.objects.get(transaction=trans)
    merchant.transaction_commission(subtotal, rate)
    customer = order.customer
    email = customer.user.email
    merchant.save()
    # redirect_url = request.build_absolute_uri(reverse('home:payment-verify'))
    # random_number = ''.join(str(random.randint(0, 9)) for _ in range(6))
    redirect_url = f"https://{request.get_host()}/payment-verify?order={order.id}"

    if payment_method == "wallet":
        
        if not pin:
            return False, "PIN is required"
        balance = 0
        # Check wallet balance
        wallet_info = get_wallet_info(customer)
        if "wallet" in wallet_info:
            bal = wallet_info["wallet"]["balance"]
            balance = decimal.Decimal(bal)
        if balance < amount:
            # return False, f"Wallet Balance {balance} cannot be less than order amount, please fund wallet"
            return False, "Insufficient wallet balance. Please fund your wallet and try again"
        
        
        # Charge wallet
        response = BillingService.charge_customer(
            payment_type="wallet", customer_id=email, narration=f"Payment for OrderID: {order.id}",
            pin=pin, amount=str(amount)
        )
        if "success" in response and response["success"] is False:
            return False, "Could not debit your wallet at the moment. Please try later, or use another payment method"
        # Update transaction status
        
        with transaction.atomic():
            trans.status = "success"
            trans.transaction_detail = f"Payment for OrderID: {order.id}"
            trans.save()

            order.payment_status = "success"
            order.save()



        update_purchase(order, payment_method, source)
        return True, "Order created"

    if payment_method == "card" or payment_method == "pay_attitude":
        headers = {
            'Content-Type': 'application/json',
            'Accept': 'application/vnd.api+json'
        }

        payload = {
            "id": "PAYARENAMALL",
            "description": f"{order} payment",
            "amount": amount,
            "fee": 0,
            "currency": "566",
            "returnUrl": redirect_url,
            "secretKey": f"{settings.UPDATED_PAYMENT_KEY}",
            "scheme": "",
            "count": 0,
            "vendorId": "",
            "ReferenceID": f"MALL{str(uuid.uuid4().int)[:6]}",
            "CustomerName": f"{order.customer.user.first_name}",
            "Email": f"mailto:{email}",
            "MerchantRefData": "Payment",
            "MerchantData": "3223238232",
            "subMerchantId": "",
            "subMerchantName": "",
            "subMerchantCity": f"{address.city}",
            "subMerchantCountryCode": "566",
            "subMerchantPostalCode": f" {address.postal_code}",
            "subMerchantStreetAddress": f"{address.get_full_address}",
            "IsJson": "true"
        }
        buyer_logger.info(json.dumps(payload))
        admin_logger.info(json.dumps(payload))
        url = f"{settings.UPDATED_PAYMENT_INITIATOR}/Aggregator"

        response = requests.post(url, json=payload, headers=headers)
        buyer_logger.info(f"url: {url}, payload: {payload}, response: {response.json()}")
        admin_logger.info(f"url: {url}, payload: {payload}, response: {response.json()}")

        if response.status_code == 200:
            buyer_logger.info("response", response)
            admin_logger.info("response", response)
            response_code = response.json()

            order_id = response_code["data"]["id"]

            return True, f"{settings.UPDATED_PAYMENT_GATEWAY}/{order_id}"

        else:
            try:
                error_response = response.json()
                buyer_logger.error(error_response)
                admin_logger.error(error_response)
            except ValueError as e:
                error_response = {
                    'error': f'Unexpected error occurred and the response is not JSON.{response.status_code} {e}'}
                buyer_logger.error(error_response)
                admin_logger.error(error_response)
            return False, error_response

        # call billing service to get payment link
        # response = BillingService.charge_customer(
        #     payment_type=payment_method, customer_id=email, narration=f"Payment for OrderID: {order.id}",
        #     pin=pin, amount=str(amount), callback_url=redirect_url
        # )
        # if "paymentUrl" in response:
        #
        #     payment_link = response["paymentUrl"]
        #     transaction_ref = response["transactionId"]
        #     status = str(response["status"]).lower()
        #
        #     trans.status = status
        #     trans.transaction_reference = transaction_ref
        #     trans.transaction_detail = f"Payment for OrderID: {order.id}"
        #     trans.save()
        #
        #     return True, payment_link
        #
        # else:
        #     return False, "An error has occurred, please try again later"


def add_order_product(order):
    cart_product = CartProduct.objects.filter(cart__order=order, selected=True)
    for product in cart_product:
        # total = product.price - product.discount
        total = product.price + (product.delivery_fee or decimal.Decimal('0.00'))

        three_days_time = get_next_date(timezone.datetime.now(), 3)
        # Create order product instance for items in cart
        order_product, _ = OrderProduct.objects.get_or_create(order=order, product_detail=product.product_detail)
        order_product.price = product.price
        order_product.quantity = product.quantity
        # order_product.discount = product.discount
        order_product.sub_total = product.price
        order_product.total = total
        order_product.delivery_date = three_days_time
        order_product.payment_on = timezone.datetime.now()
        order_product.shipper_name = product.shipper_name
        order_product.company_id = product.company_id
        order_product.delivery_fee = product.delivery_fee

        order_product.save()

        # Increase sale count
        order_product.product_detail.product.sale_count += order_product.quantity
        order_product.product_detail.product.save()
        # Reduce Item stock
        order_product.product_detail.stock -= order_product.quantity
        order_product.product_detail.save()

    # Discard the cart
    # order.cart.status = "closed" # Comment for now
    cart_product.update(status='closed')
    order.cart.save()

    # Check if there are any remaining open items in the cart
    remaining_open_items = CartProduct.objects.filter(cart__order=order, status='open').exists()

    # If no open items are left, close the cart
    if not remaining_open_items:
        order.cart.status = 'closed'
        order.cart.save()

    order_products = OrderProduct.objects.filter(order=order)

    return order_products


def check_product_stock_level(product):
    # This function is to be called when an Item is packed or reduced from the stock
    product_detail = ProductDetail.objects.get(product=product)
    if product_detail.stock <= product_detail.low_stock_threshold:
        product_detail.out_of_stock_date = timezone.datetime.now()
        product_detail.save()
        # Send email to merchant
    return True


def perform_order_cancellation(order, user):
    order_products = OrderProduct.objects.filter(order=order)
    for order_product in order_products:
        if order_product.status != "paid":
            return False, "This order has been processed, and cannot be cancelled"
    order_products.update(status="cancelled", cancelled_on=timezone.datetime.now(), cancelled_by=user)
    return True, "Order cancelled successfully"


def perform_order_pickup(order_product, address, retry):
    summary = f"Shipment Request to {address.get_full_address}"
    response = ShippingService.pickup(order_products=order_product, address=address, order_summary=summary, retry=retry)

    admin_logger.info(f"Commence Update OrderProduct for {response}")
    buyer_logger.info(f"Commence Update OrderProduct for {response}")

    admin_logger.info(f"===========================================")
    buyer_logger.info(f"===========================================")

    if "Error" in response:
        buyer_logger.error(f"Error while booking Order: {response}")
        admin_logger.error(f"Error while booking Order: {response}")
        return False, "Order cannot be placed at the moment"

    # Ensure the response contains the "Data" key
    if "Data" not in response:
        buyer_logger.error(f"Unexpected response format: {response}")
        admin_logger.error(f"Unexpected response format: {response}")
        return False, "Unexpected response format"

    # Update OrderProduct
    admin_logger.info(f"Commence processing Update OrderProduct for {response}")
    buyer_logger.info(f"Commence processing Update OrderProduct for {response}")
    for data in response["Data"]:  # Access the "Data" key
        # for data in response:
        shipper = str(data["Shipper"]).upper()
        order_no = data["OrderNo"]
        # delivery_fee = data["TotalAmount"]
        waybill = data["TrackingNo"]

        # Update the order product details
        order_product.filter(shipper_name=shipper).update(
            tracking_id=order_no,
            # delivery_fee=delivery_fee,
            waybill_no=waybill,
            status="processed",
            packed_on=datetime.datetime.now(),
            booked=True
        )

        # Handle cases where TrackingNo is missing
        if waybill is None:
            order_product.filter(shipper_name=shipper).update(booked=False)

    return True, "Pickup request was successful"


def perform_order_tracking(order_product):
    tracking_id = order_product.tracking_id
    response = ShippingService.track_order(tracking_id)
    shipper = str(order_product.shipper_name).lower()

    if "error" in response:
        return False, "An error occurred while tracking order. Please try again later"

    detail = list()
    for item in response:
        data = dict()
        if shipper == "redstar":
            if item["StatusCode"] == "00":
                order_product.status = "delivered"
            data["status"] = item["StatusDescription"]
        elif shipper == "dellyman":
            if str(item["Status"]).lower() == "completed":
                order_product.status = "delivered"
            data["status"] = item["Status"]
        else:
            ...

        detail.append(data)

    order_product.save()

    return True, detail


def encrypt_text(text: str):
    key = base64.urlsafe_b64encode(settings.SECRET_KEY.encode()[:32])
    fernet = Fernet(key)
    secure = fernet.encrypt(f"{text}".encode())
    return secure.decode()


def decrypt_text(text: str):
    key = base64.urlsafe_b64encode(settings.SECRET_KEY.encode()[:32])
    fernet = Fernet(key)
    decrypt = fernet.decrypt(text.encode())
    return decrypt.decode()


def encrypt_payarena_data(data):
    cipher = AES.new(encryption_key, AES.MODE_CBC, iv=encryption_iv)
    plain_text = bytes(data, "utf-8")
    encrypted_text = cipher.encrypt(pad(plain_text, AES.block_size))
    # Convert byte to hex
    result = encrypted_text.hex()
    return result


def decrypt_payarena_data(data):
    cipher = AES.new(encryption_key, AES.MODE_CBC, iv=encryption_iv)
    plain_text = bytes.fromhex(data)
    decrypted_text = unpad(cipher.decrypt(plain_text), AES.block_size)
    # Convert to string
    result = decrypted_text.decode("utf-8")
    return result


def update_purchase(order, payment_method, source):
    # update order
    # add_order_product(order)

    order_products = add_order_product(order)
    # Update payment method
    order_products.update(payment_method=payment_method)
    admin_logger.info(f"===========================================")
    buyer_logger.info(f"===========================================")
    admin_logger.info(f"perform_order_pickup: {order.customer}, order_products: {order_products}")
    buyer_logger.info(f"perform_order_pickup: {order.customer}, order_products: {order_products}")
    admin_logger.info(f"===========================================")
    buyer_logger.info(f"===========================================")
    # Call pickup order request
    Thread(target=perform_order_pickup, args=[order_products, order.address, False]).start()

    merchant_list = list()
    trans = Transaction.objects.filter(order=order).first()

    admin_logger.info(f"Begin for loop for order_products: {order.customer}, order_products: {order_products}")
    buyer_logger.info(f"Begin for loop for order_products: {order.customer}, order_products: {order_products}")
    for order_product in order_products:
        merchant = order_product.product_detail.product.store.seller
        if merchant not in merchant_list:
            merchant_list.append(order_product.product_detail.product.store.seller)
        # Send order placement email to shopper

        admin_logger.info(f"===========================================")
        buyer_logger.info(f"===========================================")
        admin_logger.info(f"Begin sending email to: {order.customer}, order_product: {order_product}")
        buyer_logger.info(f"Begin sending email to: {order.customer}, order_product: {order_product}")
        admin_logger.info(f"===========================================")
        buyer_logger.info(f"===========================================")
        Thread(target=shopper_order_placement_email, args=[order.customer, order.id, order_product, source]).start()
        # Send order placement email to seller
        Thread(target=merchant_order_placement_email, args=[order.customer, order, order_product]).start()
        # Send order placement email to admins

    for seller in merchant_list:
        order_prod = order_products.filter(product_detail__product__store__seller=seller)
        delivery_fee = order_prod.first().delivery_fee
        shipper_name = order_prod.first().shipper_name
        seller_price = order_prod.aggregate(Sum("sub_total"))["sub_total__sum"] or 0
        seller_total = (delivery_fee or decimal.Decimal('0.00')) + seller_price

        # Create Merchant Transaction
        merchant_trans, _ = MerchantTransaction.objects.get_or_create(order=order, merchant=seller, transaction=trans)
        merchant_trans.shipper = shipper_name
        merchant_trans.delivery_fee = merchant_trans.delivery_fee or 0.0

        merchant_trans.amount = seller_price
        merchant_trans.total = seller_total
        merchant_trans.save()

    return "Order Updated"
