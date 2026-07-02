variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "region" {
  description = "GCP region"
  type        = string
  default = "us-central1"
}

variable "zone" {
  description = "GCP zone"
  type        = string
  default = "us-central1-a"
}

variable "bucket_gcp" {
  description = "Name of bucket in GCP"
  type        = string
}