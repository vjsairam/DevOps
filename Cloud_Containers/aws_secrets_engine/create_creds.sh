#!/bin/sh

#Enable the AWS secrets engine
vault secrets enable --path=aws_demo aws

#Configure the credentials
vault write aws/config/root \
    lease_id_template="myorg-{{.RoleName}}-{{unix_time}}-{{random 8}}" \
    access_key=$AWS_ACCESS_KEY_ID \
    secret_key=$AWS_SECRET_ACCESS_KEY \
    region=us-east-1

#Configure a Vault role
vault write aws/roles/$1 \
    credential_type=iam_user \
    policy_document=$(<"$2")

#Generate a new credential
vault read aws/creds/$1
