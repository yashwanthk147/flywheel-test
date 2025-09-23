variable "project" {
  description = "Project or company prefix"
  type        = string
}

variable "env" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {}


variable "public_subnets" {
  description = "Public subnets map"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}

variable "private_subnets" {
  description = "Private subnets map"
  type = map(object({
    cidr_block        = string
    availability_zone = string
    name              = string
  }))
}