# state-backend.tf
# Infrastructure that backs the remote Terraform state:
#   - S3 bucket      -> stores the state file (versioned + encrypted + private)
#   - DynamoDB table -> provides state locking (LockID primary key)
#
# Chicken-and-egg note: these resources must EXIST before the S3 backend in
# backend.tf can be initialized. They are therefore created first with the
# default local backend, after which `terraform init -migrate-state` moves the
# state into S3.

locals {
  state_bucket_name = "tf-task-tfstate-224848431296"
  state_lock_table  = "tf-task-tflock"
}

resource "aws_s3_bucket" "tfstate" {
  bucket = local.state_bucket_name

  tags = {
    Name = "${var.project_name}-tfstate"
  }
}

# Keep a full history of every state revision so it can be recovered.
resource "aws_s3_bucket_versioning" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  versioning_configuration {
    status = "Enabled"
  }
}

# Encrypt the state at rest (it can contain sensitive values).
resource "aws_s3_bucket_server_side_encryption_configuration" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm = "AES256"
    }
  }
}

# Lock the bucket down: no public access of any kind.
resource "aws_s3_bucket_public_access_block" "tfstate" {
  bucket = aws_s3_bucket.tfstate.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

# DynamoDB table Terraform uses to acquire a lock during state-mutating ops.
resource "aws_dynamodb_table" "tflock" {
  name         = local.state_lock_table
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "LockID"

  attribute {
    name = "LockID"
    type = "S"
  }

  tags = {
    Name = "${var.project_name}-tflock"
  }
}
