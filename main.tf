module "network" {
  source = "./modules/network"

  resource_prefix = local.resource_prefix
  vpc_cidr        = var.vpc_cidr
  subnet_cidr     = var.subnet_cidr
  zone_id         = var.zone_id
  admin_cidr      = var.admin_cidr
  project_name    = var.cloud_project_name
  tags            = local.common_tags
}

# Allow the ECS primary ENI and its security-group association to reach a
# stable deleted state before the network module removes the security group.
# Only destroy_duration is set, so normal creation is not delayed.
resource "time_sleep" "before_security_group_destroy" {
  destroy_duration = "60s"

  depends_on = [module.network]
}

module "compute" {
  source = "./modules/compute"

  resource_prefix                  = local.resource_prefix
  vpc_id                           = module.network.vpc_id
  subnet_id                        = module.network.subnet_id
  security_group_id                = module.network.security_group_id
  zone_id                          = var.zone_id
  image_id                         = var.image_id
  instance_type                    = var.ecs_instance_type
  login_mode                       = var.ecs_login_mode
  key_pair_name                    = var.key_pair_name
  password                         = var.ecs_password
  system_volume_type               = var.ecs_system_volume_type
  system_volume_size_gb            = var.ecs_system_volume_size_gb
  data_volume_type                 = var.ecs_data_volume_type
  data_volume_size_gb              = var.ecs_data_volume_size_gb
  data_volume_delete_with_instance = var.data_volume_delete_with_instance
  eip_bandwidth_mbps               = var.eip_bandwidth_mbps
  odoo_version                     = var.odoo_version
  odoo_package_url                 = var.odoo_package_url
  odoo_package_sha256              = var.odoo_package_sha256
  timezone                         = var.timezone
  project_name                     = var.cloud_project_name
  tags                             = local.common_tags

  depends_on = [time_sleep.before_security_group_destroy]
}
