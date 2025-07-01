import requests
import json

from django.conf import settings

# from home.utils import log_request

import logging

admin_logger = logging.getLogger('admin')
buyer_logger = logging.getLogger('buyer')


def send_email(content, email, subject):
    admin_logger.info(f"===========================================")
    buyer_logger.info(f"===========================================")
    admin_logger.info(f"Begin sending email to: {email}")
    buyer_logger.info(f"Begin sending email to: {email}")
    admin_logger.info(f"===========================================")
    buyer_logger.info(f"===========================================")
    payload = json.dumps({"Message": content, "address": email, "Subject": subject})
    response = requests.request("POST", settings.EMAIL_URL, headers={'Content-Type': 'application/json'}, data=payload)
    # log_request(f"Email sent to: {email}")
    admin_logger.info(f"Sending email to: {email}, Response: {response.json()}")
    buyer_logger.info(f"Sending email to: {email}, Response: {response.json()}")
    return response.text
