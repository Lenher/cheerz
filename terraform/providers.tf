terraform {
  required_version = ">= 1.0"
  
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
  }
  
  # Remote state backend
  backend "gcs" {
    bucket = "natural-furnace-468312-u6-terraform-state"
    prefix = "terraform/state"
    # credentials will be read from GOOGLE_APPLICATION_CREDENTIALS env var
  }
}

provider "google" {
  project = var.project_id
  region  = var.region
  
  # Use credentials from environment variable or file
  credentials = var.credentials_file != "" ? file(var.credentials_file) : null
}