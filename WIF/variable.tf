variable "project_id" {
  description = "GCP project ID"
  type        = string
}

variable "service_account_id" {
  description = "Name of service account"
  type = string
  default = "terraform-deployer"
}