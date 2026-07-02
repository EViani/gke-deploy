resource "google_project_service" "container" {
  service            = "container.googleapis.com"
  disable_on_destroy = false
}

resource "google_project_service" "artifact_registry" {
  service            = "artifactregistry.googleapis.com"
  disable_on_destroy = false
}

# ── Artifact Registry repository ──────────────────────────────────────────────
# Where the Docker images are stored inside GCP.
resource "google_artifact_registry_repository" "k8s_apps" {
  location      = "us-central1"
  repository_id = "k8s-apps"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}


resource "google_container_cluster" "primary" {
  name     = "blockchain-cluster"
  location = "us-central1-a"

  remove_default_node_pool = true
  initial_node_count       = 1
  deletion_protection      = false
  depends_on = [google_project_service.container]
}


resource "google_container_node_pool" "app_nodes" {
  name       = "app-pool"
  cluster    = google_container_cluster.primary.name
  location   = "us-central1-a"
  node_count = 2

  node_config {
    machine_type = "e2-medium"
    disk_type    = "pd-standard"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
      "https://www.googleapis.com/auth/devstorage.read_only",
    ]
  
  }
}
