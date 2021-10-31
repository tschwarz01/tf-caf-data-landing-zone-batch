prefix      = "datalzbatch"
location    = "southcentralus"
environment = "dev"

/*
This template (usually) depends on previous deployment of the Data Management Zone
and Base Landing Zone templates.
*/

/*
The Services Subnet is usually deployed into the Data Management Zone.
Provide the Azure Resource ID for the Services subnet below
*/
landingZoneServicesSubnetId = ""

/*
The base landing zone template creates resource groups which may be used by
future deployments of the Batch, Analytics & Streaming supplemental templates
By default, these resource group names end with 'data-int-001' and 'data-product001'.

If you wish to deploy this template into existing resource groups, provide the
resource group names for both an integration and product resource group
*/
lz_resource_groups = {
  targetProductResourceGroup     = ""
  targetIntegrationResourceGroup = ""
}

/*
Please provide both values in order to link the Shared Integration Runtime
with the instance of ADF deployed by this template.
*/
shared_shir = {
  sharedDataFactoryId                  = ""
  sharedSelfHostedIntegrationRuntimeId = ""
}

// Valid values for var: sql_offering are ("none", "azuresql", "mysql", "mariadb" and "postgresql")
sql_offering = "azuresql"

// The following credentials will be used for resources
// where they are applicable - not just Azure SQL.
// e.g. Synapse, Azure SQL, Azure MySQL, Azure PostgreSQL, etc
sqlAdminUserName            = ""
sqlAdminPassword            = ""
sqlserverAdminGroupName     = ""
sqlserverAdminGroupObjectID = ""

// Private DNS Zones for Azure Private Link resources are usually created in centralized
// location, such as the Connectivity Hub subscription, or Data Management Zone subscription.
// The resource IDs for the existing zones should be provided below.
//
// e.g. -  "/subscriptions/<SUBSCRIPTION ID>/resourceGroups/<RESOURCE GROUP NAME>/providers/Microsoft.Network/privateDnsZones/privatelink.blob.core.windows.net"
privateDnsZoneIdKeyVault          = ""
privateDnsZoneIdDfs               = ""
privateDnsZoneIdDataFactory       = ""
privateDnsZoneIdDataFactoryPortal = ""
privateDnsZoneIdCosmosdbSql       = ""
privateDnsZoneIdSqlServer         = ""
privateDnsZoneIdMySqlServer       = ""
privateDnsZoneIdPostgreSql        = ""
privateDnsZoneIdMariaDb           = ""
