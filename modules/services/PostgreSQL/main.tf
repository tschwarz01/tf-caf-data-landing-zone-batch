resource "azurerm_postgresql_server" "postgresql" {
  name                = var.postgresql001Name
  location            = var.location
  resource_group_name = var.rgName

  administrator_login          = var.sqlAdminUserName
  administrator_login_password = var.sqlAdminPassword

  sku_name   = "GP_Gen5_4"
  version    = "9.6"
  storage_mb = 640000

  backup_retention_days        = 7
  geo_redundant_backup_enabled = true
  auto_grow_enabled            = true

  public_network_access_enabled    = false
  ssl_enforcement_enabled          = true
  ssl_minimal_tls_version_enforced = "TLS1_2"
}


resource "azurerm_postgresql_database" "postgresqlDatabase001" {
  name                = "Database001"
  resource_group_name = var.rgName
  server_name         = azurerm_postgresql_server.postgresql.name
  charset             = "UTF8"
  collation           = "English_United States.1252"
}

resource "azurerm_private_endpoint" "postgresqlDatabasePrivateEndpoint" {
  name                = "${var.name}-${azurerm_postgresql_database.postgresqlDatabase001.name}-postgresql-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_postgresql_database.postgresqlDatabase001.name}-postgresql-private-endpoint-connection"
    private_connection_resource_id = azurerm_postgresql_database.postgresqlDatabase001.id
    subresource_names              = ["postgresqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdPostgreSql]
  }
}
