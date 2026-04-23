variable "aws_region" {
  type        = string
  description = "AWS region for the backend resources."
}

variable "state_bucket_name" {
  type        = string
  description = "Globally unique S3 bucket name for Terraform remote state."
}

variable "lock_table_name" {
  type        = string
  description = "DynamoDB table name used for Terraform state locking."
}

variable "tags" {
  type        = map(string)
  description = "Common tags applied to backend resources."
  default     = {}
}