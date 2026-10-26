region  = "cn-beijing"
zone_id = "cn-beijing-a"

project_name       = "odoo"
environment        = "demo"
owner              = "platform-team"
cost_center        = "shared"
cloud_project_name = "default"

vpc_cidr    = "10.30.0.0/16"
subnet_cidr = "10.30.1.0/24"

# Replace this value with an approved management CIDR before deploying a
# persistent environment.
admin_cidr = "0.0.0.0/0"

# ECS login credentials are mutually exclusive. The default one-command
# configuration uses the demonstration password declared in variables.tf.
# For key-pair mode, set key_pair_name and explicitly set ecs_password to null.
ecs_login_mode = "password"
key_pair_name  = null
ecs_password   = "YourStrongPassword123!"

# Ubuntu 24.04 LTS 64-bit public image in cn-beijing.
# Replace this value when deploying to another region.
image_id = "image-ydf193g9cqb6uoeqqqj8"

ecs_instance_type       = "ecs.g4i.xlarge"
eip_bandwidth_mbps      = 10
ecs_data_volume_size_gb = 100

additional_tags = {
  Purpose = "OdooCommunityDemo"
}
