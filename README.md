# gcp-iam

Terraform configuration that creates GCP projects under a GCP Organization, linked to a billing account, using a reusable `project` module that is invoked once per project from the root module.

## Repository structure
```
gcp-iam/
├── modules/
│   └── project/            # Reusable module: creates a single GCP project
│       ├── main.tf
│       ├── variables.tf
│       ├── outputs.tf
│       └── versions.tf
├── main.tf                 # Root: loops over projects and calls the module
├── variables.tf            # Root input variables
├── outputs.tf              # Root outputs
├── versions.tf             # Provider configuration (ADC)
├── terraform.tfvars        # Input values
├── .gitignore
├── README.md
└── Questions/
    └── project-creation-clarification-questions.md
```

## Projects created

| Logical name | Project ID       | Display name   | Environment |
|--------------|------------------|----------------|-------------|
| app-dev      | iam-app-dev      | app-dev        | dev         |
| app-qa       | iam-app-qa       | app-qa         | qa          |
| shared-infra | iam-shared-infra | shared-infra   | shared      |

All projects receive these labels: `environment`, `managed_by = terraform`, `team`.

## The project module (`modules/project`)

A generic, reusable module that creates a single GCP project. Inputs: `org_id`, `billing_account_id`, `project_id`, `display_name`, `labels`.
It declares `required_providers` but no `provider` block (provider config lives in the root).

## Inputs (terraform.tfvars)

| Variable              | Value                 |
|-----------------------|-----------------------|
| org_id                | 133497610275          |
| billing_account_id    | 017BE8-64780C-274856  |
| project_prefix        | iam                   |
| region                | us-east1              |

## Authentication

This config uses Application Default Credentials (ADC). Run:
```
gcloud auth application-default login
```

## State

Local state (as requested). State files are ignored by git via `.gitignore`.

## Out of scope (per requirements)

- API enablement - handled separately.
- IAM bindings - handled separately.

## Usage (not run automatically)
```
terraform init
terraform plan
terraform apply
```
