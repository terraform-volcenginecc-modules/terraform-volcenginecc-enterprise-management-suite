# This module provides the isolated VPC, application subnet, and ingress
# boundary for the single-node Odoo Community deployment.

resource "volcenginecc_vpc_vpc" "main" {
  vpc_name     = "${var.resource_prefix}-vpc"
  description  = "Network for the Odoo Community environment"
  cidr_block   = var.vpc_cidr
  enable_ipv_6 = false
  project_name = var.project_name

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}

resource "volcenginecc_vpc_subnet" "application" {
  vpc_id       = volcenginecc_vpc_vpc.main.vpc_id
  subnet_name  = "${var.resource_prefix}-app-subnet"
  description  = "Application subnet for Odoo Community"
  cidr_block   = var.subnet_cidr
  zone_id      = var.zone_id
  enable_ipv_6 = false

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}

# Odoo and PostgreSQL ports remain private to the host. Only the Nginx web
# entry points and a restricted SSH management path are reachable externally.
resource "volcenginecc_vpc_security_group" "application" {
  vpc_id              = volcenginecc_vpc_vpc.main.vpc_id
  security_group_name = "${var.resource_prefix}-app-sg"
  description         = "Restricted ingress for the Odoo Community server"
  project_name        = var.project_name

  depends_on = [volcenginecc_vpc_subnet.application]

  ingress_permissions = [
    {
      description     = "HTTP redirect and health check"
      direction       = "ingress"
      policy          = "accept"
      port_start      = 80
      port_end        = 80
      priority        = 10
      protocol        = "tcp"
      cidr_ip         = "0.0.0.0/0"
      prefix_list_id  = ""
      source_group_id = ""
    },
    {
      description     = "HTTPS Odoo web entry"
      direction       = "ingress"
      policy          = "accept"
      port_start      = 443
      port_end        = 443
      priority        = 20
      protocol        = "tcp"
      cidr_ip         = "0.0.0.0/0"
      prefix_list_id  = ""
      source_group_id = ""
    },
    {
      description     = "SSH from the approved administrator CIDR"
      direction       = "ingress"
      policy          = "accept"
      port_start      = 22
      port_end        = 22
      priority        = 30
      protocol        = "tcp"
      cidr_ip         = var.admin_cidr
      prefix_list_id  = ""
      source_group_id = ""
    }
  ]

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]
}
