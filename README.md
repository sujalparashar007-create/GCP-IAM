# gcp-iam

Terraform configuration that creates GCP projects under a GCP Organization, linked to a billing account, with reusable modules for project creation, API enablement, IAM bindings, and service accounts.

## Repository structure
```
gcp-iam/
├── modules/
│   ├── project/            # Reusable module: creates a single GCP project
│   ├── api-services/       # Module: enables GCP APIs on a project
│   ├── iam/                # Module: assigns IAM roles to members
│   └── service-account/    # Module: creates SA + grants project-level roles
├── main.tf                 # Root: loops over projects and calls all modules
├── variables.tf            # Root input variables
├── outputs.tf              # Root outputs
├── versions.tf             # Provider configuration (ADC)
├── terraform.tfvars        # Input values
├── terraform.tfvars.example # Representative user documentation
├── .gitignore
└── README.md
```

## Projects created

| Logical name   | Project ID          | Display name     | Environment |
|----------------|---------------------|------------------|-------------|
| appdev02       | iam-01-appdev02     | appdev02         | dev         |
| appqa02        | iam-01-appqa02      | appqa02          | qa          |
| sharedinfra02  | iam-01-sharedinfra02| sharedinfra02    | shared      |

All projects receive these labels: `environment`, `managed_by = terraform`, `team`.

## Service accounts (least privilege)

Three service accounts are created in **each project** with only the minimum
IAM roles required for their workload:

| Service Account  | Roles granted                                                  | Purpose                   |
|------------------|----------------------------------------------------------------|---------------------------|
| `terraform-sa`   | `compute.admin`, `storage.admin`, `iam.serviceAccountUser`, `container.admin`, `artifactregistry.admin`, `cloudbuild.builds.editor` | Infrastructure provisioning |
| `cloudbuild-sa`  | `cloudbuild.builds.builder`, `storage.objectViewer`, `logging.logWriter`, `artifactregistry.writer` | CI/CD builds              |
| `gke-sa`         | `container.admin`, `logging.logWriter`, `monitoring.metricWriter` | GKE cluster management    |

See `modules/service-account/main.tf` for the implementation.

## The project module (`modules/project`)

A generic, reusable module that creates a single GCP project. Inputs: `org_id`, `billing_account_id`, `project_id`, `display_name`, `labels`.
It declares `required_providers` but no `provider` block (provider config lives in the root).

## Inputs (terraform.tfvars)

| Variable              | Value                 |
|-----------------------|-----------------------|
| org_id                | 563019909339          |
| billing_account_id    | 01A325-032DBC-FAB4E4  |
| project_prefix        | iam-01                |
| region                | us-east1              |

## Authentication

This config uses Application Default Credentials (ADC). Run:
```
gcloud auth application-default login
```

## State

Local state (as requested). State files are ignored by git via `.gitignore`.

## Usage (not run automatically)
```
terraform init
terraform plan
terraform apply
```