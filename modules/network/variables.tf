variable "resource_prefix" {
  description = "Prefix used for network resource names."
  type        = string
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block of the VPC."
  type        = string
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block of the application subnet."
  type        = string
}

variable "zone_id" {
  description = "Availability zone in which to create the subnet."
  type        = string
}

variable "admin_cidr" {
  description = "Trusted IPv4 CIDR allowed to access SSH."
  type        = string
}

variable "project_name" {
  description = "Volcengine project name."
  type        = string
}

variable "tags" {
  description = "Tags applied to supported network resources."
  type        = map(string)
}
