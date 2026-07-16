output "email" {
  description = "Full email of the service account (account@project.iam.gserviceaccount.com)."
  value       = google_service_account.this.email
}

output "id" {
  description = "The service account resource ID."
  value       = google_service_account.this.id
}

output "service_account" {
  description = "The full google_service_account resource."
  value       = google_service_account.this
}

output "assigned_roles" {
  description = "Map of role to the IAM member binding resource."
  value       = google_project_iam_member.this
}
