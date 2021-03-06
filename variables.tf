variable "environment" {
  type        = string
  description = "The release stage of the environment"
  default     = "dev"
}

variable "prefix" {
  type        = string
  description = "prefix to be used for resource names"
  default     = "datalzbatch"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
  default     = "southcentralus"
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
  default = {
    deployedBy = ""
    Owner      = ""
    Project    = ""
    #Environment = locals.environment
    Toolkit = "Terraform"
  }
}

variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "privateDnsZoneIdKeyVault" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Key Vault."
}

variable "landingZoneServicesSubnetId" {
  type        = string
  description = "The Azure resource id of the Landing Zone shared services subnet"
}

variable "sqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure SQL sysadmin access"
}

variable "sqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure SQL sysadmin access"
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
}

variable "privateDnsZoneIdSynapseSql" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Sql Namespaces."
}

variable "privateDnsZoneIdSynapseDev" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Synapse Dev Namespaces."
}

variable "privateDnsZoneIdDfs" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Datalake Storage."
}

variable "privateDnsZoneIdDataFactory" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Data Factory."
}

variable "privateDnsZoneIdDataFactoryPortal" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for the Data Factory Portal."
}

variable "privateDnsZoneIdCosmosdbSql" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Cosmos DB."
}

variable "privateDnsZoneIdSqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure SQL DB."
}

variable "privateDnsZoneIdMySqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MySQL."
}

variable "privateDnsZoneIdMariaDb" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MariaDB."
}

variable "privateDnsZoneIdPostgreSql" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for PostgreSQL."
}

variable "sql_offering" {
  type        = string
  description = "Specifies the type of managed relational database that will be deployed (None, SQL Server, MySQL Server, MariaDB Server, PostgreSQL Server)."

  validation {
    condition     = contains(["none", "azuresql", "mysql", "mariadb", "postgresql"], lower(var.sql_offering))
    error_message = "Valid values for var: test_variable are (none, azuresql, mysql, mariadb and postgresql)."
  }
}

variable "shared_shir" {
  type = map(any)
  default = {
    sharedDataFactoryId                  = ""
    sharedSelfHostedIntegrationRuntimeId = ""
  }
}

variable "lz_resource_groups" {
  type = map(any)
  default = {
    targetProductResourceGroup     = ""
    targetIntegrationResourceGroup = ""
  }
}
