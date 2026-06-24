# backend.tf
# Stores Terraform state remotely in S3 with DynamoDB-based state locking.
#
# NOTE: backend blocks cannot reference variables or locals, so these values
# are hardcoded. The bucket and lock table are defined in state-backend.tf and
# must already exist before running `terraform init` against this backend.

terraform {
  backend "s3" {
    bucket         = "tf-task-tfstate-224848431296"
    key            = "day3/terraform_task/terraform.tfstate"
    region         = "ap-southeast-1"
    dynamodb_table = "tf-task-tflock"
    encrypt        = true
  }
}
