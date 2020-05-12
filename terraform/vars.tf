variable "project" {
  description = "Project name"
  type        = string
}

variable "stage" {
  description = "Project stage e.g. prod"
  type        = string
}

variable "region" {
  description = "AWS Region e.g. eu-central-1"
  type        = string
}

variable "domain" {
  description = "Base domain for the project e.g. example.com"
  type        = string
}