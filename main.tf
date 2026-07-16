# Root configuration: loops over the provided projects and calls the reusable project module once per project.

# The root is responsible for composing the final project_id (prefix + display_name)
# and the labels map. The module itself is generic and creates a single GCP project.

locals {
  project_list = {
    for k, p in var.projects : k => {
      project_id   = "${var.project_prefix}-${p.display_name}"
      display_name = p.display_name
      labels = {
        environment = p.environment
        managed_by  = "terraform"
        team        = p.team
      }
    }
  }
}

module "project" {
  for_each = local.project_list

  source = "./modules/project"

  org_id             = var.org_id
  billing_account_id = var.billing_account_id
  project_id         = each.value.project_id
  display_name       = each.value.display_name
  labels             = each.value.labels
}

# ------------------------------------------------------------------------------
# Enable required GCP APIs on each project
# ------------------------------------------------------------------------------
module "api_services" {
  for_each = local.project_list

  source = "./modules/api-services"

  project_id = module.project[each.key].project_id
  # Optional: override default APIs
  #services = each.key == "sharedinfra01" ? ["iam.googleapis.com", "storage.googleapis.com"] : null
}

