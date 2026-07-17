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

# ------------------------------------------------------------------------------
# IAM: Granular role-based access control per team (least privilege)
# ------------------------------------------------------------------------------
# Production Note: In enterprise environments, use Google Groups instead of
# individual users.
#
#   Development Team (appdev02):
#     Can: view resources, read logs, deploy apps to GKE, push images to
#          Artifact Registry, trigger Cloud Build, read Cloud Storage.
#     Cannot: modify IAM, create VPCs, delete projects, create service
#             accounts, modify firewall rules.
#
#   QA Team (appqa02):
#     Can: view resources, read logs, view Monitoring dashboards, read
#          Cloud Storage, access test environments.
#     Cannot: deploy infrastructure, change IAM, delete resources,
#             modify networking.
#
#   DevOps Team (sharedinfra02):
#     Can: create Compute Engine VMs, create GKE clusters, manage networking,
#          create service accounts, configure IAM, manage Cloud DNS,
#          configure Cloud Build/Monitoring/Logging, manage Cloud Storage,
#          deploy infrastructure via Terraform.
#     Plus viewer access on dev & qa projects for operational visibility.
#
#   Scalability: the bindings map is iterated via for_each in module "iam",
#   so adding new projects or teams is a data-only change.

locals {
  # Dynamically generate IAM bindings by cross-referencing project-specific
  # team_roles, team_members, and project_list.
  # Every team gets its configured role set on its corresponding project.

  # Resolve custom role references to full GCP role paths using module outputs.
  # Any role name matching a key in custom_roles.tf is resolved via module.custom_roles[key].name
  resolved_iam_roles = {
    for pk, p in local.project_list : pk => {
      for role in distinct(flatten([
        for team, roles in local.team_roles[pk] : roles
        ])) : role => (
        contains(keys(local.custom_roles), role)
        ? module.custom_roles[role].name
        : role
      )
    }
  }
  iam_bindings = {

    for pk, p in local.project_list : pk => {
      for role in distinct(flatten([
        for team, roles in local.team_roles[pk] : roles
      ])) :
      local.resolved_iam_roles[pk][role] => flatten([
        for team, roles in local.team_roles[pk] : [
          for email in local.team_members[team] :
          "user:${email}"
          if contains(roles, role)
        ]
      ])
    }
  }
}

# ------------------------------------------------------------------------------
# Service Accounts: per-project SA with minimum required permissions
# ------------------------------------------------------------------------------
# Each project gets three service accounts. Roles follow least privilege:
#
#   terraform-sa   -> Infrastructure provisioning (compute, storage, IAM, GKE, etc.)
#   cloudbuild-sa  -> CI/CD builds (Cloud Build + artifact access + logging)
#   gke-sa         -> GKE cluster management (container + logging + monitoring)
#
# Service account definitions live in service-accounts.tf

locals {
  sa_per_project = merge([
    for pk, p in local.project_list : {
      for sa_name, sa_def in local.service_accounts :
      "${pk}__${sa_name}" => {
        project_id   = module.project[pk].project_id
        account_id   = sa_name
        display_name = "${sa_name} (${p.display_name})"
        description  = "Service account for ${sa_def.roles[0]} in ${p.display_name}"
        roles        = sa_def.roles
      }
    }
  ]...)
}

module "service_account" {
  for_each = local.sa_per_project
  source   = "./modules/service-account"

  project_id   = each.value.project_id
  account_id   = each.value.account_id
  display_name = each.value.display_name
  description  = each.value.description
  roles        = each.value.roles

  depends_on = [module.api_services]
}

module "iam" {

  for_each = local.project_list

  source = "./modules/iam"

  project_id = module.project[each.key].project_id
  bindings   = try(local.iam_bindings[each.key], {})

  depends_on = [module.custom_roles]
}

# ==============================================================================
# Conditional IAM Policies (IAM Conditions)
# ==============================================================================

module "iam_conditions" {
  for_each = local.project_list

  source = "./modules/iam-conditions"

  project_id           = module.project[each.key].project_id
  conditional_bindings = try(local.conditional_iam[each.key], [])

  depends_on = [module.api_services]
}

# ==============================================================================
# Custom IAM Roles
# ==============================================================================

module "custom_roles" {
  source = "./modules/custom-role"

  for_each = local.custom_roles

  project_id = module.project[each.value.projects[0]].project_id

  role_id     = each.value.role_id
  title       = each.value.title
  description = each.value.description
  permissions = each.value.permissions
}
