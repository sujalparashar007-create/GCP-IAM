# Creates a single GCP project under a GCP Organization, linked to a billing account.
# No APIs are enabled and no IAM bindings are created here (handled separately per requirements).

resource "google_project" "this" {
  name            = var.display_name
  project_id      = var.project_id
  org_id          = var.org_id
  billing_account = var.billing_account_id
  labels          = var.labels
  deletion_policy = "DELETE"
}
