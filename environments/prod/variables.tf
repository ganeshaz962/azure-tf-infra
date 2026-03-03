variable "location" {
  type    = string
  default = "East US"
}

variable "rg_name" {
  type    = string
  default = "prod-rg"
}

variable "sa_name" {
  type    = string
  default = "prodsa12345"
}

variable "vnet_name" {
  type    = string
  default = "prod-vnet"
}

variable "vnet_address_space" {
  type    = list(string)
  default = ["172.0.0.0/16"]
}

