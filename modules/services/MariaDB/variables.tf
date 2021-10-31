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

variable "privateDnsZoneIdMariaDb" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Azure Database for MariaDB."
}

variable "sqlAdminUserName" {
  type        = string
  description = "Administrator username to be used for all Azure SQL Databases created by this deployment"
}

variable "sqlAdminPassword" {
  type        = string
  description = "Administrator password to be used for all Azure SQL Databases created by this deployment"
}


variable "mariadb001Name" {
  type = string
}
