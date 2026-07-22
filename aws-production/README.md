# Terraform AWS Production Starter

A production-oriented Terraform repository for AWS with:

- Remote state in S3
- State locking in DynamoDB
- Reusable Terraform modules
- GitHub Actions CI/CD
- Scheduled drift detection
- Infracost pull request cost visibility
- Checkov Terraform security scanning
- HashiCorp Vault integration for secret retrieval

What This Deploys
- VPC
- Public subnet
- Internet gateway
- Route table and association
- Security group allowing SSH and HTTP
- EC2 instance with Apache installed via user_data

A commented-out Application Load Balancer block is included for future expansion.

Security Model
- Preferred authentication for GitHub Actions is OIDC to AWS
- Optional Vault integration uses GitHub OIDC/JWT
- Sensitive local files are excluded from Git via .gitignore
- Terraform remote state is stored in encrypted S3 with versioning enabled
- DynamoDB is used for state locking

## Repository Layout

```text
bootstrap/      -> one-time backend creation (local state)
live/prod/      -> production stack using remote state
modules/        -> reusable Terraform modules
.github/        -> GitHub Actions workflows
.
terraform-aws-production/
├── .github/
│   └── workflows/
│       ├── terraform-validate-security-cost.yml
│       ├── terraform-plan-apply.yml
│       ├── terraform-drift-detection.yml
│       └── terraform-destroy.yml
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
├── live/
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       ├── variables.tf
│       └── versions.tf
├── modules/
│   ├── network/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── security-group/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── compute/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── .gitignore
├── LICENSE
├── README.md
└── CHANGELOG.md