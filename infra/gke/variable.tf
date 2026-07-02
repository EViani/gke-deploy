variable "project_id" {
  type        = string
  description = "El ID del proyecto de GCP provisto por GitHub Actions"
}

variable "bucket_gcp" {
  description = "Name of bucket in GCP"
  type        = string
}