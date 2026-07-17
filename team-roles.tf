# ==============================================================================
# Team-role definitions - define roles per project for future flexibility
# ==============================================================================

locals {
  team_roles = {
    appdev02 = {
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

    appqa02 = {
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
        # Custom IAM Role
        "applicationSupport",
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

    sharedinfra02 = {
      development = [
        "roles/viewer",
        "roles/logging.viewer",
        "roles/container.developer",
        "roles/artifactregistry.writer",
        "roles/cloudbuild.builds.editor",
        "roles/storage.objectViewer",
        "roles/browser",
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
}
