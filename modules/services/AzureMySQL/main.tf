data "azurerm_client_config" "current" {}
resource "azurerm_mysql_server" "mysqlServer001" {
  name                = var.mysql001Name
  location            = var.location
  resource_group_name = var.rgName

  administrator_login          = var.sqlAdminUserName
  administrator_login_password = var.sqlAdminPassword

  sku_name   = "GP_Gen5_2"
  storage_mb = 5120
  version    = "5.7"

  auto_grow_enabled                 = true
  backup_retention_days             = 7
  geo_redundant_backup_enabled      = false
  infrastructure_encryption_enabled = false
  public_network_access_enabled     = false
  ssl_enforcement_enabled           = true
  ssl_minimal_tls_version_enforced  = "TLS1_2"
}

resource "azurerm_mysql_active_directory_administrator" "mysqlServerADConfig" {
  server_name         = azurerm_mysql_server.mysqlServer001.name
  resource_group_name = var.rgName
  login               = var.mysqlserverAdminGroupName
  tenant_id           = data.azurerm_client_config.current.tenant_id
  object_id           = var.mysqlserverAdminGroupObjectID
}

resource "azurerm_mysql_database" "mysqlserverDatabase001" {
  name                = "Database001"
  resource_group_name = var.rgName
  server_name         = azurerm_mysql_server.mysqlServer001.name
  charset             = "utf8"
  collation           = "utf8_unicode_ci"
}

resource "azurerm_private_endpoint" "mysqlserverPrivateEndpoint" {
  name                = "${var.name}-Database001-mysql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-Database001-mysql-private-endpoint-connection"
    private_connection_resource_id = azurerm_mysql_server.mysqlServer001.id
    subresource_names              = ["mysqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdMySqlServer]
  }
}
