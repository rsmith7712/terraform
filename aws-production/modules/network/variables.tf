variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "vpc_cidr" {
  type        = string
  description = "CIDR block for the VPC."
}

variable "public_subnet_cidr" {
  type        = string
  description = "CIDR block for the public subnet."
}

variable "availability_zone" {
  type        = string
  description = "Availability zone for the public subnet."
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}