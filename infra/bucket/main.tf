resource "google_storage_bucket" "bucket" {
  name          = var.bucket_gcp
  project       = var.project_id
  location      = var.region
  storage_class = "STANDARD"

  # Fuerza la destrucción del bucket aunque contenga objetos al ejecutar tofu destroy
  force_destroy = true

  # Regla de ciclo de vida: elimina objetos automáticamente a los 7 días
  lifecycle_rule {
    condition {
      age = 7
    }
    action {
      type = "Delete"
    }
  }
  versioning {
    enabled = true
  }
}