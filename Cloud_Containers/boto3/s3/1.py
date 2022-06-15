import boto3
import logging 
from botocore.exceptions import ClientError
from botocore.client import Config

client = boto3.client("s3", region_name="us-east-1")

response = client.list_buckets()

print("Listing s3 buckets")

for bucket in response['Buckets']:
    print(f"--{bucket['Name']}")