variable "project" {
  type        = string
  description = "Project name prefix"
}

variable "env" {
  type        = string
  description = "Environment name (e.g. dev, qa, prod)"
}

variable "db_name" {
  type        = string
  description = "Postgres database name"
}

variable "db_username" {
  type        = string
  description = "Master DB username"
}

variable "db_password" {
  type        = string
  description = "Master DB password"
  sensitive   = true
}
