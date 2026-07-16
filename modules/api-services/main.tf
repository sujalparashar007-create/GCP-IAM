# Enables required GCP APIs/services on a project.
# This module loops over a provided list of services and enables each one
# using google_project_service. It depends on the project already existing.

resource "google_project_service" "this" {
  for_each = toset(var.services)

  project = var.project_id
  service = each.value

  disable_dependent_services = var.disable_dependent_services
  disable_on_destroy         = var.disable_on_destroy
}
