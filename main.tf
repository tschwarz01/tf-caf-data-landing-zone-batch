
# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-data-management-zone-terraform"
    storage_account_name = "stgdatamgmtzoneterraform"
    container_name       = "tfstatedatalzbatch"
    key                  = "tfstatedatalzbatch.tfstate"
  }

  required_version = ">= 0.15.2"
}

provider "azurerm" {
  features {}
}

data "azurerm_client_config" "current" {}

resource "random_integer" "randomInt" {
  min = 1000
  max = 50000
}

resource "azurerm_resource_group" "rg_batch" {
  count    = length(var.lz_resource_groups.targetIntegrationResourceGroup) > 3 && length(var.lz_resource_groups.targetProductResourceGroup) > 3 ? 0 : 1
  name     = "rg-${local.name}-datalz-batch"
  location = var.location
  tags     = var.tags
}

module "keyVault001" {
  source                   = "./Modules/services/KeyVault"
  keyVault001Name          = local.keyVault001Name
  rgName                   = local.productResourceGroup
  name                     = local.name
  location                 = var.location
  svcSubnetId              = var.landingZoneServicesSubnetId
  privateDnsZoneIdKeyVault = var.privateDnsZoneIdKeyVault
}

module "synapse001" {
  source                       = "./Modules/services/Synapse"
  location                     = var.location
  rgName                       = local.productResourceGroup
  name                         = local.name
  synapseName                  = local.synapse001Name
  sqlAdminUserName             = var.sqlAdminUserName
  sqlAdminPassword             = var.sqlAdminPassword
  svcSubnetId                  = var.landingZoneServicesSubnetId
  synapseSqlAdminGroupName     = var.sqlserverAdminGroupName
  synapseSqlAdminGroupObjectID = var.sqlserverAdminGroupObjectID
  privateDnsZoneIdSynapseSql   = var.privateDnsZoneIdSynapseSql
  privateDnsZoneIdSynapseDev   = var.privateDnsZoneIdSynapseDev
  privateDnsZoneIdDfs          = var.privateDnsZoneIdDfs
}

module "datafactory001" {
  source                               = "./Modules/Services/DataFactory"
  location                             = var.location
  rgName                               = local.integrationResourceGroup
  name                                 = local.name
  dataFactoryName                      = local.dataFactory001Name
  tags                                 = var.tags
  svcSubnetId                          = var.landingZoneServicesSubnetId
  keyVault001Id                        = module.keyVault001.keyVaultId
  privateDnsZoneIdDataFactory          = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal    = var.privateDnsZoneIdDataFactoryPortal
  sharedDataFactoryId                  = var.shared_shir.sharedDataFactoryID
  sharedSelfHostedIntegrationRuntimeId = var.shared_shir.sharedSelfHostedIntegrationRuntimeId
}

module "cosmosdb001" {
  source                      = "./Modules/Services/CosmosDB"
  location                    = var.location
  rgName                      = local.productResourceGroup
  name                        = local.name
  cosmosdb001Name             = local.cosmosdb001Name
  tags                        = var.tags
  svcSubnetId                 = var.landingZoneServicesSubnetId
  privateDnsZoneIdCosmosdbSql = var.privateDnsZoneIdCosmosdbSql
}

module "sql001" {
  count                       = var.sql_offering == "azuresql" ? 1 : 0
  source                      = "./Modules/Services/AzureSQL"
  location                    = var.location
  rgName                      = local.productResourceGroup
  name                        = local.name
  sql001Name                  = local.sql001Name
  tags                        = var.tags
  svcSubnetId                 = var.landingZoneServicesSubnetId
  sqlAdminUserName            = var.sqlAdminUserName
  sqlAdminPassword            = var.sqlAdminPassword
  sqlserverAdminGroupName     = var.sqlserverAdminGroupName
  sqlserverAdminGroupObjectID = var.sqlserverAdminGroupObjectID
  privateDnsZoneIdSqlServer   = var.privateDnsZoneIdSqlServer
}

module "mysql001" {
  count                         = var.sql_offering == "mysql" ? 1 : 0
  source                        = "./Modules/Services/AzureMySQL"
  location                      = var.location
  rgName                        = local.productResourceGroup
  name                          = local.name
  mysql001Name                  = local.mysql001Name
  tags                          = var.tags
  svcSubnetId                   = var.landingZoneServicesSubnetId
  sqlAdminUserName              = var.sqlAdminUserName
  sqlAdminPassword              = var.sqlAdminPassword
  mysqlserverAdminGroupName     = var.sqlserverAdminGroupName
  mysqlserverAdminGroupObjectID = var.sqlserverAdminGroupObjectID
  privateDnsZoneIdMySqlServer   = var.privateDnsZoneIdMySqlServer
}

module "mariadb001" {
  count                   = var.sql_offering == "mariadb" ? 1 : 0
  source                  = "./Modules/Services/MariaDB"
  location                = var.location
  rgName                  = local.productResourceGroup
  name                    = local.name
  mariadb001Name          = local.mariadb001Name
  tags                    = var.tags
  svcSubnetId             = var.landingZoneServicesSubnetId
  sqlAdminUserName        = var.sqlAdminUserName
  sqlAdminPassword        = var.sqlAdminPassword
  privateDnsZoneIdMariaDb = var.privateDnsZoneIdMariaDb
}

module "postgresql001" {
  count                      = var.sql_offering == "postgresql" ? 1 : 0
  source                     = "./Modules/Services/PostgreSQL"
  location                   = var.location
  rgName                     = local.productResourceGroup
  name                       = local.name
  postgresql001Name          = local.postgresql001Name
  tags                       = var.tags
  svcSubnetId                = var.landingZoneServicesSubnetId
  sqlAdminUserName           = var.sqlAdminUserName
  sqlAdminPassword           = var.sqlAdminPassword
  privateDnsZoneIdPostgreSql = var.privateDnsZoneIdPostgreSql
}
