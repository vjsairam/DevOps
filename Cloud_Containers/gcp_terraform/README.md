1. Update the vars in providers.tf as with the gcp project details. 

2. Update the terraform.tfvars with the bucket and bigquery details. Add the bucket and user details in the variables. 

3. Once the vars are set, run the below commands one by one 
terraform init
terraform plan 
terrafom apply 

4. google_storage_bucket_iam_binding resource is used for assigning the IAM permissions to the specified bucket. Ref - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket_iam

5. google_bigquery_table_iam_binding resource is used for assigning the IAM permissions to the specified bigquery table. Ref - https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table_iam

