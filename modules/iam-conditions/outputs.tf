output "conditional_bindings" {
  description = "Map of condition title to google_project_iam_binding resource"
  value       = google_project_iam_binding.conditional
}

output "conditions_summary" {
  description = "Human-readable summary of all conditional IAM bindings"
  value = [
    for binding in google_project_iam_binding.conditional : {
      role      = binding.role
      members   = binding.members
      condition = binding.condition
    }
  ]
}
