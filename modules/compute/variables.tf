variable "resource_prefix" {
  description = "Prefix used for compute resource names."
  type        = string
}

variable "vpc_id" {
  description = "ID of the VPC containing ECS."
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet containing ECS."
  type        = string
}

variable "security_group_id" {
  description = "ID of the security group attached to ECS."
  type        = string
}

variable "zone_id" {
  description = "Availability zone for ECS."
  type        = string
}

variable "image_id" {
  description = "Ubuntu 24.04 public image ID."
  type        = string
}

variable "instance_type" {
  description = "ECS instance type."
  type        = string
}

variable "login_mode" {
  description = "ECS login credential mode."
  type        = string

  validation {
    condition     = contains(["key_pair", "password"], var.login_mode)
    error_message = "login_mode must be either key_pair or password."
  }
}

variable "key_pair_name" {
  description = "Name of an existing ECS SSH key pair when login_mode is key_pair."
  type        = string
  nullable    = true
}

variable "password" {
  description = "Initial ECS administrator password when login_mode is password. This value is stored in Terraform state."
  type        = string
  nullable    = true
  sensitive   = true
}

variable "system_volume_type" {
  description = "ECS system volume type."
  type        = string
}

variable "system_volume_size_gb" {
  description = "ECS system volume size in GiB."
  type        = number
}

variable "data_volume_type" {
  description = "Data volume type for PostgreSQL and the Odoo filestore."
  type        = string
}

variable "data_volume_size_gb" {
  description = "Data volume size in GiB."
  type        = number
}

variable "data_volume_delete_with_instance" {
  description = "Whether the data volume is deleted with ECS."
  type        = bool
}

variable "eip_bandwidth_mbps" {
  description = "Maximum public bandwidth in Mbps."
  type        = number
}

variable "odoo_version" {
  description = "Odoo Community major release installed during bootstrap."
  type        = string
}

variable "odoo_package_url" {
  description = "Pinned HTTPS URL of the Odoo Community DEB."
  type        = string
}

variable "odoo_package_sha256" {
  description = "SHA256 digest of the pinned Odoo Community DEB."
  type        = string
}

variable "timezone" {
  description = "IANA timezone configured on the ECS host."
  type        = string
}

variable "project_name" {
  description = "Volcengine project name."
  type        = string
}

variable "tags" {
  description = "Tags applied to the ECS instance."
  type        = map(string)
}
