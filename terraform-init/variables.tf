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

# credentials_file variable removed - using GOOGLE_APPLICATION_CREDENTIALS env var