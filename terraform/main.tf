# Artifact Registry Repository
# Note: APIs and Service Account are managed by terraform-init
resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for Spring Boot applications"
  format        = "DOCKER"
}

# Data source to reference the service account created by terraform-init
data "google_service_account" "github_actions" {
  account_id = var.service_account_id
  project    = var.project_id
}

# Additional IAM bindings for Service Account (if needed)
resource "google_project_iam_member" "github_actions_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${data.google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${data.google_service_account.github_actions.email}"
}