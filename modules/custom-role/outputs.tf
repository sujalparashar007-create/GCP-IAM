output "id" {
  description = "Full custom role resource ID."
  value       = google_project_iam_custom_role.this.id
}

output "name" {
  description = "Full custom role name (projects/PROJECT/roles/ROLE_ID)."
  value       = google_project_iam_custom_role.this.name
}

output "role_id" {
  description = "The custom role ID."
  value       = google_project_iam_custom_role.this.role_id
}