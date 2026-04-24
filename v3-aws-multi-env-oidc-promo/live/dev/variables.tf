variable "aws_region" {
  type        = string
  description = "AWS region for deployment."
}

variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "environment" {
  type        = string
  description = "Environment name."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the public subnet."
}

variable "vpc_cidr" {
  type        = string
  description = "VPC CIDR block."
}

variable "public_subnet_cidr" {
  type        = string
  description = "Public subnet CIDR block."
}

variable "ssh_allowed_cidr" {
  type        = string
  description = "CIDR allowed to SSH."
}

variable "http_allowed_cidr" {
  type        = string
  description = "CIDR allowed to HTTP."
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name."
  default     = null
}

variable "common_tags" {
  type        = map(string)
  description = "Common tags applied to all resources."
  default     = {}
}
