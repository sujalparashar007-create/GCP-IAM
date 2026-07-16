output "project_id" {
  description = "The GCP project ID."
  value       = google_project.this.project_id
}

output "project_number" {
  description = "The GCP project number."
  value       = google_project.this.number
}

output "project" {
  description = "The full google_project resource object."
  value       = google_project.this
}
