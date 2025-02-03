variable "resource_group" {
  description = "Name of the resource group, including the -rg"
  default     = "sb-west-europe"
  type        = string
}

variable "packer_resource_group" {
  description = "Name of the resource group where the packer image is"
  default     =  "sb-west-europe"
  type        = string
}

variable "prefix" {
  description = "The prefix which should be used for all resources in the resource group specified"
  default     = "sb-"
  type        = string
}

variable "num_of_vms" {
  description = "Number of VM resources to create behund the load balancer"
  default     = 3
  type        = number
}

variable "location" {
  description = "The Azure Region in which all resources in this example should be created."
  default     = "WestEurope"
  type        = string
}