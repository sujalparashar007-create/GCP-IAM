variable "org_id" {
  description = "GCP Organization ID to use as the parent for all projects."
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID to link to all projects."
  type        = string
}

variable "project_prefix" {
  description = "Prefix applied to each project ID. Must be lowercase, 6-30 chars, start with a letter."
  type        = string
  default     = "iam-02"
}

variable "region" {
  description = "Default region for the provider and project resources."
  type        = string
  default     = "us-east1"
}

variable "projects" {
  description = "Map of projects to create. Key = logical name, value = object with display_name and environment label."
  type = map(object({
    display_name = string
    environment  = string
    team         = string
  }))
  default = {
    appdev02 = {
      display_name = "appdev02"
      environment  = "dev"
      team         = "platform"
    }
    appqa02 = {
      display_name = "appqa02"
      environment  = "qa"
      team         = "platform"
    }
    sharedinfra02 = {
      display_name = "sharedinfra02"
      environment  = "shared"
      team         = "platform"
    }
  }
}

# ------------------------------------------------------------------------------
# IAM: Team members for RBAC (hypothetical — replace with real emails)
# ------------------------------------------------------------------------------
# These represent three logical teams:
#   Development Team → dev project (editor)
#   QA Team          → qa project (viewer)
#   DevOps Team      → shared-infra (editor) + viewer on dev/qa

variable "team_members" {
  description = "IAM user emails representing the three logical teams."
  type = object({
    development = string
    qa          = string
    devops      = string
  })
  default = {
    development = "dev-user@example.com"
    qa          = "qa-user@example.com"
    devops      = "devops-user@example.com"
  }
}

