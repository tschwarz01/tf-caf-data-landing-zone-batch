locals {
  name               = lower("${var.prefix}-${var.environment}")
  keyVault001Name    = "${local.name}-vault001"
  synapse001Name     = "${local.name}-synapse001"
  dataFactory001Name = "${local.name}-datafactory001"
  cosmosdb001Name    = "${local.name}-cosmos001"
  sql001Name         = "${local.name}-sqlserver001"
  mysql001Name       = "${local.name}-mysql001"
  mariadb001Name     = "${local.name}-mariadb001"
  postgresql001Name  = "${local.name}-postgresql001"

  productResourceGroup     = coalesce(var.lz_resource_groups.targetProductResourceGroup, "rg-${local.name}-datalz-product${random_integer.randomInt.result}-batch")
  integrationResourceGroup = coalesce(var.lz_resource_groups.targetIntegrationResourceGroup, "rg-${local.name}-datalz-integration${random_integer.randomInt.result}-batch")
}

