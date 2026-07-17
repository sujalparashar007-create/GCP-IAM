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


# ------------------------------------------------------------------------------
# Service Account outputs
# ------------------------------------------------------------------------------
output "service_account_emails" {
  description = "Map of 'project__sa-name' → full SA email."
  value       = { for k, sa in module.service_account : k => sa.email }
}

output "service_accounts" {
  description = "All service account resources keyed by 'project__sa-name'."
  value       = { for k, sa in module.service_account : k => sa.service_account }
}

output "service_accounts_by_project" {
  description = "Service account emails grouped by logical project name."
  value = {
    for pk, p in local.project_list : pk => {
      for sa_name, sa_def in local.service_accounts :
      sa_name => module.service_account["${pk}__${sa_name}"].email
    }
  }
}



# ------------------------------------------------------------------------------
# Conditional IAM outputs
# ------------------------------------------------------------------------------

output "conditional_iam_bindings" {
  description = "Map of project name to conditional IAM binding summaries"
  value = {
    for pk, p in local.project_list : pk => try(module.iam_conditions[pk].conditions_summary, [])
  }
}

output "conditional_iam_resources" {
  description = "Raw google_project_iam_binding resources for IAM conditions"
  value = {
    for pk, p in local.project_list : pk => try(module.iam_conditions[pk].conditional_bindings, {})
  }
}
