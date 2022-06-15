import boto3
import json
import csv
import sys

session = boto3.Session(profile_name='default')
AWS_REGION = "us-east-1"
access_analyzer = session.client('accessanalyzer', region_name=AWS_REGION)
iam = session.client('iam', region_name=AWS_REGION)
organization = session.client('organizations', region_name=AWS_REGION)
POLICIES_PAGINATION = 100
FIELDS_NAMES = ["ARN", "Policy Id", "Policy Name", "Version", "No of Error", "No of Security Warning", "No of Warning", "No of Suggestion", "Findings", "Document"]
FAILURE_TYPES = ["ERROR"] # 'ERROR'|'SECURITY_WARNING'|'SUGGESTION'|'WARNING'


def get_policies():
	policies = {}
	paginator = iam.get_paginator('list_policies')
	for page in paginator.paginate(Scope='Local', PaginationConfig={'PageSize': POLICIES_PAGINATION}):
		for policy in page['Policies']:
			key = policy['Arn']
			policies[key] = get_policy_details(policy)

	return policies

def get_policy_details(policy):
	return { 
				"PolicyId": policy['PolicyId'],
				"PolicyName": policy['PolicyName'],
				"Version": policy['DefaultVersionId'],
				"Document": get_policy_document(policy)
			}

def get_policy_document(policy):
	policy_reponse = iam.get_policy_version(PolicyArn=policy['Arn'],VersionId=policy['DefaultVersionId'])	
	return policy_reponse['PolicyVersion']['Document']


def set_validations(policies):
	for key in policies:
		policies[key]['Findings'] = get_validation(policies[key])


def get_validation(policy):
	validation_response = access_analyzer.validate_policy( policyType='IDENTITY_POLICY',policyDocument=json.dumps(policy['Document']))
	return validation_response["findings"]

def get_csv_row_data(arn, policy):
	return [
				arn,
				policy["PolicyId"],
				policy["PolicyName"],
				policy["Version"],
				get_count(policy["Findings"], "ERROR"),
				get_count(policy["Findings"], "SECURITY_WARNING"),
				get_count(policy["Findings"], "WARNING"),
				get_count(policy["Findings"], "SUGGESTION"),
				json.dumps(policy['Findings']),
				json.dumps(policy['Document'])
			]

def get_count(findings, type):
	return len(list(filter(lambda finding: finding['findingType'] == type, findings)))


def write_to_csv_calculate_count(policies):
	validation_count = { "ERROR": 0, "SECURITY_WARNING": 0, "WARNING": 0,  "SUGGESTION": 0 }
	output_file = open('output.csv', 'w')
	csv_writer = csv.writer(output_file)
	csv_writer.writerow(FIELDS_NAMES)

	for arn, v in policies.items():
		row_data = get_csv_row_data(arn, v)
		validation_count["ERROR"] += row_data[4]
		validation_count["SECURITY_WARNING"] += row_data[5]
		validation_count["WARNING"] += row_data[6]
		validation_count["SUGGESTION"] += row_data[7]
		csv_writer.writerow(row_data)
	output_file.close()
	return validation_count

def is_success(validation_report):
	for current_type in FAILURE_TYPES:
		if validation_report[current_type] > 0:
			return False
	return True

def start_validation():
  print("Started Processing")
  print("Getting Policies")
  policies = get_policies()
  print("Getting Validations")
  set_validations(policies)
  print("Policy Data:")
  print(policies)
  validation_report = write_to_csv_calculate_count(policies)
  print("Validation Report")
  print(validation_report)
  if is_success(validation_report):
  	print("Success")
  	sys.exit(0)
  else:
  	print("Failure")
  	sys.exit(-1)

start_validation()