# modules/ec2/variables.tf

variable "project_name" {
  description = "Name prefix for EC2 resources."
  type        = string
}

variable "vpc_id" {
  description = "VPC in which to create the security group."
  type        = string
}

variable "subnet_id" {
  description = "Subnet in which to launch the instance."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to access SSH (port 22)."
  type        = string
}

variable "key_name" {
  description = "Existing EC2 key pair name. Empty = launch without a key pair."
  type        = string
  default     = ""
}
