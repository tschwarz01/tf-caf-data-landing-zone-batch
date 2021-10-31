
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

resource "azurerm_resource_group" "rg_batch" {
  name     = "rg-${local.name}-datalz-batch"
  location = var.location
  tags     = var.tags
}

module "keyVault001" {
  source                   = "./Modules/services/KeyVault"
  keyVault001Name          = local.keyVault001Name
  rgName                   = azurerm_resource_group.rg_batch.name
  name                     = local.name
  location                 = var.location
  svcSubnetId              = var.landingZoneServicesSubnetId
  privateDnsZoneIdKeyVault = var.privateDnsZoneIdKeyVault
}

module "synapse001" {
  source                       = "./Modules/services/Synapse"
  location                     = var.location
  rgName                       = azurerm_resource_group.rg_batch.name
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
  source                            = "./Modules/Services/DataFactory"
  location                          = var.location
  rgName                            = azurerm_resource_group.rg_batch.name
  name                              = local.name
  dataFactoryName                   = local.dataFactory001Name
  tags                              = var.tags
  svcSubnetId                       = var.landingZoneServicesSubnetId
  keyVault001Id                     = module.keyVault001.keyVaultId
  privateDnsZoneIdDataFactory       = var.privateDnsZoneIdDataFactory
  privateDnsZoneIdDataFactoryPortal = var.privateDnsZoneIdDataFactoryPortal
}

module "cosmosdb001" {
  source                      = "./Modules/Services/CosmosDB"
  location                    = var.location
  rgName                      = azurerm_resource_group.rg_batch.name
  name                        = local.name
  cosmosdb001Name             = local.cosmosdb001Name
  tags                        = var.tags
  svcSubnetId                 = var.landingZoneServicesSubnetId
  privateDnsZoneIdCosmosdbSql = var.privateDnsZoneIdCosmosdbSql
}

module "sql001" {
  source                      = "./Modules/Services/AzureSQL"
  location                    = var.location
  rgName                      = azurerm_resource_group.rg_batch.name
  name                        = local.name
  sql001Name                  = local.sql001Name
  tags                        = var.tags
  svcSubnetId                 = var.landingZoneServicesSubnetId
  sqlAdminUserName            = var.sqlAdminUserName
  sqlAdminPassword            = var.sqlAdminPassword
  sqlserverAdminGroupName     = var.sqlserverAdminGroupName
  sqlserverAdminGroupObjectID = var.sqlserverAdminGroupObjectID
  privateDnsZoneIdSqlServer   = var.privateDnsZoneIdSqlServer
  create_azuresql             = var.create_azuresql
}

module "mysql001" {
  source                        = "./Modules/Services/AzureMySQL"
  location                      = var.location
  rgName                        = azurerm_resource_group.rg_batch.name
  name                          = local.name
  mysql001Name                  = local.mysql001Name
  tags                          = var.tags
  svcSubnetId                   = var.landingZoneServicesSubnetId
  sqlAdminUserName              = var.sqlAdminUserName
  sqlAdminPassword              = var.sqlAdminPassword
  mysqlserverAdminGroupName     = var.sqlserverAdminGroupName
  mysqlserverAdminGroupObjectID = var.sqlserverAdminGroupObjectID
  privateDnsZoneIdMySqlServer   = var.privateDnsZoneIdMySqlServer
  create_mysql                  = var.create_mysql
}

module "mariadb001" {
  source                  = "./Modules/Services/MariaDB"
  location                = var.location
  rgName                  = azurerm_resource_group.rg_batch.name
  name                    = local.name
  mariadb001Name          = local.mariadb001Name
  tags                    = var.tags
  svcSubnetId             = var.landingZoneServicesSubnetId
  sqlAdminUserName        = var.sqlAdminUserName
  sqlAdminPassword        = var.sqlAdminPassword
  privateDnsZoneIdMariaDb = var.privateDnsZoneIdMariaDb
  create_mariadb          = var.create_mariadb
}

module "postgresql001" {
  source                     = "./Modules/Services/PostgreSQL"
  location                   = var.location
  rgName                     = azurerm_resource_group.rg_batch.name
  name                       = local.name
  postgresql001Name          = local.postgresql001Name
  tags                       = var.tags
  svcSubnetId                = var.landingZoneServicesSubnetId
  sqlAdminUserName           = var.sqlAdminUserName
  sqlAdminPassword           = var.sqlAdminPassword
  privateDnsZoneIdPostgreSql = var.privateDnsZoneIdPostgreSql
  create_postgresql          = var.create_postgresql
}
