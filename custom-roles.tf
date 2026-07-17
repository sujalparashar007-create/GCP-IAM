# ==============================================================================
# Custom IAM role definitions
# ==============================================================================

locals {
  custom_roles = {
    applicationSupport = {
      role_id     = "applicationSupport"
      title       = "Application Support Role"
      description = "View Compute Engine instances, Cloud Storage buckets, and logs."
      projects    = ["appqa02"]
      permissions = [
        "compute.instances.get",
        "compute.instances.list",
        "storage.buckets.get",
        "storage.buckets.list",
        "logging.logs.list",
        "logging.logEntries.list",
      ]
    }
  }
}
