locals {
  keyVault001Name = element(split("/", var.keyVault001Id), length(split("/", var.keyVault001Id)) - 1)
}

resource "azurerm_data_factory" "dataFactory" {
  name                            = var.dataFactoryName
  location                        = var.location
  resource_group_name             = var.rgName
  public_network_enabled          = false
  tags                            = var.tags
  managed_virtual_network_enabled = true
  identity {
    type = "SystemAssigned"
  }
}


resource "azurerm_private_endpoint" "data_factory_private_endpoint" {
  name                = "${var.name}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_data_factory.dataFactory.name}-adf-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["dataFactory"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactory]
  }
}

resource "azurerm_private_endpoint" "data_factory_portal_private_endpoint" {
  name                = "${var.name}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_data_factory.dataFactory.name}-adf-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_data_factory.dataFactory.id
    subresource_names              = ["portal"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDataFactoryPortal]
  }
}

resource "azurerm_data_factory_integration_runtime_azure" "datafactoryManagedIntegrationRuntime001" {
  name                = "${var.name}-adf-managedIR-${azurerm_data_factory.dataFactory.name}"
  data_factory_name   = azurerm_data_factory.dataFactory.name
  resource_group_name = var.rgName
  location            = var.location
}

resource "azurerm_role_assignment" "target" {
  count                = length(var.sharedSelfHostedIntegrationRuntimeId) > 0 && length(var.sharedDataFactoryId) > 0 ? 1 : 0
  scope                = var.sharedDataFactoryId
  role_definition_name = "Contributor"
  principal_id         = azurerm_data_factory.dataFactory.identity[0].principal_id
  depends_on = [
    azurerm_data_factory.dataFactory
  ]
}

resource "azurerm_data_factory_integration_runtime_self_hosted" "target" {
  count               = length(var.sharedSelfHostedIntegrationRuntimeId) > 0 && length(var.sharedDataFactoryId) > 0 ? 1 : 0
  name                = "${var.name}sharedshir"
  data_factory_name   = azurerm_data_factory.dataFactory.name
  resource_group_name = var.rgName

  rbac_authorization {
    resource_id = var.sharedSelfHostedIntegrationRuntimeId
  }

  depends_on = [azurerm_role_assignment.target]
}

resource "azurerm_data_factory_managed_private_endpoint" "datafactoryKeyVault001ManagedPrivateEndpoint" {
  name               = "${local.keyVault001Name}MPE"
  data_factory_id    = azurerm_data_factory.dataFactory.id
  target_resource_id = var.keyVault001Id
  subresource_name   = "vault"
}

resource "azurerm_data_factory_linked_service_key_vault" "datafactoryKeyVault001LinkedService" {
  name                     = "${local.keyVault001Name}LS"
  resource_group_name      = var.rgName
  data_factory_name        = azurerm_data_factory.dataFactory.name
  key_vault_id             = var.keyVault001Id
  integration_runtime_name = azurerm_data_factory_integration_runtime_azure.datafactoryManagedIntegrationRuntime001.name
  description              = "Key Vault for storing secrets"
  additional_properties = {
    baseUrl = "https://${local.keyVault001Name}.vault.azure.net/"
  }
  depends_on = [
    azurerm_data_factory_managed_private_endpoint.datafactoryKeyVault001ManagedPrivateEndpoint
  ]
}
