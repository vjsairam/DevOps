import json
from sys import prefix
import boto3
from datetime import date, datetime
from datetime import timedelta
from botocore.exceptions import ClientError
list_unused_roles = set()
date_now = datetime.now() 
iam_client = boto3.client('iam')
sd_client = boto3.client('servicediscovery')
max_idle_days = 365
max_items = 1000

def generate_report(roles):
    job_list={}
    Role_list = roles['Roles']
    for role in Role_list:
        res=iam_client.generate_service_last_accessed_details(
            Arn=role["Arn"]
            )
        job_list[role["RoleName"]]=res["JobId"]
    #print("jobs created")
    #print(job_list)
    return get_report(job_list)

def get_report(job_list):
    for role_name in job_list.keys():
        response = iam_client.get_service_last_accessed_details(
            JobId=job_list[role_name])
        all_more_then_max=True
        recent_date=datetime.min.replace(tzinfo=None)
        for sla in response["ServicesLastAccessed"]:
            if "LastAuthenticated" in sla and (date_now - sla["LastAuthenticated"].replace(tzinfo=None)).days<max_idle_days:
                all_more_then_max=False
            elif "LastAuthenticated" in sla :
                recent_date=sla["LastAuthenticated"].replace(tzinfo=None) if sla["LastAuthenticated"].replace(tzinfo=None) > recent_date else recent_date 
                
        if all_more_then_max:
            list_unused_roles.add(role_name)
            # the date 0001-01-01 00:00:00 represent the role was never used and did not have LastAuthenticated data
            print(f"{role_name} --- {recent_date}")
       
# get Role 
def getRoles():
        try:
            # we need to pull the list and then iterate through the list to get details of lastused date. https://boto3.amazonaws.com/v1/documentation/api/latest/reference/services/iam.html#IAM.Client.list_roles
            roles = iam_client.list_roles(
                MaxItems=max_items
            )
            generate_report(roles)
        except ClientError as error:
            print('An error occurred while fetching roles list.', error)
        if roles['IsTruncated']:
            while roles['IsTruncated']:
                marker = roles['Marker']
                try:
                    roles = iam_client.list_roles(
                        Marker=marker,
                        MaxItems=max_items
                    )
                    generate_report(roles)
                except ClientError as error:
                        print('An error occurred while fetching roles list.', error)
        return list_unused_roles

getRoles()