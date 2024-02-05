# Configure the Google Cloud provider
provider "google" {
  credentials = file("/gke.json")
  project     = "sunny-lore-381821"
  region      = "us-central1"
}
#
# Create a VPC network
resource "google_compute_network" "my_network" {
  name                    = "my-network"
  auto_create_subnetworks = false
}

# Create a subnet within the network
resource "google_compute_subnetwork" "my_subnet" {
  name          = "my-subnet"
  network       = google_compute_network.my_network.self_link
  ip_cidr_range = "10.0.0.0/24"
}

# Create a new virtual machine instance
resource "google_compute_instance" "Ubuntu" {
  name         = "my-instance"
  machine_type = "n1-standard-1"
  zone         = "us-central1-a"

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-10"
    }
  }

  network_interface {
    network       = google_compute_network.my_network.self_link
    subnetwork    = google_compute_subnetwork.my_subnet.self_link
    access_config {
      # Use ephemeral IP address
    }
  }

  # Add SSH key for remote access
  metadata = {
    ssh-keys = "your-username:${file("~/.ssh/id_rsa.pub")}"
  }

  # Add startup script
  metadata_startup_script = "#!/bin/bash\n\nsudo apt-get update && sudo apt-get install -y nginx"
}
# Create a firewall rule to allow incoming traffic on port 80
resource "google_compute_firewall" "http_firewall" {
  name        = "allow-http"
  network     = google_compute_network.my_network.self_link
  description = "Allow HTTP traffic"
allow {
    protocol = "tcp"
    ports    = ["443"]
  }
  source_ranges = ["0.0.0.0/0"]
}
