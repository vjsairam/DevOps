module "iam" {
  source                =     "./modules/"
  bucket                =     var.bucket 
  project               =     var.project
  dataset_id            =     var.dataset_id 
  table_id              =     var.table_id
  google_storage_bucket_iam_binding_role        =     var.google_storage_bucket_iam_binding_role 
  google_storage_bucket_iam_binding_users       =     var.google_storage_bucket_iam_binding_users
  google_bigquery_table_iam_binding_role        =     var.google_bigquery_table_iam_binding_role
  google_bigquery_table_iam_binding_users       =     var.google_bigquery_table_iam_binding_users
}
