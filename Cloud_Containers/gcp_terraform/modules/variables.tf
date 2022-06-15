variable "bucket" {
  type        = string
  description = "The bucket name to provide the IAM permissions."
}

variable "google_storage_bucket_iam_binding_role" {
  type        = string
  description = "The role name to be provided for accessing the bucket."
}

variable "project" {
  type        = string
  description = "The project name of the gcp project."
}

variable "dataset_id" {
  type        = string
  description = "The dataset id of the bigquery project."
}

variable "table_id" {
  type        = string
  description = "The table id corresponding to the dataset id."
}

variable "google_bigquery_table_iam_binding_role" {
  type        = string
  description = "The role name to be provided for accessing the bigquery."
}

variable "google_storage_bucket_iam_binding_users" {
  default     = []
  type        = list(string)
  description = "The user list for accessing the buckets."
}

variable "google_bigquery_table_iam_binding_users" {
  default     = []
  type        = list(string)
  description = "The user list for accessing the bigquery."
}