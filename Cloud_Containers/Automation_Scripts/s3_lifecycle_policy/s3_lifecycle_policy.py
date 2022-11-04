import boto3
import json

client = boto3.client('s3')

lifecycle_configuration = {
    "Rules": [
        {
            'Expiration': {
                'ExpiredObjectDeleteMarker': True
            },
            "ID": "LC_Rule_v1",
            "Filter": {},
            "Status": "Enabled",
            "Transitions": [
                {
                    "Days": 60,
                    "StorageClass": "INTELLIGENT_TIERING"
                },
                {
                    "Days": 180,
                    "StorageClass": "GLACIER_IR"
                },
                {
                    "Days": 365,
                    "StorageClass": "DEEP_ARCHIVE"
                }
            ],
            "NoncurrentVersionTransitions": [
                {
                    "NoncurrentDays": 60,
                    "StorageClass": "ONEZONE_IA"
                },
                {
                    "NoncurrentDays": 120,
                    "StorageClass": "DEEP_ARCHIVE"
                }
            ],
            "AbortIncompleteMultipartUpload": {
                "DaysAfterInitiation": 90
            }
        }
    ]
}

def get_bucket_lifecycle_configuration(bucket_name):
    response = client.get_bucket_lifecycle_configuration(
    Bucket=bucket_name
    )
    #print(response)
    return response

def put_bucket_lifecycle_configuration(bucket_name,lifecycle_configuration):
    return client.put_bucket_lifecycle_configuration(
    Bucket=bucket_name,
    LifecycleConfiguration=lifecycle_configuration
    )

def list_all_bucket():
    return client.list_buckets()

def put_lifecycle_configuration_to_all_buckets(lifecycle_configuration):
    buckets=list_all_bucket()
    # for bucket in buckets['Buckets']:
    #     put_bucket_lifecycle_configuration(bucket["Name"],lifecycle_configuration)

#print(put_lifecycle_configuration_to_all_buckets(lifecycle_configuration))
print(list_all_bucket())