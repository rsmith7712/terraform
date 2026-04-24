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

## What This Deploys

- VPC
- Public subnet
- Internet gateway
- Route table and association
- Security group allowing SSH and HTTP
- EC2 instance with Apache installed via `user_data`

A commented-out Application Load Balancer block is included for future expansion.

## Security Model

- Preferred authentication for GitHub Actions is OIDC to AWS
- Optional Vault integration uses GitHub OIDC/JWT
- Sensitive local files are excluded from Git via `.gitignore`
- Terraform remote state is stored in encrypted S3 with versioning enabled
- DynamoDB is used for state locking

## Repository Layout

```text
bootstrap/      -> one-time backend creation (local state)
live/prod/      -> production stack using remote state
modules/        -> reusable Terraform modules
.github/        -> GitHub Actions workflows
.
terraform/v1-aws-production/
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
│   └── prod/
│       ├── backend.hcl
│       ├── main.tf
│       ├── outputs.tf
│       ├── providers.tf
│       ├── terraform.tfvars
│       ├── variables.tf
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
In files:
- live/prod/backend.hcl
- live/prod/terraform.tfvars

Update values of:
- bucket name
- region
- lock table name
- AMI
- instance type
- allowed SSH CIDR
- tags

#### 4. Initialize The Production Stack

```bash
cd live/prod
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

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
GitHub documents OIDC for cloud workflows, and GitHub specifically
provides AWS OIDC guidance. AWS documents creating OIDC identity
providers and roles for OIDC federation.

At a high level:
1. In AWS IAM, create an OIDC identity provider for GitHub Actions.
2. Create an IAM role trusted by that OIDC provider.
3. Restrict trust to your repository, branch, or environment.
4. Grant only the AWS permissions Terraform needs.
5. Store the role ARN in GitHub repository variable: `AWS_ROLE_TO_ASSUME`
6. `VAULT_ADDR` repository variable if using Vault
7. Any required Vault role/path variables
8. Infracost API key if using Infracost comment integration

#### 7. Configure GitHub Repository Settings
Add repository variables:
- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME`
- `TF_WORKING_DIR`
- `VAULT_ADDR` (if using Vault)
- `VAULT_NAMESPACE` (if applicable)
- `VAULT_JWT_PATH`
- `VAULT_JWT_ROLE`
- Any required Vault role/path variables

Add repository secrets:
- `INFRACOST_API_KEY`
- Any fallback secrets, only if Vault is not yet implemented

#### 8. Open A Pull Request
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
Use the workflow and choose [apply]:

```bash
terraform plan apply
```

That is safer than auto-apply on every push because it forces an operator
review point before infrastructure changes.

#### 10. Enable Drift Detection
The scheduled drift workflow runs during weekdays and raises a GitHub issue
if drift is detected. This is a sound operational pattern because
refresh-only mode compares state to reality without trying to change
infrastructure during the detection phase.

#### 11. Optional Vault Rollout
If you adopt Vault:
1. Configure GitHub OIDC trust in Vault.
2. Create a Vault JWT auth role scoped to your repo and branch.
3. Store application/API secrets in Vault.
4. Retrieve them in workflow steps with hashicorp/vault-action.

#### Recommendations
- Do not commit `terraform.tfvars`, private keys, state files, or backend config files.
- Prefer manual apply over automatic apply on every push.
- Review drift notifications before applying changes.
- Restrict SSH to a known admin IP instead of 0.0.0.0/0.
- Use two public subnets in different AZs before enabling an ALB.
- Prefer SSM Session Manager over SSH if your environment supports it.
- Pin AMIs more deliberately, or source them through a data source.
- Add TFLint alongside fmt and validate; HashiCorp’s style guidance explicitly recommends linting in addition to formatting and validation.
- Use separate live/dev, live/stage, and live/prod folders or workspaces depending on your operating model.