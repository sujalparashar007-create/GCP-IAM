# Conditional IAM bindings using CEL expressions.
# Each binding applies a role with a condition that restricts when access is granted.
#
# Condition types demonstrated:
#   1. resource.name  – restrict to buckets with a specific prefix
#   2. request.time   – grant temporary access that expires on a date
#   3. resource.type  – restrict a role to a specific resource type

resource "google_project_iam_binding" "conditional" {
  for_each = {
    for binding in var.conditional_bindings :
    binding.condition.title => binding
  }

  project = var.project_id
  role    = each.value.role
  members = each.value.members

  condition {
    title       = each.value.condition.title
    description = each.value.condition.description
    expression  = each.value.condition.expression
  }
}
