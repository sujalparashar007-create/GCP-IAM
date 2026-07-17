# Reusable module: creates a single custom IAM role at the project level.

resource "google_project_iam_custom_role" "this" {
  role_id     = var.role_id
  title       = var.title
  description = var.description
  permissions = var.permissions
  project     = var.project_id
}