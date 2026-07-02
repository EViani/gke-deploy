resource "google_service_account" "default" {
  account_id   = var.service_account_id
  display_name = "Service Account"
}

resource "google_project_iam_member" "wif_pool_admin" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityPoolAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}


resource "google_project_iam_member" "account_admin" {
  project = var.project_id
  role    = "roles/iam.serviceAccountAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "artifactregistry" {
   project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "node_storage_admin" {
  project = var.project_id
  role    = "roles/storage.objectAdmin"
  member  = "serviceAccount:${google_service_account.default.email}"
}

resource "google_project_iam_member" "storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.default.email}"
}