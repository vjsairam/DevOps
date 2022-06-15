import boto3
import json
import csv
import sys
from pathlib import Path

session = boto3.Session(profile_name='default')
AWS_REGION = "us-east-1"
access_analyzer = session.client('accessanalyzer', region_name=AWS_REGION)
iam = session.client('iam', region_name=AWS_REGION)
organization = session.client('organizations', region_name=AWS_REGION)
POLICIES_PAGINATION = 100
FIELDS_NAMES = ["File Path", "JSON Error", "No of Error", "No of Security Warning", "No of Warning", "No of Suggestion", "Findings", "Document"]
FAILURE_TYPES = ["JSON_ERROR", "ERROR", "SECURITY_WARNING"] # 'ERROR'|'SECURITY_WARNING'|'SUGGESTION'|'WARNING' # 'JSON_ERROR' -> Error while reading json from file
FOLDER_PATH = "./sample" #create a sample folder in the same path of script folder (or) just specify the full path of any folder


def get_policies_from_files(directory_path):
	policies = {}
	paths = Path(directory_path).glob('**/*.json')
	for path in paths:
		file_path = str(path)
		policies[file_path] = {}
		print(file_path)
		with open(file_path) as json_file:
			try:
				policies[file_path]["Document"] = json.load(json_file)
				policies[file_path]["JSON_ERROR"] = None
			except Exception as e:
				json_err = str(e)
				policies[file_path]["JSON_ERROR"] = json_err
				continue
	return policies


def set_validations(policies):
	for key in policies:
		if policies[key]["JSON_ERROR"] == None:
			policies[key]['Findings'] = get_validation(policies[key])


def get_validation(policy):
	validation_response = access_analyzer.validate_policy( policyType='IDENTITY_POLICY',policyDocument=json.dumps(policy['Document']))
	return validation_response["findings"]

def get_csv_row_data(path, policy):
	if policy["JSON_ERROR"] == None:
		return [
					path,
					"",
					get_count(policy["Findings"], "ERROR"),
					get_count(policy["Findings"], "SECURITY_WARNING"),
					get_count(policy["Findings"], "WARNING"),
					get_count(policy["Findings"], "SUGGESTION"),
					json.dumps(policy['Findings']),
					json.dumps(policy['Document'])
				]
	else:
		return [
					path,
					policy["JSON_ERROR"],
					"NA", "NA", "NA", "NA", "NA", "NA"
				]

def get_count(findings, type):
	return len(list(filter(lambda finding: finding['findingType'] == type, findings)))


def write_to_csv_calculate_count(policies):
	validation_count = { "JSON_ERROR": 0, "ERROR": 0, "SECURITY_WARNING": 0, "WARNING": 0,  "SUGGESTION": 0 }
	output_file = open('output.csv', 'w')
	csv_writer = csv.writer(output_file)
	csv_writer.writerow(FIELDS_NAMES)

	for arn, v in policies.items():
		row_data = get_csv_row_data(arn, v)
		if row_data[1] != "":
			validation_count["JSON_ERROR"] += 1
		else:	
			validation_count["ERROR"] += row_data[2]
			validation_count["SECURITY_WARNING"] += row_data[3]
			validation_count["WARNING"] += row_data[4]
			validation_count["SUGGESTION"] += row_data[5]
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
  policies = get_policies_from_files(FOLDER_PATH)
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