variable "region" {
  type    = string
  default = "us-east-1"
}

variable "db_password" {
  type      = string
  sensitive = true
}

variable "vpc_cidr" {
  default = "10.0.0.0/16"
}
