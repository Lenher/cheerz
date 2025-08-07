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
  
  # Use credentials from environment variable or file
  credentials = var.credentials_file != "" ? file(var.credentials_file) : null
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

# Output the bucket name for use in main terraform config
output "state_bucket_name" {
  description = "Name of the GCS bucket for Terraform state"
  value       = google_storage_bucket.terraform_state.name
}