resource "google_storage_bucket_iam_binding" "binding" {
    /*
    google_storage_bucket_iam_binding: Authoritative for a given role. Updates the IAM policy to grant a role to a list of members. 
    Other roles within the IAM policy for the bucket are preserved.
    */
  bucket      =     var.bucket 
  role        =     var.google_storage_bucket_iam_binding_role 
  members     =     var.google_storage_bucket_iam_binding_users
  // members     = [
  //   "user:test_user@gmail.com",
  // ]
}

resource "google_bigquery_table_iam_binding" "binding" {
    /*
    google_bigquery_table_iam_policy: Authoritative. Sets the IAM policy for the table and replaces any existing policy already attached.
    */
  project     =     var.project
  dataset_id  =     var.dataset_id 
  table_id    =     var.table_id
  role        =     var.google_bigquery_table_iam_binding_role
  members     =     var.google_bigquery_table_iam_binding_users
  // members = [
  //   "user:test_user@gmail.com", 
  // ]
}


