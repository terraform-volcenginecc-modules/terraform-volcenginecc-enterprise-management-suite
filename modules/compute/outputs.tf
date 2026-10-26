output "instance_id" {
  description = "ID of the Odoo ECS instance."
  value       = volcenginecc_ecs_instance.odoo.instance_id
}

output "private_ip" {
  description = "Primary private IP address of the Odoo ECS instance."
  value       = volcenginecc_ecs_instance.odoo.primary_network_interface.primary_ip_address
}

output "public_ip" {
  description = "Public IP address attached to the Odoo ECS instance."
  value       = volcenginecc_ecs_instance.odoo.eip_address.ip_address
}

output "data_volume_id" {
  description = "ID of the data volume used by PostgreSQL and the Odoo filestore."
  value       = volcenginecc_ecs_instance.odoo.data_volumes[0].volume_id
}
