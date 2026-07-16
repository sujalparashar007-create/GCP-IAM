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
  iam_bindings = {
    # Development Team on appdev02 (+ DevOps viewer)
    appdev02 = {
      "roles/viewer" = [
        "user:${var.team_members.development}",
        "user:${var.team_members.devops}",
      ]
      "roles/logging.viewer"           = ["user:${var.team_members.development}"]
      "roles/container.developer"      = ["user:${var.team_members.development}"]
      "roles/artifactregistry.writer"  = ["user:${var.team_members.development}"]
      "roles/cloudbuild.builds.editor" = ["user:${var.team_members.development}"]
      "roles/storage.objectViewer"     = ["user:${var.team_members.development}"]
    }

    # QA Team on appqa02 (+ DevOps viewer)
    appqa02 = {
      "roles/viewer" = [
        "user:${var.team_members.qa}",
        "user:${var.team_members.devops}",
      ]
      "roles/logging.viewer"       = ["user:${var.team_members.qa}"]
      "roles/monitoring.viewer"    = ["user:${var.team_members.qa}"]
      "roles/storage.objectViewer" = ["user:${var.team_members.qa}"]
    }

    # DevOps Team on sharedinfra02
    sharedinfra02 = {
      "roles/compute.admin"                   = ["user:${var.team_members.devops}"]
      "roles/container.admin"                 = ["user:${var.team_members.devops}"]
      "roles/iam.serviceAccountAdmin"         = ["user:${var.team_members.devops}"]
      "roles/resourcemanager.projectIamAdmin" = ["user:${var.team_members.devops}"]
      "roles/dns.admin"                       = ["user:${var.team_members.devops}"]
      "roles/cloudbuild.builds.editor"        = ["user:${var.team_members.devops}"]
      "roles/monitoring.admin"                = ["user:${var.team_members.devops}"]
      "roles/logging.admin"                   = ["user:${var.team_members.devops}"]
      "roles/storage.admin"                   = ["user:${var.team_members.devops}"]
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

locals {
  service_accounts = {
    terraform-sa = {
      roles = [
        "roles/compute.admin",
        "roles/storage.admin",
        "roles/iam.serviceAccountUser",
        "roles/container.admin",
        "roles/artifactregistry.admin",
        "roles/cloudbuild.builds.editor",
      ]
    }
    cloudbuild-sa = {
      roles = [
        "roles/cloudbuild.builds.builder",
        "roles/storage.objectViewer",
        "roles/logging.logWriter",
        "roles/artifactregistry.writer",
      ]
    }
    gke-sa = {
      roles = [
        "roles/container.admin",
        "roles/logging.logWriter",
        "roles/monitoring.metricWriter",
      ]
    }
  }
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
}