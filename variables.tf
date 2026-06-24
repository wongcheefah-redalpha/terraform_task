# variables.tf
# Root-level input variables. Override via terraform.tfvars or -var flags.

variable "project_name" {
  description = "Name prefix applied to all resources for easy identification."
  type        = string
  default     = "tf-task"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet."
  type        = string
  default     = "10.0.1.0/24"
}

variable "availability_zone" {
  description = "Availability Zone for the public subnet. Empty = first available AZ in the region."
  type        = string
  default     = ""
}

variable "instance_type" {
  description = "EC2 instance type (t2.micro is free-tier eligible)."
  type        = string
  default     = "t2.micro"
}

variable "allowed_ssh_cidr" {
  description = "CIDR allowed to reach SSH (port 22). Empty = auto-detect this machine's public IP as a /32."
  type        = string
  default     = ""
}

variable "key_name" {
  description = "Name of an existing EC2 key pair to enable SSH login. Empty = launch without a key pair."
  type        = string
  default     = ""
}
