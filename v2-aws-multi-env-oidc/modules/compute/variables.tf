variable "project_name" {
  type        = string
  description = "Project name prefix."
}

variable "ami_id" {
  type        = string
  description = "AMI ID for the EC2 instance."
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type."
}

variable "subnet_id" {
  type        = string
  description = "Subnet ID for the EC2 instance."
}

variable "security_group_id" {
  type        = string
  description = "Security group ID to attach to the EC2 instance."
}

variable "key_name" {
  type        = string
  description = "Optional EC2 key pair name."
  default     = null
}

variable "associate_public_ip_address" {
  type        = bool
  description = "Whether to associate a public IP address."
  default     = true
}

variable "user_data" {
  type        = string
  description = "User data script."
  default     = ""
}

variable "tags" {
  type        = map(string)
  description = "Common tags."
  default     = {}
}
