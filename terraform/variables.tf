variable "project_id" {
  description = "The GCP project ID"
  type        = string
  default     = "natural-furnace-468312-u6"
}

variable "region" {
  description = "The GCP region for resources"
  type        = string
  default     = "europe-west1"
}

variable "repository_id" {
  description = "The Artifact Registry repository ID"
  type        = string
  default     = "spring-boot-apps"
}

variable "service_account_id" {
  description = "The service account ID for CI/CD"
  type        = string
  default     = "github-actions-cicd"
}

# credentials_file variable removed - using GOOGLE_APPLICATION_CREDENTIALS env var