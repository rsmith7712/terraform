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