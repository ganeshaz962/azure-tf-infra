# Virtual Network Module

This module creates an Azure Virtual Network with subnets and Network Security Groups.

## Features

- Creates Virtual Network with configurable address space
- Creates multiple subnets with service endpoints
- Automatically creates and associates NSGs per subnet
- Supports custom DNS servers
- Flexible tagging support

## Usage

```hcl
module "virtual_network" {
  source = "../module/virtual-network"

  vnet_name           = "vnet-hub-prod"
  resource_group_name = "rg-hub-prod"
  location            = "Central India"
  address_space       = ["10.0.0.0/16"]
  dns_servers         = []

  subnets = [
    {
      name             = "subnet-app"
      address_prefixes = ["10.0.1.0/24"]
      service_endpoints = [
        "Microsoft.Storage",
        "Microsoft.Sql"
      ]
      create_nsg = true
    },
    {
      name             = "subnet-data"
      address_prefixes = ["10.0.2.0/24"]
      service_endpoints = [
        "Microsoft.Storage",
        "Microsoft.Sql"
      ]
      create_nsg = true
    }
  ]

  tags = {
    Environment = "Production"
    ManagedBy   = "Terraform"
  }
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| vnet_name | Name of the virtual network | `string` | n/a | yes |
| resource_group_name | Name of the resource group | `string` | n/a | yes |
| location | Azure region for the virtual network | `string` | n/a | yes |
| address_space | Address space for the virtual network | `list(string)` | n/a | yes |
| dns_servers | List of DNS servers for the virtual network | `list(string)` | `[]` | no |
| subnets | List of subnets to create | `list(object)` | `[]` | no |
| tags | Tags to apply to resources | `map(string)` | `{}` | no |

### Subnet Object Structure

```hcl
{
  name               = string           # Name of the subnet
  address_prefixes   = list(string)     # Address prefixes for the subnet
  service_endpoints  = list(string)     # Optional: Service endpoints (default: [])
  create_nsg         = bool             # Optional: Create NSG for subnet (default: true)
}
```

## Outputs

| Name | Description |
|------|-------------|
| vnet_id | ID of the virtual network |
| vnet_name | Name of the virtual network |
| vnet_address_space | Address space of the virtual network |
| subnet_ids | Map of subnet names to IDs |
| subnet_names | List of subnet names |
| nsg_ids | Map of NSG names to IDs |

## Subnet Examples

### Application Subnet
```hcl
{
  name             = "subnet-app"
  address_prefixes = ["10.0.1.0/24"]
  service_endpoints = ["Microsoft.Storage", "Microsoft.Sql"]
  create_nsg       = true
}
```

### Azure Bastion Subnet
```hcl
{
  name             = "AzureBastionSubnet"
  address_prefixes = ["10.0.4.0/26"]
  service_endpoints = []
  create_nsg       = false  # Bastion has specific NSG requirements
}
```

### Gateway Subnet
```hcl
{
  name             = "GatewaySubnet"
  address_prefixes = ["10.0.5.0/27"]
  service_endpoints = []
  create_nsg       = false  # Gateway subnet cannot have NSG
}
```

## Network Security Groups

By default, an NSG is created for each subnet and automatically associated. To skip NSG creation for specific subnets (e.g., GatewaySubnet, AzureBastionSubnet), set `create_nsg = false`.

## Service Endpoints

Supported service endpoints include:
- Microsoft.Storage
- Microsoft.Sql
- Microsoft.AzureCosmosDB
- Microsoft.KeyVault
- Microsoft.ServiceBus
- Microsoft.EventHub
- Microsoft.Web
- Microsoft.ContainerRegistry

## Notes

- **GatewaySubnet**: Cannot have an NSG associated
- **AzureBastionSubnet**: Must be at least /26 CIDR block
- **Subnet names**: Must be unique within the VNet
- **Address spaces**: Must not overlap between subnets
