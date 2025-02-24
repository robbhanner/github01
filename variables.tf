variable "rgname" {
  type        = string
  default     = "inf-rg-rhanner1"
  description = "Resource Group Name"
}

variable "location" {
  type = string
}

variable "environment" {
  type = string
}

variable "vnet1name" {
  type = string
}

variable "vnet1cidr" {
  type = string
}