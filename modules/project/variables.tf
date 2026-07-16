variable "org_id" {
  description = "GCP Organization ID to use as the parent for the project."
  type        = string
}

variable "billing_account_id" {
  description = "Billing Account ID to link to the project."
  type        = string
}

variable "project_id" {
  description = "The GCP project ID (globally unique)."
  type        = string
}

variable "display_name" {
  description = "The display name for the project."
  type        = string
}

variable "labels" {
  description = "Labels to apply to the project."
  type        = map(string)
  default     = {}
}
