terraform {
  required_providers {
    google = {
      source = "hashicorp/google"
      version = ">= 4.0"
    }
  }
   backend "gcs" {
    bucket = "bucket-gamarillo"
    prefix = "terraform/state"
  }

}

provider "google" {
  project = var.project_id #"proyectosdypp2026"
  region  = "us-central1"
}
