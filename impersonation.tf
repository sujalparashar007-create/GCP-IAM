# ==============================================================================
# Service Account Impersonation Rules
# ==============================================================================
#
# Principle of least privilege: only DevOps team members are allowed to
# impersonate the terraform-sa service account. Development and QA users
# do NOT have impersonation permissions on any service account.
#
# This is enforced via google_service_account_iam_binding which grants
# roles/iam.serviceAccountUser exclusively to the DevOps team.

locals {
  sa_impersonation = {
    "terraform-sa" = {
      role    = "roles/iam.serviceAccountUser"
      members = [for email in local.team_members["devops"] : "user:${email}"]
    }
  }
}
