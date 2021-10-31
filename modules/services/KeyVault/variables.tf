variable "keyVault001Name" {
  type        = string
  description = "Name of the Azure Key Vault"
}

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
variable "privateDnsZoneIdKeyVault" {
  type        = string
  description = "Specifies the resource ID of the private DNS zone for Key Vault."
}
