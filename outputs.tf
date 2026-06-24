# outputs.tf
# Values printed after a successful `terraform apply`.

output "instance_public_ip" {
  description = "Public IP address of the deployed EC2 instance."
  value       = module.ec2.public_ip
}

output "instance_id" {
  description = "ID of the deployed EC2 instance."
  value       = module.ec2.instance_id
}

output "vpc_id" {
  description = "ID of the created VPC."
  value       = module.vpc.vpc_id
}

output "public_subnet_id" {
  description = "ID of the public subnet."
  value       = module.vpc.public_subnet_id
}

output "ssh_allowed_from" {
  description = "CIDR permitted to reach SSH (port 22)."
  value       = local.ssh_cidr
}
