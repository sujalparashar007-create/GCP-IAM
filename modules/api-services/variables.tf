variable "project_id" {
  description = "The GCP project ID where APIs should be enabled."
  type        = string
}

variable "services" {
  description = "List of GCP APIs/services to enable on the project."
  type        = list(string)
  default = [
    "compute.googleapis.com",              # Compute Engine API
    "iam.googleapis.com",                  # IAM API
    "cloudresourcemanager.googleapis.com", # Cloud Resource Manager API
    "storage.googleapis.com",              # Cloud Storage API
    "container.googleapis.com",            # Kubernetes Engine API
    "artifactregistry.googleapis.com",     # Artifact Registry API
    "cloudbuild.googleapis.com",           # Cloud Build API
    "logging.googleapis.com",              # Logging API
    "monitoring.googleapis.com",           # Monitoring API
  ]
}

variable "disable_dependent_services" {
  description = "If true, disable dependent services when the main service is destroyed."
  type        = bool
  default     = false
}

variable "disable_on_destroy" {
  description = "If true, disable the services when the Terraform resource is destroyed."
  type        = bool
  default     = false
}
