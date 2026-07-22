variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID where the security group will be created."
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "CIDR block allowed to SSH to the instance."
}

variable "http_allowed_cidr" {
  type        = string
  description = "CIDR block allowed to reach HTTP."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}