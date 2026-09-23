variable "db_name" {
  type    = string
  default = "project1"
}

variable "db_user" {
  type    = string
  default = "project1"
}

variable "db_password" {
  type      = string
  sensitive = true
}