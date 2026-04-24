# GitHub Protection and Promotion Guidance

## Objective

This repository is designed for controlled promotion of Terraform changes through:

- development
- staging
- production

The goal is to make promotion intentional, reviewable, and environment-specific.

## Branch Model

Use these long-lived branches:

- `develop` for dev
- `stage` for staging
- `main` for production

### Promotion Path

Only promote in this order:

- `develop -> stage`
- `stage -> main`

Do not skip environments for normal changes.

## GitHub Branch Protection Recommendations

### Protect `develop`
- Require pull request before merge
- Require at least 1 approval
- Require conversation resolution
- Require status checks to pass
- Dismiss stale approvals
- Prevent force pushes and branch deletion

### Protect `stage`
- Require pull request before merge
- Require at least 2 approvals
- Require status checks to pass
- Restrict who can push
- Require linear history
- Prevent force pushes and branch deletion

### Protect `main`
- Require pull request before merge
- Require CODEOWNERS review
- Require 2-3 approvals
- Require status checks to pass
- Require conversation resolution
- Require signed commits if applicable
- Prevent force pushes and branch deletion

## GitHub Environment Recommendations

Create three environments:

- `dev`
- `stage`
- `prod`

For each environment, define:

- `AWS_REGION`
- `AWS_ROLE_TO_ASSUME`

### Extra controls by environment

#### dev
- No required reviewers, or a lightweight reviewer model

#### stage
- Optional required reviewer from platform or infrastructure team

#### prod
- Required reviewers enabled
- Optional wait timer
- Restrict deployment branches to `main`

## Suggested Status Checks

Require these checks on protected branches:

- `validate-dev`
- `validate-stage`
- `validate-prod`

You may also require drift workflow success if you adopt that as a control signal.

## CODEOWNERS Guidance

The included `CODEOWNERS` file routes review of:

- GitHub workflows
- Terraform modules
- production live configuration

Update it to reflect your actual team handles.

## Pull Request Guidance

Use the included PR template to document:

- environment impact
- rollback plan
- risk
- validation evidence
- promotion target

## Promotion Operating Model

### Feature to Dev
1. Developer branches from `develop`
2. PR opened into `develop`
3. Validation runs
4. Merge to `develop`
5. Dev apply workflow runs

### Dev to Stage
1. Open PR from `develop` to `stage`
2. Validate
3. Confirm dev testing complete
4. Merge to `stage`
5. Stage apply workflow runs

### Stage to Prod
1. Open PR from `stage` to `main`
2. Validate
3. Obtain prod approvals
4. Merge to `main`
5. Prod apply workflow runs after GitHub environment approval

## Rollback Guidance

- Revert the merge commit on the destination branch
- Open PR for the revert if branch protections require it
- Let the environment workflow apply the reverted Terraform configuration

## Important Cautions

- Keep production access least-privileged
- Do not allow shared admin roles across all environments unless explicitly intended
- Do not enable automatic production deployment from feature branches