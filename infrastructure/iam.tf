# Service account for ETL
resource "google_service_account" "etl_runner" {
  account_id   = "etl-runner-sa"
  display_name = "ETL Runner Service Account"
}

# Assigning permissions
resource "google_project_iam_member" "dataproc_worker" {
  project = var.project_id
  role    = "roles/dataproc.worker"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

resource "google_project_iam_member" "pubsub_editor" {
  project = var.project_id
  role    = "roles/pubsub.editor"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

resource "google_project_iam_member" "bigquery_editor" {
  project = var.project_id
  role    = "roles/bigquery.dataEditor"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

# Metadata permissions
resource "google_project_iam_member" "service_account_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

# Compute Engine permissions for DataProc
resource "google_project_iam_member" "compute_instance_admin" {
  project = var.project_id
  role    = "roles/compute.instanceAdmin.v1"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}

resource "google_project_iam_member" "compute_network_user" {
  project = var.project_id
  role    = "roles/compute.networkUser"
  member  = "serviceAccount:${google_service_account.etl_runner.email}"
}
