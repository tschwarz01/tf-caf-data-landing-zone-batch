variable "privateDnsZoneIdDataFactory" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Data Factory."
}

variable "privateDnsZoneIdDataFactoryPortal" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for the Data Factory Portal."
}

variable "svcSubnetId" {
  type = string
}

variable "keyVault001Id" {
  type = string
}

variable "dataFactoryName" {
  type = string
}

variable "tags" {
  type        = map(string)
  description = "Tags that should be applied to all deployed resources"
}

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

variable "name" {
  type = string
}


variable "rgName" {
  type        = string
  description = "The name of the resource group"
}
