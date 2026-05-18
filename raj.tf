# Configure the Google Cloud provider
provider "google" {
  credentials = file("D:/tf_gke/tf_gke/crucial-decoder-407103-d1a897cac1f0.json")
  project     = "crucial-decoder-407103"
  region      = "us-central1"
}
#