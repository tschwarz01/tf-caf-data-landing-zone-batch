variable "rgName" {
  type        = string
  description = "The name of the resource group"
}

variable "location" {
  type        = string
  description = "The location of the resource group"
}


variable "name" {
  type = string
}


variable "svcSubnetId" {
  type        = string
  description = "The Azure resource id of the Landing Zone shared services subnet"
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

variable "synapseSqlAdminGroupName" {
  type        = string
  description = "AD Group for Azure SQL sysadmin access"
}

variable "synapseSqlAdminGroupObjectID" {
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

variable "synapseName" {
  type        = string
  description = "Name of the Azure Synapse workspace"
}
