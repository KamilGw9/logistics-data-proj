# Google Cloud Storage -> data lake 
resource "google_storage_bucket" "data_lake" {
  name          = var.bucket_name
  location      = var.region
  force_destroy = true # only on dev -> tmp project

  uniform_bucket_level_access = true
}

# Creating folders in the bucket
resource "google_storage_bucket_object" "folder_bronze" {
  name    = "bronze/"
  content = " "
  bucket  = google_storage_bucket.data_lake.name
}

resource "google_storage_bucket_object" "folder_silver" {
  name    = "silver/"
  content = " "
  bucket  = google_storage_bucket.data_lake.name
}

resource "google_storage_bucket_object" "folder_gold" {
  name    = "gold/"
  content = " "
  bucket  = google_storage_bucket.data_lake.name
}

resource "google_storage_bucket_object" "folder_scripts" {
  name    = "scripts/"
  content = " "
  bucket  = google_storage_bucket.data_lake.name
}

# Pub/Sub 
resource "google_pubsub_topic" "bus_data_topic" {
  name = "bus-data-topic"
}

resource "google_pubsub_subscription" "bus_data_sub" {
  name  = "bus-data-sub"
  topic = google_pubsub_topic.bus_data_topic.name

  # quite after 7 days of inactivity
  message_retention_duration = "604800s"
}

# BigQuery 
resource "google_bigquery_dataset" "logistics_ds" {
  dataset_id  = "logistics_mart"
  friendly_name = "Logistics Data Mart"
  description = "Final data warehouse for logistics data"
  location    = var.region
}