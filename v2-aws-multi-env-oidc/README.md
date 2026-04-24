# Terraform AWS Multi-Environment Starter (OIDC Only, No Vault)

A production-oriented Terraform repository for AWS that uses:

- S3 remote state
- DynamoDB state locking
- GitHub Actions with AWS OIDC only
- Separate live environments for `dev`, `stage`, and `prod`
- Reusable Terraform modules
- Checkov security scanning
- Infracost PR cost visibility
- Scheduled drift detection

## What This Deploys

Each live environment deploys:

- VPC
- Public subnet
- Internet gateway
- Route table and association
- Security group allowing SSH and HTTP
- EC2 instance with Apache installed via `user_data`

A commented Application Load Balancer example is included for future expansion.

## Security Model

This repository is intentionally **OIDC only** for GitHub Actions:

- No Vault integration
- No long-lived AWS access keys in GitHub secrets
- GitHub Actions assumes an AWS IAM role using OpenID Connect

## Repository Layout

```text
bootstrap/            -> one-time backend creation using local state
live/dev/             -> development environment
live/prod/            -> production environment
live/stage/           -> staging environment
modules/              -> reusable Terraform modules
.github/workflows/    -> CI/CD workflows
.
terraform/v2-aws-multi-env-oidc/
├── .github/
│   └── workflows/
│       ├── terraform-destroy.yml
│       ├── terraform-drift-detection.yml
│       ├── terraform-plan-apply.yml
│       └── terraform-validate-security-cost.yml
├── bootstrap/
│   ├── main.tf
│   ├── outputs.tf
│   ├── providers.tf
│   ├── terraform.tfvars
│   ├── variables.tf
│   └── versions.tf
├── live/
│   ├── dev/
│   │   ├── backend.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   ├── prod/
│   │   ├── backend.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│   │   └── versions.tf
│   └── stage/
│   │   ├── backend.hcl
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   ├── providers.tf
│   │   ├── terraform.tfvars
│   │   ├── variables.tf
│       └── versions.tf
├── modules/
│   ├── compute/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   ├── network/
│   │   ├── main.tf
│   │   ├── outputs.tf
│   │   └── variables.tf
│   └── security-group/
│       ├── main.tf
│       ├── outputs.tf
│       └── variables.tf
├── .gitignore
├── CHANGELOG.md
├── LICENSE
└── README.md
```

### Step-By-Step Implementation Instructions

#### 1. Build The Repository Locally
- Create the folders and files exactly as shown above.

#### 2. Bootstrap The Remote Backend
In file:
- bootstrap/terraform.tfvars

Update values of:
- aws_region
- state_bucket_name
- lock_table_name
- tags

```bash
cd bootstrap
terraform init
terraform fmt -recursive
terraform validate
terraform plan -out=awsBootstrapRmtBE > awsBootstrap_RmtBE.txt
terraform apply
```

Confirm:
- S3 bucket exists
- Versioning is enabled
- Encryption is enabled
- Public access is blocked
- DynamoDB table exists

#### 3. Configure The Live Environment
For each environment, update the following with `environment-specific` values.

dev:
- live/dev/backend.hcl
- live/dev/terraform.tfvars

prod:
- live/prod/backend.hcl
- live/prod/terraform.tfvars

stage:
- live/stage/backend.hcl
- live/stage/terraform.tfvars

Update values of:
- bucket name
- region
- lock table name
- AMI
- instance type
- allowed SSH CIDR
- tags

#### 4. Initialize The Production Stack
Example for dev:
```bash
cd live/dev
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

Repeat for `prod` and `stage`.

#### 5. Verify Deployment
```bash
terraform output
```

You should see:
- vpc_id
- public_subnet_id
- instance_id
- instance_public_ip
- instance_private_ip

Test HTTP:
curl http://<instance_public_ip>

You should see:
- The Apache landing content from: user_data

#### 6. Configure GitHub Actions
Create repository variables:
- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME`

Optional GitHub repository or environment variables:
- `TF_DEV_WORKING_DIR`
- `TF_PROD_WORKING_DIR`
- `TF_STAGE_WORKING_DIR`

Create repository secret:
- `INFRACOST_API_KEY`

#### 7. Open A Pull Request
The PR workflow will:
- initialize Terraform
- run terraform fmt -check
- run terraform validate
- run terraform plan
- run Checkov
- generate Infracost output
- comment cost delta back to the PR

This aligns with Terraform CLI guidance for formatting and validation,
Checkov’s GitHub Actions support, and Infracost’s CI/CD PR-comment model.

#### 9. Run Apply Manually
Use the manual workflow and choose:

- target environment: `dev`, `stage`, or `prod`
- action: `plan` or `apply`

This is safer than auto-apply on every push because it forces an operator
review point before infrastructure changes.

#### 10. Enable Drift Detection
The scheduled drift workflow runs during weekdays and raises a GitHub issue
if drift is detected. This is a sound operational pattern because
refresh-only mode compares state to reality without trying to change
infrastructure during the detection phase.

#### 11. Advised Promotion Model

- `dev` for early testing
- `stage` for pre-production validation
- `prod` for approved production changes only

#### Recommendations
- Do not commit `terraform.tfvars`, `backend.hcl`, private keys, state files, or backend config files.
- Prefer manual apply over automatic apply on every push, especially for `stage` and `prod`.
- Review drift notifications before applying changes.
- Restrict SSH ingress to trusted admin IPs, and not 0.0.0.0/0.
- Use two public subnets in different AZs before enabling an ALB.
- Prefer SSM Session Manager over SSH if your environment supports it.
- Pin AMIs more deliberately, or source them through a data source.