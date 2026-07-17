variable "project_id" {
  description = "GCP project ID where the service account is created."
  type        = string
}

variable "account_id" {
  description = "The account id used to generate the SA email (the part before @)."
  type        = string
}

variable "display_name" {
  description = "Optional display name. Defaults to account_id."
  type        = string
  default     = null
}

variable "description" {
  description = "Optional description for the service account."
  type        = string
  default     = null
}

variable "roles" {
  description = "List of project-level IAM roles to grant the service account."
  type        = list(string)
  default     = []
}
