resource "google_service_account" "default" {
  account_id   = var.service_account_id
  display_name = "Service Account para Pipeline CI/CD"
}

# GKE: Permisos para crear, modificar y eliminar clústeres
resource "google_project_iam_member" "gke_admin" {
  project = var.project_id
  role    = "roles/container.clusterAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# IAM: Permite a la SA asignar e interactuar con las cuentas de servicio de los nodos
resource "google_project_iam_member" "sa_user" {
  project = var.project_id
  role    = "roles/iam.serviceAccountUser"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Artifact Registry: Permite subir imágenes Docker
resource "google_project_iam_member" "artifactregistry_writer" {
  project = var.project_id
  role    = "roles/artifactregistry.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Cloud Storage: Administración de buckets y objetos
resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

# Permiso para que los nodos de GKE lean de Artifact Registry
resource "google_project_iam_member" "nodes_artifact_reader" {
  project = var.project_id
  role    = "roles/artifactregistry.reader"
  member  = "serviceAccount:${google_service_account.default.email}"
}


resource "google_project_iam_member" "sevice_usage" {
   project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "compute_admin" {
   project = var.project_id
  role    = "roles/compute.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "container_admin" {
   project = var.project_id
  role    = "roles/container.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}
