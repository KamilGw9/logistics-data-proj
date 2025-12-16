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

variable "environment" {
  description = "Envaironment: dev, prod"
  type        = string
  default     = "dev"
}


variable "bucket_name" {
  description = "Unique GCS bucket name"
  type        = string
  default     = "logistics-lake"
}

variable "dataproc_master_machine_type" {
  description = "Dataproc master node machine type"
  type        = string
  default     = "e2-standard-2"
  
}

variable "dataproc_worker_machine_type" {
  description = "Dataproc worker node machine type"
  type        = string
  default     = "e2-standard-2"
  
}

variable "dataproc_num_workers" {
  description = "Number of Dataproc worker nodes"
  type        = number
  default     = 0
}
