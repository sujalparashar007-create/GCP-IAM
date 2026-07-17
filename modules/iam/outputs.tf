output "members" {
  description = "Map of binding key to google_project_iam_member resources."
  value       = google_project_iam_member.this
}

output "assignments" {
  description = "List of {role, member} pairs applied to the project."
  value       = [for b in google_project_iam_member.this : { role = b.role, member = b.member }]
}
