# provider.tf
# Defines the cloud provider and region for this Terraform configuration.

terraform {
  required_version = ">= 1.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    # Used to auto-detect this machine's public IP so SSH can be locked to it.
    http = {
      source  = "hashicorp/http"
      version = "~> 3.4"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = var.aws_region
}

variable "aws_region" {
  description = "The AWS region to deploy resources into."
  type        = string
  default     = "ap-southeast-1"
}
