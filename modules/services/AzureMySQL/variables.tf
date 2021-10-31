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
}

variable "privateDnsZoneIdMySqlServer" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MySQL."
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
}

variable "mysqlserverAdminGroupName" {
  type        = string
  description = "AD Group for Azure SQL sysadmin access"
}

variable "mysqlserverAdminGroupObjectID" {
  type        = string
  description = "AD Group ObjectID for Azure SQL sysadmin access"
}


variable "mysql001Name" {
  type = string
}

variable "create_mysql" {
  type = bool

}
