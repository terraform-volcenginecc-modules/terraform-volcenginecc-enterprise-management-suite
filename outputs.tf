output "vpc_id" {
  description = "ID of the VPC used by the Odoo ECS instance."
  value       = module.network.vpc_id
}

output "subnet_id" {
  description = "ID of the subnet used by the Odoo ECS instance."
  value       = module.network.subnet_id
}

output "security_group_id" {
  description = "ID of the security group used by the Odoo ECS instance."
  value       = module.network.security_group_id
}

output "odoo_url" {
  description = "Public HTTPS URL for Odoo. The initial certificate is self-signed and must be replaced for production."
  value       = "https://${module.compute.public_ip}/"
}

output "health_check_url" {
  description = "Public health-check URL exposed by Nginx."
  value       = "https://${module.compute.public_ip}/healthz"
}

output "ecs_instance_id" {
  description = "ID of the Odoo ECS instance."
  value       = module.compute.instance_id
}

output "ecs_private_ip" {
  description = "Private IP address of the Odoo ECS instance."
  value       = module.compute.private_ip
}

output "ecs_public_ip" {
  description = "Public IP address of the Odoo ECS instance."
  value       = module.compute.public_ip
}

output "data_volume_id" {
  description = "ID of the data volume containing PostgreSQL data and the Odoo filestore."
  value       = module.compute.data_volume_id
}

output "initialization_status_command" {
  description = "Command used after SSH login to inspect cloud-init and application status."
  value       = "sudo cloud-init status --wait || true; sudo /usr/local/sbin/odoo-status"
}

output "initial_admin_credentials_command" {
  description = "Command used on ECS to read the runtime-generated initial Odoo administrator credentials."
  value       = "sudo /usr/local/sbin/odoo-credentials"
}
