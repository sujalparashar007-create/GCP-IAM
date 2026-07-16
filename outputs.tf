output "project_ids" {
  description = "Map of logical project name to created GCP project ID."
  value       = { for k, p in local.project_list : k => module.project[k].project_id }
}

output "project_numbers" {
  description = "Map of logical project name to created GCP project number."
  value       = { for k, p in local.project_list : k => module.project[k].project_number }
}

output "projects" {
  description = "Full google_project objects for the created projects."
  value       = { for k, p in local.project_list : k => module.project[k].project }
}

output "enabled_apis" {
  description = "Map of logical project name to the list of enabled API services."
  value       = { for k, p in local.project_list : k => module.api_services[k].service_names }
}

output "iam_assignments" {
  description = "Map of logical project name to list of {role, member} IAM bindings."
  value       = { for k, p in local.project_list : k => try(module.iam[k].assignments, []) }
}


