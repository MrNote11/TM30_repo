import json
import requests
from django.conf import settings

from ecommerce.utils import decrypt_text
# from home.utils import log_request

import logging

buyer_logger = logging.getLogger('buyer')
shipping_logger = logging.getLogger('shipping')
merchant_logger = logging.getLogger('merchant')
admin_logger = logging.getLogger('admin')
payment_logger = logging.getLogger('payment')

base_url = settings.PAYARENA_ACCOUNT_BASE_URL
pgw_url = settings.PAYMENT_GATEWAY_URL


class PayArenaServices:
    @classmethod
    def get_auth_header(cls, profile):
        token = decrypt_text(profile.pay_auth)
        headers = {
            'Authorization': f'Bearer {token}',
            'Content-Type': 'application/json'
        }
        return headers

    @classmethod
    def register(cls, **kwargs):
        url = f"{base_url}/home/register"

        payload = dict()
        payload["Email"] = kwargs.get("email")
        payload["UserName"] = kwargs.get("username")
        payload["PhoneNumber"] = kwargs.get("phone_no")
        payload["FirstName"] = kwargs.get("first_name")
        payload["Surname"] = kwargs.get("surname")

        payload["Password"] = kwargs.get("password")
        payload["ConfirmPassword"] = kwargs.get("password_confirm")

        # payload["BirthDate"] = kwargs.get("date_of_birth")
        # payload["Gender"] = kwargs.get("gender")

        payload = json.dumps(payload)
        response = requests.request("POST", url, headers={'Content-Type': 'application/json'}, data=payload, verify=False).json()

        admin_logger.info(f"url: {url} payload: {payload} response: {response}")
        return response

    @classmethod
    def login(cls, email, password):
        url = f"{base_url}/account/login"
        form_data = {
            'username': email,
            'password': password,
        }

        # Make the POST request with form data
        response = requests.post(url, data=form_data, verify=False)
        admin_logger.info(f"url: {url}, payload: {form_data}, response: {response.text}")

        return response.json()

    @classmethod
    def forget_password(cls, email):
        url = f"{base_url}/account/forgetpassword"
        data = {
            "EmailAddress": email
        }
        payload = json.dumps(data)
        response = requests.request("POST", url, headers={'Content-Type': 'application/json'}, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, payload: {payload}, response: {response}")
        return response

    @classmethod
    def reset_password(cls, email, pin, password):
        url = f"{base_url}/account/resetpassword"
        payload = json.dumps({
            "EmailAddress": email,
            "OTP": pin,
            "Password": password
        })

        response = requests.request("POST", url, headers={'Content-Type': 'application/json'}, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, payload: {payload}, response: {response}")
        return response

    @classmethod
    def change_password(cls, profile, old_password, new_password):
        url = f"{base_url}/account/changepassword"
        header = cls.get_auth_header(profile)
        payload = json.dumps({
            "OldPassword": f"{old_password}",
            "NewPassword": f"{new_password}"
        })
        response = requests.request("POST", url, headers=header, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, headers: {header}, payload: {payload}, response: {response}")
        return response

    @classmethod
    def get_wallet_info(cls, profile):
        header = cls.get_auth_header(profile)
        url = f"{base_url}/mobile/balance"
        response = requests.request("GET", url, headers=header, verify=False)
        admin_logger.info(f"url: {url}, headers: {header}, response: {response.text}")
        return response.json()

    @classmethod
    def validate_number(cls, profile):
        header = cls.get_auth_header(profile)
        url = f"{base_url}/mobile/validate-phone-number"
        response = requests.request("GET", url, headers=header, verify=False).json()
        admin_logger.info(f"url: {url}, headers: {header}, response: {response}")
        return response

    @classmethod
    def create_wallet(cls, profile, wallet_pin, otp, ott):
        header = cls.get_auth_header(profile)
        url = f"{base_url}/mobile/create-wallet"
        payload = json.dumps({
            "Pin": wallet_pin,
            "AuthCode": otp,
            "Token": ott
        })
        response = requests.request("POST", url, headers=header, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, headers: {header}, payload: {payload}, response: {response}")
        return response

    @classmethod
    def fund_wallet(cls, profile, amount, payment_info):
        header = cls.get_auth_header(profile)
        url = f"{base_url}/mobile/mall-credit-wallet"
        payload = json.dumps({"Amount": amount, "Fee": 100, "PaymentInformation": payment_info})
        response = requests.request("POST", url, headers=header, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, headers: {header}, payload: {payload}, response: {response}")
        return response

    @classmethod
    def get_payment_status(cls, reference):
        url = f"{pgw_url}/status/{reference}"
        response = requests.request("GET", url, verify=False)
        admin_logger.info(f"url: {url}, response: {response}")
        return response.json()

    @classmethod
    def name_enquiry_from_bank(cls, profile, bank_code, account_number):
        url = f"{base_url}/transfer/name-enquiry"
        header = cls.get_auth_header(profile)
        payload = json.dumps({
            "BankCode": f"800",
            "AccountNumber": f"{account_number}"
        })
        response = requests.request("POST", url, headers=header, data=payload, verify=False).json()
        admin_logger.info(f"url: {url}, headers: {header}, payload: {payload}, response: {response}")
        return response
