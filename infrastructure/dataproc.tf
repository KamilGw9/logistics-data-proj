resource "google_dataproc_cluster" "dev_cluster" {
  name   = "eco-logistics-dev-cluster"
  region = var.region

  cluster_config {
    # Single node cluster only for development
    
    master_config {
      num_instances = 1
      machine_type  = "e2-standard-2"
      disk_config {
        boot_disk_type    = "pd-standard"
        boot_disk_size_gb = 50
      }
    }

    worker_config {
      num_instances = 0
    }

    software_config {
      image_version = "2.1-debian11"
      
      override_properties = {
        "dataproc:dataproc.allow.zero.workers" = "true"
        "spark:spark.jars.packages"            = "io.delta:delta-core_2.12:2.4.0,com.google.cloud.spark:spark-bigquery-with-dependencies_2.12:0.34.0"
        "spark:spark.sql.extensions"           = "io.delta.sql.DeltaSparkSessionExtension"
        "spark:spark.sql.catalog.spark_catalog" = "org.apache.spark.sql.delta.catalog.DeltaCatalog"
      }
    }

    gce_cluster_config {
      service_account = google_service_account.etl_runner.email
      service_account_scopes = [
        "https://www.googleapis.com/auth/cloud-platform"
      ]
      internal_ip_only = false 
    }
  }

  depends_on = [
    google_project_iam_member.dataproc_worker,
    google_project_iam_member.storage_admin
  ]
}