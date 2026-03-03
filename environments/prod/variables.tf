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
  default = ["10.0.0.0/16"]
}

variable "tfstate_rg_name" {
  type    = string
  default = "prod-rg"
}

variable "tfstate_sa_name" {
  type    = string
  default = "prodsa12345"
}

variable "tfstate_container_name" {
  type    = string
  default = "tfstate"
}
