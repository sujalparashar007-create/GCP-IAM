variable "project_id" {
  description = "GCP project ID where the custom role is created."
  type        = string
}

variable "role_id" {
  description = "Custom role ID (the part after projects/PROJECT/roles/)."
  type        = string
}

variable "title" {
  description = "Human-readable title for the custom role."
  type        = string
}

variable "description" {
  description = "Description of the custom role."
  type        = string
  default     = null
}

variable "permissions" {
  description = "List of IAM permissions granted by this role."
  type        = list(string)
}