# main.tf
# Root module: wires the VPC and EC2 modules together.

# Auto-detect this machine's public IP so SSH can be restricted to it.
data "http" "my_ip" {
  url = "https://checkip.amazonaws.com"
}

# Used to pick a default Availability Zone when one isn't specified.
data "aws_availability_zones" "available" {
  state = "available"
}

locals {
  # Lock SSH to the caller's IP unless an explicit CIDR was provided.
  ssh_cidr = var.allowed_ssh_cidr != "" ? var.allowed_ssh_cidr : "${chomp(data.http.my_ip.response_body)}/32"

  # Use the first available AZ when none is provided.
  availability_zone = var.availability_zone != "" ? var.availability_zone : data.aws_availability_zones.available.names[0]
}

module "vpc" {
  source = "./modules/vpc"

  project_name       = var.project_name
  vpc_cidr           = var.vpc_cidr
  public_subnet_cidr = var.public_subnet_cidr
  availability_zone  = local.availability_zone
}

module "ec2" {
  source = "./modules/ec2"

  project_name     = var.project_name
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_id
  instance_type    = var.instance_type
  allowed_ssh_cidr = local.ssh_cidr
  key_name         = var.key_name
}
