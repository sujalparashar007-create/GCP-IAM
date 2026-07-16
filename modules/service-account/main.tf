# Creates a single GCP service account and assigns project-level IAM roles.
# Follows the principle of least privilege — only the roles explicitly provided
# are granted. The module does NOT create a key; key management is separate.

resource "google_service_account" "this" {
  account_id   = var.account_id
  display_name = var.display_name != null ? var.display_name : var.account_id
  description  = var.description
  project      = var.project_id
}

resource "google_project_iam_member" "this" {
  for_each = toset(var.roles)

  project = var.project_id
  role    = each.value
  member  = "serviceAccount:${google_service_account.this.email}"
}
