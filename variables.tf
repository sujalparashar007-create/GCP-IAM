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
  default     = "iam-01"
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
    appdev01 = {
      display_name = "appdev01"
      environment  = "dev"
      team         = "platform"
    }
    appqa01 = {
      display_name = "appqa01"
      environment  = "qa"
      team         = "platform"
    }
    sharedinfra01 = {
      display_name = "sharedinfra01"
      environment  = "shared"
      team         = "platform"
    }
  }
}
