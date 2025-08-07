output "artifact_registry_repository" {
  description = "The Artifact Registry repository URL"
  value       = google_artifact_registry_repository.docker_repo.name
}

output "artifact_registry_url" {
  description = "The full Artifact Registry URL for Docker images"
  value       = "${var.region}-docker.pkg.dev/${var.project_id}/${var.repository_id}"
}

output "service_account_email" {
  description = "The service account email for CI/CD"
  value       = data.google_service_account.github_actions.email
}