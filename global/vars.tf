variable "aws_region" {
  type = string
  default = "us-east-1"
}

variable "state_bucket" {
  type = string
  default = "tw-tf-states-mgmt"
}

variable "state_locks" {
  type = string
  default = "terraform-state-locks"
}

variable "assume_role" {
  type = string
  default = "arn:aws:iam::748566335611:role/TFAssumeRole"
}

variable "assume_role_ext_id" {
  type = string
  default = "29042021"
}
