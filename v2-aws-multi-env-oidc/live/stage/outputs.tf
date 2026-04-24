output "vpc_id" {
  description = "VPC ID."
  value       = module.network.vpc_id
}

output "public_subnet_id" {
  description = "Public subnet ID."
  value       = module.network.public_subnet_id
}

output "instance_id" {
  description = "EC2 instance ID."
  value       = module.compute.instance_id
}

output "instance_public_ip" {
  description = "EC2 public IP."
  value       = module.compute.public_ip
}

output "instance_private_ip" {
  description = "EC2 private IP."
  value       = module.compute.private_ip
}
