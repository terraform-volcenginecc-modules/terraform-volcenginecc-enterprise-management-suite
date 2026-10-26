output "vpc_id" {
  description = "ID of the Odoo VPC."
  value       = volcenginecc_vpc_vpc.main.vpc_id
}

output "subnet_id" {
  description = "ID of the Odoo application subnet."
  value       = volcenginecc_vpc_subnet.application.subnet_id
}

output "security_group_id" {
  description = "ID of the Odoo ECS security group."
  value       = volcenginecc_vpc_security_group.application.security_group_id
}
