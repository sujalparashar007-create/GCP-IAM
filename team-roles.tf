# ==============================================================================
# Team-role definitions - change role sets here, not in main.tf
# ==============================================================================

locals {
  team_roles = {
    development = [
      "roles/viewer",
      "roles/logging.viewer",
      "roles/container.developer",
      "roles/artifactregistry.writer",
      "roles/cloudbuild.builds.editor",
      "roles/storage.objectViewer",
    ]
    qa = [
      "roles/viewer",
      "roles/logging.viewer",
      "roles/monitoring.viewer",
      "roles/storage.objectViewer",
    ]
    devops = [
      "roles/compute.admin",
      "roles/container.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/resourcemanager.projectIamAdmin",
      "roles/dns.admin",
      "roles/cloudbuild.builds.editor",
      "roles/monitoring.admin",
      "roles/logging.admin",
      "roles/storage.admin",
    ]
  }
}