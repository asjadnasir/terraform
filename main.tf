resource "random_string" "upper" {
  length  = 8
  upper   = false
  lower   = true
  number  = false
  special = false
}
resource "google_compute_instance" "default" {
  name         = "terraform-test-vm"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  // Local SSD disk
  scratch_disk {
    interface = "SCSI"
  }

  network_interface {
    network = "default"

    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = "echo hi > /test.txt"

  service_account {
    scopes = ["userinfo-email", "compute-ro", "storage-ro"]
  }
}
resource "google_storage_bucket" "default" {
  name     = "bucket-${random_string.upper.result}"
  storage_class = "MULTI_REGIONAL"
}

