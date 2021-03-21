/**************************************************
CMP Terraform boot file
Written by Naman Balodiya | namanbalodiya@gmail.com

This project should only be executed once

*Note : configuration is vars.tf and not main.tf
----------------------------------------------------------
*********************************************************/
provider "aws" {
  region = var.aws_region
  # assume_role {
  #   role_arn = var.assume_role
  #   external_id = var.assume_role_ext_id
  #   session_name = "TERRAFORM_MASTER_SESSION"
  # }
}

resource "aws_s3_bucket" "terraform_state" {
  bucket = var.state_bucket

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }
}

resource "aws_dynamodb_table" "terraform_locks" {
  hash_key = "LockID"
  name = var.state_locks
  billing_mode = "PAY_PER_REQUEST"
  attribute {
    name = "LockID"
    type = "S"
  }
}
