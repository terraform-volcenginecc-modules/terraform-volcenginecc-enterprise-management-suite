variable "region" {
  description = "Volcengine region in which to create the Odoo environment."
  type        = string
  default     = "cn-beijing"
}

variable "zone_id" {
  description = "Availability zone for the subnet and ECS instance."
  type        = string

  validation {
    condition     = can(regex("^[a-z]{2}-[a-z0-9-]+-[a-z]$", var.zone_id))
    error_message = "zone_id must use a valid availability-zone format such as cn-beijing-a."
  }
}

variable "project_name" {
  description = "Short project identifier used in resource names and tags."
  type        = string
  default     = "odoo"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{2,19}$", var.project_name))
    error_message = "project_name must start with a lowercase letter and contain 3-20 lowercase letters, digits, or hyphens."
  }
}

variable "environment" {
  description = "Deployment environment identifier."
  type        = string
  default     = "demo"

  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{1,9}$", var.environment))
    error_message = "environment must start with a lowercase letter and contain 2-10 lowercase letters, digits, or hyphens."
  }
}

variable "owner" {
  description = "Owner tag applied to supported resources."
  type        = string

  validation {
    condition     = length(trimspace(var.owner)) > 0
    error_message = "owner must not be empty."
  }
}

variable "cost_center" {
  description = "Cost center tag applied to supported resources."
  type        = string
  default     = "shared"
}

variable "cloud_project_name" {
  description = "Volcengine project to which supported resources belong."
  type        = string
  default     = "default"
}

variable "vpc_cidr" {
  description = "IPv4 CIDR block for the Odoo VPC."
  type        = string
  default     = "10.30.0.0/16"

  validation {
    condition     = can(cidrnetmask(var.vpc_cidr))
    error_message = "vpc_cidr must be a valid IPv4 CIDR block."
  }
}

variable "subnet_cidr" {
  description = "IPv4 CIDR block for the application subnet."
  type        = string
  default     = "10.30.1.0/24"

  validation {
    condition     = can(cidrnetmask(var.subnet_cidr))
    error_message = "subnet_cidr must be a valid IPv4 CIDR block."
  }
}

variable "admin_cidr" {
  description = "IPv4 CIDR allowed to connect to ECS over SSH. Restrict this value for persistent deployments."
  type        = string

  validation {
    condition     = can(cidrnetmask(var.admin_cidr))
    error_message = "admin_cidr must be a valid IPv4 CIDR."
  }
}

variable "image_id" {
  description = "Ubuntu 24.04 public image ID available in the selected region."
  type        = string

  validation {
    condition     = can(regex("^image-[a-z0-9]+$", var.image_id))
    error_message = "image_id must be a Volcengine image ID such as image-abc123."
  }
}

variable "ecs_instance_type" {
  description = "ECS instance type available in the selected availability zone. Four vCPUs and 8 GiB memory are recommended."
  type        = string
  default     = "ecs.g4i.xlarge"
}

variable "ecs_login_mode" {
  description = "ECS login credential mode. Valid values are key_pair and password."
  type        = string
  default     = "key_pair"

  validation {
    condition     = contains(["key_pair", "password"], var.ecs_login_mode)
    error_message = "ecs_login_mode must be either key_pair or password."
  }
}

variable "key_pair_name" {
  description = "Name of an existing ECS SSH key pair. Required only when ecs_login_mode is key_pair."
  type        = string
  default     = null
  nullable    = true

  validation {
    condition     = var.key_pair_name == null ? true : length(trimspace(var.key_pair_name)) > 0
    error_message = "key_pair_name must be null or a non-empty ECS key pair name."
  }
}

variable "ecs_password" {
  description = "Initial ECS administrator password. The default is for demonstrations only; it is stored in Terraform state."
  type        = string
  default     = "ReplaceWithStrongPassword123"
  nullable    = true
  sensitive   = true

  validation {
    condition = var.ecs_password == null ? true : (
      length(var.ecs_password) >= 8 &&
      length(var.ecs_password) <= 30 &&
      (
        (length(regexall("[A-Z]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[a-z]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[0-9]", var.ecs_password)) > 0 ? 1 : 0) +
        (length(regexall("[^A-Za-z0-9]", var.ecs_password)) > 0 ? 1 : 0)
      ) >= 3 &&
      can(regex("^[A-Za-z0-9`~!@#$%^&*()_+={}\\[\\]:;'<>,.?/|\\-]+$", var.ecs_password)) &&
      !startswith(var.ecs_password, "/") &&
      !startswith(var.ecs_password, "$6$")
    )
    error_message = "ecs_password must be 8-30 characters, contain at least three character types, use only ECS-supported characters, and not start with / or $6$."
  }
}

variable "ecs_system_volume_type" {
  description = "ECS system volume type supported by the selected instance type."
  type        = string
  default     = "ESSD_FlexPL"
}

variable "ecs_system_volume_size_gb" {
  description = "ECS system volume size in GiB."
  type        = number
  default     = 40

  validation {
    condition     = var.ecs_system_volume_size_gb >= 40
    error_message = "ecs_system_volume_size_gb must be at least 40 GiB."
  }
}

variable "ecs_data_volume_type" {
  description = "Data volume type used for PostgreSQL and the Odoo filestore."
  type        = string
  default     = "ESSD_FlexPL"
}

variable "ecs_data_volume_size_gb" {
  description = "Data volume size in GiB for PostgreSQL, the filestore, add-ons, and local backups."
  type        = number
  default     = 100

  validation {
    condition     = var.ecs_data_volume_size_gb >= 40
    error_message = "ecs_data_volume_size_gb must be at least 40 GiB."
  }
}

variable "data_volume_delete_with_instance" {
  description = "Whether the Odoo data volume is deleted with ECS. Keep true for complete Terraform destroy; back up business data before destruction."
  type        = bool
  default     = true
}

variable "eip_bandwidth_mbps" {
  description = "Maximum public bandwidth of the ECS public IP in Mbps."
  type        = number
  default     = 10

  validation {
    condition     = var.eip_bandwidth_mbps >= 1 && var.eip_bandwidth_mbps <= 200
    error_message = "eip_bandwidth_mbps must be between 1 and 200."
  }
}

variable "odoo_version" {
  description = "Odoo Community major release installed during ECS bootstrap."
  type        = string
  default     = "19.0"

  validation {
    condition     = can(regex("^[0-9]+\\.[0-9]+$", var.odoo_version))
    error_message = "odoo_version must be a major release such as 19.0."
  }
}

variable "odoo_package_url" {
  description = "Pinned HTTPS URL of the Odoo Community DEB downloaded by aria2."
  type        = string
  default     = "https://nightly.odoocdn.com/19.0/nightly/deb/odoo_19.0.20261018_all.deb"

  validation {
    condition     = can(regex("^https://[^[:space:]]+\\.deb$", var.odoo_package_url))
    error_message = "odoo_package_url must be an HTTPS URL ending in .deb."
  }
}

variable "odoo_package_sha256" {
  description = "SHA256 digest of the pinned Odoo Community DEB."
  type        = string
  default     = "2966e651382c7c7796b7080f35f5907eea2ee50767cbaae9c1ba0909981fdda1"

  validation {
    condition     = can(regex("^[0-9a-f]{64}$", var.odoo_package_sha256))
    error_message = "odoo_package_sha256 must contain exactly 64 lowercase hexadecimal characters."
  }
}

variable "timezone" {
  description = "IANA timezone configured on the ECS host."
  type        = string
  default     = "Asia/Shanghai"

  validation {
    condition     = can(regex("^[A-Za-z_+-]+(?:/[A-Za-z0-9_+-]+)+$", var.timezone))
    error_message = "timezone must be a valid IANA-style timezone such as Asia/Shanghai."
  }
}

variable "additional_tags" {
  description = "Additional tags merged with the standard project tags."
  type        = map(string)
  default     = {}
}
