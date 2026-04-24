# Changelog

## 2026-04-23
### Added
- Third variant tailored for GitHub environment-specific protections and explicit promotion flow
- Branching model guidance for `develop -> stage -> main`
- Separate apply workflows for dev, stage, and prod
- CODEOWNERS and pull request template
- Dedicated GitHub protection and promotion guidance document

### Retained
- AWS Terraform starter with bootstrap backend and OIDC-only GitHub Actions
- Multi-environment layout for dev, stage, and prod
- Reusable modules for network, security groups, and compute
- PR validation workflow with Checkov and Infracost
- Scheduled drift detection workflow per environment
- Manual destroy workflow with environment selection
