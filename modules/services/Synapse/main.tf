//asdf
locals {
  synapseBatch001Name = "${var.name}-batch-synapse001"
}

data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "synapseStorageAcct" {
  name                      = "datalzbatchworkstg"
  resource_group_name       = var.rgName
  location                  = var.location
  account_tier              = "Standard"
  account_replication_type  = "LRS"
  account_kind              = "StorageV2"
  access_tier               = "Hot"
  is_hns_enabled            = true
  shared_access_key_enabled = true
  allow_blob_public_access  = false
  min_tls_version           = "TLS1_2"
  tags                      = var.tags
  identity {
    type = "SystemAssigned"
  }

  network_rules {
    default_action = "Deny"
    bypass         = toset(["AzureServices", "Metrics"])
  }
}

resource "azurerm_storage_data_lake_gen2_filesystem" "storageFileSystemsRaw" {

  name               = "synapsefs"
  storage_account_id = azurerm_storage_account.synapseStorageAcct.id
}

resource "azurerm_private_endpoint" "storage_dfs_private_endpoint" {

  name                = "${var.name}-${azurerm_storage_account.synapseStorageAcct.name}-dfs-private-endpoint"
  location            = var.location
  tags                = var.tags
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_storage_account.synapseStorageAcct.name}-dfs-private-endpoint-connection"
    private_connection_resource_id = azurerm_storage_account.synapseStorageAcct.id
    subresource_names              = ["dfs"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdDfs]
  }
}

resource "azurerm_synapse_workspace" "synapseBatch001" {
  name                                 = local.synapseBatch001Name
  resource_group_name                  = var.rgName
  location                             = var.location
  storage_data_lake_gen2_filesystem_id = azurerm_storage_data_lake_gen2_filesystem.storageFileSystemsRaw.id
  sql_administrator_login              = var.sqlAdminUserName
  sql_administrator_login_password     = var.sqlAdminPassword
  sql_identity_control_enabled         = true
  managed_virtual_network_enabled      = true

  aad_admin {
    login     = var.synapseSqlAdminGroupName
    object_id = var.synapseSqlAdminGroupObjectID
    tenant_id = data.azurerm_client_config.current.tenant_id
  }
  tags = var.tags
}

resource "azurerm_private_endpoint" "synapsePrivateEndpointSql" {
  name                = "${var.name}-synapse001-sql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-synapse001-sql-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseBatch001.id
    subresource_names              = ["Sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseSql]
  }
}

resource "azurerm_private_endpoint" "synapsePrivateEndpointSqlOnDemand" {
  name                = "${var.name}-synapse001-sqlod-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-synapse001-sqlod-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseBatch001.id
    subresource_names              = ["SqlOnDemand"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseSql]
  }
}

resource "azurerm_private_endpoint" "synapsePrivateEndpointDev" {
  name                = "${var.name}-synapse001-dev-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-synapse001-dev-private-endpoint-connection"
    private_connection_resource_id = azurerm_synapse_workspace.synapseBatch001.id
    subresource_names              = ["Dev"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSynapseDev]
  }
  depends_on = [
    azurerm_synapse_workspace.synapseBatch001
  ]
}

resource "azurerm_role_assignment" "synapse001StorageRoleAssignment" {
  scope                = azurerm_storage_account.synapseStorageAcct
  role_definition_name = "Storage Blob Data Contributor"
  principal_id         = azurerm_synapse_workspace.synapseBatch001.id
  depends_on = [
    azurerm_synapse_workspace.synapseBatch001
  ]
}
