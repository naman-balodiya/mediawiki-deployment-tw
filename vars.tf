variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "AZ" {
  type    = string
  default = "us-east-1a"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/27"
}

variable "public_subnet" {
  type    = string
  default = "10.0.0.0/28"
}

variable "private_subnet" {
  type    = string
  default = "10.0.0.16/28"
}

variable "envname" {
  default = "dev"
}

variable "app_instances" {
  type    = string
  default = "2"
}

variable "dev_cidrs" {
  type = list(string)
  default = [
    "0.0.0.0/0"
  ]
}

variable "instance_type" {
  default = "t2.micro"
}
variable "ami_id" {
  default = "ami-096fda3c22c1c990a"
}

variable "deployment_scripts_bucket" {
  default = "tw-deployment-scripts-bucket"
}
