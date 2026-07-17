variable "project_id" {
  description = "GCP Project ID where conditional IAM bindings will be applied"
  type        = string
}

variable "conditional_bindings" {
  description = "List of conditional IAM bindings to create"
  type = list(object({
    role    = string
    members = list(string)
    condition = object({
      title       = string
      description = string
      expression  = string
    })
  }))
  default = []
}
