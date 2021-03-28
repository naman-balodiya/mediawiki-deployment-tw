
variable "envname" {
  type = string
}

variable "public_subnet" {
  type = string
}

variable "app_instances" {
  type    = string
  default = "2"
}

variable "dev_allowed_cidrs" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

variable "vpc_id" {
  type = string
}

variable "instance_type" {
  default = "t2.micro"
}

variable "ami_id" {
  default = "ami-096fda3c22c1c990a"
}

variable "deployment_script" {
  type = string
}
