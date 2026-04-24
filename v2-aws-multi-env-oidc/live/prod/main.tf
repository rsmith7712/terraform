locals {
  tags = merge(
    var.common_tags,
    {
      Project     = var.project_name
      Environment = var.environment
      ManagedBy   = "Terraform"
    }
  )
}

module "network" {
  source = "../../modules/network"

  project_name       = "${var.project_name}-${var.environment}"
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = var.availability_zone
  tags               = local.tags
}

module "security_group" {
  source = "../../modules/security-group"

  project_name      = "${var.project_name}-${var.environment}"
  vpc_id            = module.network.vpc_id
  ssh_allowed_cidr  = var.ssh_allowed_cidr
  http_allowed_cidr = var.http_allowed_cidr
  tags              = local.tags
}

module "compute" {
  source = "../../modules/compute"

  project_name                = "${var.project_name}-${var.environment}"
  ami_id                      = var.ami_id
  instance_type               = var.instance_type
  subnet_id                   = module.network.public_subnet_id
  security_group_id           = module.security_group.security_group_id
  key_name                    = var.key_name
  associate_public_ip_address = true
  tags                        = local.tags

  user_data = <<-EOF_USER_DATA
              #!/bin/bash
              yum update -y
              yum install -y httpd
              systemctl enable httpd
              systemctl start httpd
              echo "<h1>Deployed via Terraform and GitHub Actions (${var.environment})</h1>" > /var/www/html/index.html
              EOF_USER_DATA
}

/*
Optional future Application Load Balancer example.
Leave commented until you are ready to add:
- two public subnets in different AZs
- dedicated ALB security group
- target group
- listener
- health checks

resource "aws_lb" "app" {
  name               = "${var.project_name}-${var.environment}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [module.security_group.security_group_id]
  subnets            = [module.network.public_subnet_id]

  tags = local.tags
}
*/
