
resource "azurerm_mssql_server" "sqlServer" {
  name                          = "${var.name}-sql01"
  resource_group_name           = var.rgName
  location                      = var.location
  version                       = "12.0"
  administrator_login           = var.sqlAdminUserName
  administrator_login_password  = var.sqlAdminPassword
  minimum_tls_version           = "1.2"
  public_network_access_enabled = false

  azuread_administrator {
    login_username = var.sqlserverAdminGroupName
    object_id      = var.sqlserverAdminGroupObjectID
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.tags
}

resource "azurerm_mssql_database" "sqlDatabase001" {
  name                        = "Database001"
  server_id                   = azurerm_mssql_server.sqlServer.id
  collation                   = "SQL_Latin1_General_CP1_CI_AS"
  license_type                = "LicenseIncluded"
  max_size_gb                 = 1
  read_scale                  = false
  sku_name                    = "Basic"
  zone_redundant              = false
  auto_pause_delay_in_minutes = -1
  tags                        = var.tags

}

resource "azurerm_private_endpoint" "sqlDatabasePrivateEndpoint" {
  name                = "${var.name}-${azurerm_mssql_database.sqlDatabase001.name}-sql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_mssql_database.sqlDatabase001.name}-sql-private-endpoint-connection"
    private_connection_resource_id = azurerm_mssql_database.sqlDatabase001.id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdSqlServer]
  }
}
