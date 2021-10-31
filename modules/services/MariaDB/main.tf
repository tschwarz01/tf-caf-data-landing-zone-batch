resource "azurerm_mariadb_server" "mariadb" {
  count               = var.create_mariadb ? 1 : 0
  name                = var.mariadb001Name
  location            = var.location
  resource_group_name = var.rgName

  administrator_login          = var.sqlAdminUserName
  administrator_login_password = var.sqlAdminPassword

  sku_name   = "B_Gen5_2"
  storage_mb = 5120
  version    = "10.2"

  auto_grow_enabled             = true
  backup_retention_days         = 7
  geo_redundant_backup_enabled  = false
  public_network_access_enabled = false
  ssl_enforcement_enabled       = true
}

resource "azurerm_mariadb_database" "mariadbDatabase001" {
  count               = var.create_mariadb ? 1 : 0
  name                = "Database001"
  resource_group_name = var.rgName
  server_name         = azurerm_mariadb_server.mariadb[0].name
  charset             = "utf8"
  collation           = "utf8_general_ci"
}

resource "azurerm_private_endpoint" "mariadbDatabasePrivateEndpoint" {
  count               = var.create_mariadb ? 1 : 0
  name                = "${var.name}-${azurerm_mariadb_database.mariadbDatabase001[0].name}-mariadb-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_mariadb_database.mariadbDatabase001[0].name}-mariadb-private-endpoint-connection"
    private_connection_resource_id = azurerm_mariadb_database.mariadbDatabase001[0].id
    subresource_names              = ["mariadbServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdMariaDb]
  }
}
