variable "project_id" {
  description = "The GCP project ID to assign IAM roles on."
  type        = string
}

variable "bindings" {
  description = "Map of IAM role to list of member principals (e.g., user:email, group:email, serviceAccount:email)."
  type        = map(list(string))
  default     = {}
}
