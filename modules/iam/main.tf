# Assigns IAM roles to members on a GCP project.
# Accepts a map of role → list of members and creates additive
# google_project_iam_member bindings for each role-member pair.

locals {
  flat_bindings = merge([
    for role, members in var.bindings : {
      for member in members :
      "${role}__${replace(member, ":", "-")}" => {
        role   = role
        member = member
      }
    }
  ]...)
}

resource "google_project_iam_member" "this" {
  for_each = local.flat_bindings

  project = var.project_id
  role    = each.value.role
  member  = each.value.member
}
