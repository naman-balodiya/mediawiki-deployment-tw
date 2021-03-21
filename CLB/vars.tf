variable "envname" {
  default = "dev"
}

variable "public_subnet" {
  type = string
}

variable "app_instance_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "clbsg" {
  type = string
}
