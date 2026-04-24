# Terraform AWS Multi-Environment OIDC Starter with Promotion Model

A production-oriented Terraform repository for AWS using:

- OIDC-only GitHub Actions authentication to AWS
- separate `dev`, `stage`, and `prod` environments
- reusable Terraform modules
- pull request validation with Checkov and Infracost
- environment-specific GitHub protections
- promotion flow from `dev -> stage -> prod`

## Repository Layout

```text
bootstrap/      -> one-time backend creation
live/dev/       -> development environment
live/stage/     -> staging environment
live/prod/      -> production environment
modules/        -> reusable Terraform modules
.github/        -> CI/CD workflows, CODEOWNERS, and PR template
docs/           -> protection and promotion guidance
```

## Recommended Branching and Promotion Strategy

Use a branch-per-environment promotion model:

- `develop` -> deploys `live/dev`
- `stage` -> deploys `live/stage`
- `main` -> deploys `live/prod`

Recommended flow:

1. Create a feature branch from `develop`
2. Open a pull request into `develop`
3. Validate and merge to `develop`
4. GitHub Actions deploys `live/dev`
5. After testing, open a pull request from `develop` into `stage`
6. GitHub Actions deploys `live/stage`
7. After approval, open a pull request from `stage` into `main`
8. GitHub Actions deploys `live/prod`

This keeps promotion explicit and auditable.

## GitHub Environments

Create three GitHub environments:

- `dev`
- `stage`
- `prod`

At the environment level, define:

### Environment variables
- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME`

This allows each environment to assume a different AWS IAM role without changing workflow code.

## Recommended Protections

### `develop`
- Require pull requests before merging
- Require status checks:
  - `validate-dev`
  - `validate-stage`
  - `validate-prod`
- Require at least 1 approval
- Dismiss stale approvals on new commits
- Restrict direct pushes except for admins if needed

### `stage`
- Require pull requests before merging
- Require all validation checks
- Require at least 2 approvals
- Restrict pushes to maintainers
- Require linear history
- Enable branch protection for deletions and force-push prevention

### `main`
- Require pull requests before merging
- Require all validation checks
- Require CODEOWNERS review
- Require at least 2 or 3 approvals
- Require signed commits if your organization uses them
- Prevent force pushes and deletions
- Pair with GitHub environment `prod` required reviewers and optional wait timer

## Deployment Workflows

- Pull requests to `develop`, `stage`, or `main` run validation, security scanning, and cost estimation
- Push to `develop` applies `live/dev`
- Push to `stage` applies `live/stage`
- Push to `main` applies `live/prod`
- Scheduled drift detection checks all environments
- Manual destroy remains available by environment

## Quick Start

### 1. Bootstrap the remote backend
Copy `bootstrap/terraform.tfvars.example` to `bootstrap/terraform.tfvars`, update values, then run:

```bash
cd bootstrap
terraform init
terraform plan
terraform apply
```

### 2. Configure each environment
For each of `live/dev`, `live/stage`, and `live/prod`:

- copy `backend.hcl.example` to `backend.hcl`
- copy `terraform.tfvars.example` to `terraform.tfvars`
- update values for that environment

### 3. Test locally
Example for dev:

```bash
cd live/dev
terraform init -backend-config=backend.hcl
terraform fmt -recursive
terraform validate
terraform plan -out=tfplan
terraform apply tfplan
```

### 4. Configure GitHub
Create:
- branches: `develop`, `stage`, `main`
- environments: `dev`, `stage`, `prod`

Set environment variables:
- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME`

Set repository secret:
- `INFRACOST_API_KEY`

### 5. Promote changes
- merge into `develop` to deploy dev
- merge `develop` into `stage` to deploy staging
- merge `stage` into `main` to deploy production

## Files Added for Governance

- `.github/CODEOWNERS`
- `.github/pull_request_template.md`
- `docs/GITHUB_PROTECTION_AND_PROMOTION.md`

## Notes

- Do not commit `terraform.tfvars`, `backend.hcl`, state files, or plan files
- Prefer environment-specific IAM roles with least privilege
- For production, use GitHub environment reviewers before allowing the job to proceed
