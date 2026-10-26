locals {
  resource_prefix = "${var.project_name}-${var.environment}"

  common_tags = merge(
    {
      Name        = local.resource_prefix
      Environment = var.environment
      Project     = var.project_name
      Owner       = var.owner
      CostCenter  = var.cost_center
      ManagedBy   = "Terraform"
    },
    var.additional_tags
  )
}
