# Enable required APIs
resource "google_project_service" "artifact_registry" {
  project = var.project_id
  service = "artifactregistry.googleapis.com"
  
  disable_on_destroy = false
}

resource "google_project_service" "cloud_build" {
  project = var.project_id
  service = "cloudbuild.googleapis.com"
  
  disable_on_destroy = false
}

# Artifact Registry Repository
resource "google_artifact_registry_repository" "docker_repo" {
  project       = var.project_id
  location      = var.region
  repository_id = var.repository_id
  description   = "Docker repository for Spring Boot applications"
  format        = "DOCKER"

  depends_on = [google_project_service.artifact_registry]
}

# Service Account for GitHub Actions
resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = var.service_account_id
  display_name = "GitHub Actions CI/CD Service Account"
  description  = "Service account for GitHub Actions to push Docker images to Artifact Registry"
}

# Service Account Key
resource "google_service_account_key" "github_actions_key" {
  service_account_id = google_service_account.github_actions.name
}

# IAM bindings for Service Account
resource "google_project_iam_member" "github_actions_artifact_registry" {
  project = var.project_id
  role    = "roles/artifactregistry.writer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions_storage_admin" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}