terraform {
  required_version = ">=0.12"
  backend "s3" {
    bucket = "tw-tf-states-mgmt"
    key    = "global/s3/terraform.state"
    region = "us-east-1"
    # role_arn = "arn:aws:iam::748566335611:role/TFAssumeRole"
    # external_id = "29042021"

    dynamodb_table = "terraform-state-locks"
    encrypt        = true
  }
}
