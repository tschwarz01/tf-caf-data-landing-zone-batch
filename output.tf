output "keyvaultId" {
  value = module.keyVault001.keyVaultId
}

output "product_resource_group" {
  value = local.productResourceGroup
}

output "integration_resource_group" {
  value = local.integrationResourceGroup
}
