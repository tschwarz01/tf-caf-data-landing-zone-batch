resource "azurerm_cosmosdb_account" "cosmosdb" {
  name                                  = var.cosmosdb001Name
  location                              = var.location
  resource_group_name                   = var.rgName
  offer_type                            = "Standard"
  kind                                  = "GlobalDocumentDB"
  network_acl_bypass_for_azure_services = false

  enable_automatic_failover     = true
  public_network_access_enabled = false

  geo_location {
    location          = var.rgName
    failover_priority = 0
  }


  consistency_policy {
    consistency_level       = "Eventual"
    max_interval_in_seconds = 10
    max_staleness_prefix    = 200
  }

}


resource "azurerm_cosmosdb_sql_database" "cosmosDbSqlDatabase001" {
  name                = "Database001"
  resource_group_name = azurerm_cosmosdb_account.cosmosdb.resource_group_name
  account_name        = azurerm_cosmosdb_account.cosmosdb.name
  throughput          = 400
}


resource "azurerm_private_endpoint" "cosmosPrivateEndpoint" {
  name                = "${var.name}-${azurerm_cosmosdb_account.cosmosdb.name}-cosmos-portal-private-endpoint"
  location            = var.location
  resource_group_name = var.rgName
  subnet_id           = var.svcSubnetId

  private_service_connection {
    name                           = "${var.name}-${azurerm_cosmosdb_account.cosmosdb.name}-csmos-portal-private-endpoint-connection"
    private_connection_resource_id = azurerm_cosmosdb_account.cosmosdb.id
    subresource_names              = ["sql"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "ZoneGroup"
    private_dns_zone_ids = [var.privateDnsZoneIdCosmosdbSql]
  }
}
