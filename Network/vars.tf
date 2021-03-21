variable "vpc_cidr" {
  type = string
}

variable "AZ" {
  type = list(string)
}

variable "envname" {
  type = string
}
variable "public_cidr" {
  type = string
}

variable "private_cidr" {
  type = string
}
