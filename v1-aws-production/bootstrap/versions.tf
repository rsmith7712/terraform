# 3) Bootstrap phase
#
# This phase creates the S3 bucket and DynamoDB table that Terraform
# will use for remote state and locking. S3 versioning and SSE are
# recommended best practices for state storage, and DynamoDB locking
# prevents concurrent state mutation. :contentReference[oaicite:5]{index=5}
#
## `bootstrap/versions.tf`

terraform {
  required_version = ">= 1.6.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}