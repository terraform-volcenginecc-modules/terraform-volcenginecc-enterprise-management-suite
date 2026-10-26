# This module provisions one public ECS instance, a persistent data volume,
# and the idempotent Odoo Community runtime bootstrap.

locals {
  bootstrap_script = templatefile("${path.module}/templates/odoo-bootstrap-native.sh.tftpl", {
    odoo_version        = var.odoo_version
    odoo_package_url    = var.odoo_package_url
    odoo_package_sha256 = var.odoo_package_sha256
    timezone            = var.timezone
  })
}

resource "volcenginecc_ecs_instance" "odoo" {
  instance_name             = "${var.resource_prefix}-app"
  hostname                  = "${var.resource_prefix}-app"
  description               = "Odoo Community, PostgreSQL, and Nginx application host"
  instance_type             = var.instance_type
  instance_charge_type      = "PostPaid"
  spot_strategy             = "NoSpot"
  zone_id                   = var.zone_id
  project_name              = var.project_name
  deletion_protection       = false
  install_run_command_agent = false

  image = {
    image_id              = var.image_id
    keep_image_credential = false
  }

  password = var.login_mode == "password" ? var.password : null

  key_pair = var.login_mode == "key_pair" ? {
    key_pair_name = var.key_pair_name
  } : null

  primary_network_interface = {
    subnet_id           = var.subnet_id
    vpc_id              = var.vpc_id
    security_group_ids  = [var.security_group_id]
    ipv_6_address_count = 0
  }

  system_volume = {
    volume_type          = var.system_volume_type
    size                 = var.system_volume_size_gb
    delete_with_instance = true
  }

  # The provider requires complete nested data-volume input to avoid read-back
  # drift. Null values explicitly select the baseline performance tier.
  data_volumes = [
    {
      volume_type                     = var.data_volume_type
      size                            = var.data_volume_size_gb
      delete_with_instance            = var.data_volume_delete_with_instance
      snapshot_id                     = null
      extra_performance_type_id       = null
      extra_performance_iops          = null
      extra_performance_throughput_mb = null
    }
  ]

  eip_address = {
    charge_type           = "PayByTraffic"
    bandwidth_mbps        = var.eip_bandwidth_mbps
    isp                   = "BGP"
    release_with_instance = true
    bandwidth_package_id  = ""
  }

  user_data = base64gzip(replace(local.bootstrap_script, "\r\n", "\n"))

  tags = [
    for key, value in var.tags : {
      key   = key
      value = value
    }
  ]

  lifecycle {
    precondition {
      condition = (
        (
          var.login_mode == "key_pair" &&
          var.key_pair_name != null &&
          nonsensitive(var.password == null)
        ) ||
        (
          var.login_mode == "password" &&
          var.key_pair_name == null &&
          nonsensitive(var.password != null)
        )
      )
      error_message = "ECS credentials are mutually exclusive: key_pair mode requires key_pair_name and no password; password mode requires password and no key_pair_name."
    }
  }
}
