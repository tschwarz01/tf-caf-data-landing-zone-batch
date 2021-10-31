data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "keyVault" {
  name                        = var.keyVault001Name
  location                    = var.location
  resource_group_name         = var.rgName
  enabled_for_disk_encryption = false
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
  purge_protection_enabled    = false
  enable_rbac_authorization   = true

  sku_name = "standard"
  network_acls {
    bypass         = "AzureServices"
    default_action = "Deny"
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "keyVaultPrivateEndpoint" {
  name                = "${var.name}-${azurerm_key_vault.keyVault.name}-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_key_vault.keyVault.name}-private-endpoint-connection"
    private_connection_resource_id = azurerm_key_vault.keyVault.id
    subresource_names              = ["vault"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdKeyVault]
  }
}
