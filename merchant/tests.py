from django.test import TestCase
#
# Create your tests here.
# import base64
# import os
# import requests
# from io import BytesIO
# from PIL import Image
#
#
# def optimize_image(image_file_path, optimization_service_url):
#     try:
#         # Step 1: Open the image file
#         with open(image_file_path, 'rb') as image_file:
#             image = Image.open(image_file)
#             maxWidth, maxHeight = image.size  # Get image dimensions
#
#             # Step 2: Convert image to Base64 format
#             buffered = BytesIO()
#             image.save(buffered, format="JPEG")
#             encoded_base64 = base64.b64encode(buffered.getvalue()).decode('utf-8')
#
#             # Step 3: Prepare the payload for the optimization service
#             payload = {
#                 "maxWidth": maxWidth,
#                 "maxHeight": maxHeight,
#                 "maxSizeKB": os.path.getsize(image_file_path) / 1024,  # Size in KB
#                 "encodedBase64": encoded_base64
#             }
#
#             print("Sending request to optimization service...")
#             print("Sending request to optimization service with payload:", payload)
#
#             # Send the payload to the optimization service
#             response = requests.post(optimization_service_url, json=payload)
#             print("Response from optimization service:", response.json())  # Log the response
#
#             if response.status_code != 200:
#                 print(f"Failed to optimize image. Status code: {response.status_code}, Response: {response.text}")
#                 return
#
#             # Step 4: Handle the optimized image from the service
#             optimized_base64 = response.json().get("optimizedImage")
#             if optimized_base64:
#                 # Decode the optimized image and save it
#                 optimized_image_content = base64.b64decode(optimized_base64)
#                 optimized_image_filename = "optimized_image.jpeg"
#
#                 # Save the optimized image locally
#                 with open(optimized_image_filename, 'wb') as optimized_file:
#                     optimized_file.write(optimized_image_content)
#
#                 print(f"Image uploaded and optimized successfully. Saved as: {optimized_image_filename}")
#             else:
#                 print("No optimized image returned from the service.")
#
#     except requests.exceptions.RequestException as e:
#         print(f"Error from optimization service: {str(e)}")
#     except Exception as e:
#         print(f"Error processing image: {str(e)}")
#
#
# if __name__ == "__main__":
#     # Path to the local image file (.jpeg)
#     image_file_path = r"C:\Users\HP\TM30\backend\81fPKd-2AYL._AC_SL1500_.jpg"  # Updated the file path
#     optimization_service_url = "http://89.38.135.41:8056/api/v1/fix-image"  # Replace with your actual optimization service URL
#
#     # Check if the file exists
#     if os.path.exists(image_file_path):
#         optimize_image(image_file_path, optimization_service_url)
#     else:
#         print(f"Image file does not exist: {image_file_path}")
