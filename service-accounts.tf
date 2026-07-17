# ==============================================================================
# Service account definitions per project
# ==============================================================================

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
}