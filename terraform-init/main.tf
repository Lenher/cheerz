# Bootstrap configuration - creates GCS bucket for Terraform state
# This should be run first to set up remote state backend

terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  
  # Will automatically use GOOGLE_APPLICATION_CREDENTIALS env var
}

# Enable required APIs for Terraform management
resource "google_project_service" "cloudresourcemanager" {
  project = var.project_id
  service = "cloudresourcemanager.googleapis.com"
  
  disable_on_destroy = false
}

resource "google_project_service" "serviceusage" {
  project = var.project_id
  service = "serviceusage.googleapis.com"
  
  disable_on_destroy = false
}

resource "google_project_service" "iam" {
  project = var.project_id
  service = "iam.googleapis.com"
  
  disable_on_destroy = false
}

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

# Service Account for GitHub Actions (created here with full permissions)
resource "google_service_account" "github_actions" {
  project      = var.project_id
  account_id   = "github-actions-cicd"
  display_name = "GitHub Actions CI/CD Service Account"
  description  = "Service account for GitHub Actions to manage infrastructure and push Docker images"
  
  depends_on = [google_project_service.iam]
}

# Service Account Key
resource "google_service_account_key" "github_actions_key" {
  service_account_id = google_service_account.github_actions.name
}

# IAM bindings for the service account
resource "google_project_iam_member" "github_actions_editor" {
  project = var.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
  
  depends_on = [google_service_account.github_actions]
}

resource "google_project_iam_member" "github_actions_serviceusage_admin" {
  project = var.project_id
  role    = "roles/serviceusage.serviceUsageAdmin"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
  
  depends_on = [google_service_account.github_actions]
}

# GCS bucket for storing Terraform state
resource "google_storage_bucket" "terraform_state" {
  name          = "${var.project_id}-terraform-state"
  location      = var.region
  storage_class = "STANDARD"
  
  # Prevent accidental deletion
  lifecycle {
    prevent_destroy = true
  }
  
  # Enable versioning for state file history
  versioning {
    enabled = true
  }
  
  # No encryption block = use Google-managed encryption by default
  
  # Uniform bucket-level access
  uniform_bucket_level_access = true
}

# Outputs
output "state_bucket_name" {
  description = "Name of the GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}

output "service_account_email" {
  description = "Email of the GitHub Actions service account"
  value       = google_service_account.github_actions.email
}

output "service_account_key" {
  description = "Private key for the GitHub Actions service account (base64 encoded)"
  value       = google_service_account_key.github_actions_key.private_key
  sensitive   = true
}