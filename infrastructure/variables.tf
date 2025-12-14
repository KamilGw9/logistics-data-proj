variable "project_id" {
  description = "GCP project ID"
  type        = string
  default     = "warsaw-data"
}

variable "region" {
  description = "Region GCP"
  type        = string
  default     = "europe-central2"
}

variable "bucket_name" {
  description = "Unique GCS bucket name"
  type        = string
  default     = "logistics-lake"
}