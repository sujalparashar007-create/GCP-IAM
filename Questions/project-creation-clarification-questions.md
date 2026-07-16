# GCP Project Creation — Clarification Questions

Please answer the following questions so the Terraform module can be written accurately and without assumptions.

## 1. GCP parent resource
- Do these projects belong to a **GCP Organization** or a **Folder**? ==> GCP Organisation
- Provide the Organization ID or Folder ID.  ==> organisation id- 133497610275
- If there is no parent, confirm that the projects should be created as standalone projects. ==> use this organisation as parent -- organisation id = 133497610275

## 2. Billing account
- Provide the **Billing Account ID** to link to all three projects. ==> Billing Account ID:017BE8-64780C-274856
- If billing should **not** be linked, confirm explicitly. ==> Yes, link the specified billing account to the project.

## 3. Project IDs
- GCP project IDs are **globally unique**. 
- Should the IDs be exactly `app-dev`, `app-qa`, and `shared-infra`? ==> yes
- If those IDs are likely already taken, what prefix or suffix should be used?  ==> use "iam" as prefix 
  Example: `company-app-dev`, `company-app-qa`, `company-shared-infra`.

## 4. Project display names
- Use the same values as the project IDs, or custom display names?  ==> yes use same values
  Example: `App Dev`, `App QA`, `Shared Infrastructure`.

## 5. Labels
- What labels should be applied to each project?  ==> yes use environment, managed by and team
  Example: `environment = dev/qa/shared`, `managed_by = terraform`, `team = platform`. 

## 6. APIs / services to enable
- Should any APIs be enabled on project creation? Common defaults include:
  - `iam.googleapis.com`
  - `cloudresourcemanager.googleapis.com`
  - `compute.googleapis.com`
  - `billingbudgets.googleapis.com` (if budgets are needed)
- If yes, list them; if no, confirm none. ==> ignore it we will create it separately

## 7. IAM bindings
- Should any users, groups, or service accounts be granted roles on these projects?
- If `shared-infra` is meant to manage IAM centrally, describe that relationship. ==> ignore it also we will create it separately

## 8. Terraform backend
- Use **local** state in the repo, or a **GCS backend**? ==> local
- If GCS, provide the bucket name and prefix.==> ignore it 

## 9. Authentication
- How should Terraform authenticate to GCP?  ==> use application default credentials 
  Options: Application Default Credentials (ADC), service account key, or environment variable.

## 10. Region / location
- Any default region or location for resources created inside these projects? ==> us-east1

## 11. Module structure
- Should the repo contain a single reusable `project` module that is called three times, or one root module that creates all three projects directly? ==> one root module that loops over provided list of projects

## 12. Approval workflow
- Should I generate the code and run `terraform plan` only, or should I also run `terraform apply` after your review? ==> just update the files and don't run any terraform commands

