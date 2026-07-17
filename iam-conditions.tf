# ==============================================================================
# Conditional IAM Policies (IAM Conditions)
# ==============================================================================
#
# Demonstrates three types of IAM conditions using CEL (Common Expression Language):
#
#   1. Resource-name prefix  – "qa-buckets-only"
#      QA team can manage objects (create/delete) ONLY in Storage buckets whose name starts with "qa-".
#      CEL: resource.name.startsWith('projects/_/buckets/qa-')
#
#   2. Time-bound (expiry)   – "temporary-access-2026"
#      Dev team gets write access to Storage objects that EXPIRES on Dec 31, 2026.
#      CEL: request.time < timestamp('2026-12-31T23:59:59Z')
#
#   3. Resource-type filter  – "storage-buckets-only"
#      DevOps Storage object admin role is SCOPED to Cloud Storage Bucket resources only.
#      CEL: resource.type == 'storage.googleapis.com/Bucket'
#
# Reference: https://cloud.google.com/iam/docs/conditions-overview

locals {
  conditional_iam = {
    # ── appqa02: QA team – prefix-based bucket restriction ──
    appqa02 = [
      {
        role    = "roles/storage.objectAdmin"
        members = [for email in local.team_members["qa"] : "user:${email}"]
        condition = {
          title       = "qa-buckets-only"
          description = "Allow Storage object admin (create/delete/manage) only on buckets with prefix qa-"
          expression  = "resource.name.startsWith('projects/_/buckets/qa-')"
        }
      }
    ]

    # ── appdev02: Dev team – time-bound temporary write access ──
    appdev02 = [
      {
        role    = "roles/storage.objectCreator"
        members = [for email in local.team_members["development"] : "user:${email}"]
        condition = {
          title       = "temporary-access-2026"
          description = "Temporary object creation permission expiring December 31, 2026"
          expression  = "request.time < timestamp('2026-12-31T23:59:59Z')"
        }
      }
    ]

    # ── sharedinfra02: DevOps team – resource-type scoping ──
    sharedinfra02 = [
      {
        role    = "roles/storage.objectAdmin"
        members = [for email in local.team_members["devops"] : "user:${email}"]
        condition = {
          title       = "storage-buckets-only"
          description = "Storage object admin role scoped exclusively to Cloud Storage Bucket resources"
          expression  = "resource.type == 'storage.googleapis.com/Bucket'"
        }
      }
    ]
  }
}
