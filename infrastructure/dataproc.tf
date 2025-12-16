resource "google_dataproc_cluster" "dev_cluster" {
  name   = "${var.project_id}-${var.environment}-cluster"
  region = var.region

  cluster_config {
    # Single node cluster only for development
    
    master_config {
      num_instances = 1
      machine_type  = var.dataproc_master_machine_type
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
      
      subnetwork = google_compute_subnetwork.dataproc_subnet.self_link
      
      internal_ip_only = true 

      metadata = {
        "block-project-ssh-keys" = "true"
      }

      shielded_instance_config {
        enable_vtpm = true
        enable_integrity_monitoring = true
        enable_secure_boot = true
      }
    }

    encryption_config {
      kms_key_name = google_kms_crpyto_key.storage_key.id
    }

       lifecycle_config {
      idle_delete_ttl = var.environment == "dev" ? "3600s" : null
    }
  }

  depends_on = [
    google_project_iam_member.dataproc_worker,
    google_project_iam_member.storage_object_creator,
    google_compute_subnetwork.dataproc_subnet,
    google_compute_router_nat.nat,
    google_kms_crypto_key_iam_member.etl_storage_key_user
  ]
}