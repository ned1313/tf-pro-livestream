# Deploy and Azure Virtual Machine running Ubuntu 22.04
# Include a Public IP address and DNS name

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "check-block-example"
  location = "West US"
}

module "main_network" {
  source  = "Azure/avm-res-network-virtualnetwork/azurerm"
  version = "0.17.1"

  location  = azurerm_resource_group.example.location
  parent_id = azurerm_resource_group.example.id

  address_space    = ["10.0.0.0/16"]
  enable_telemetry = false
  name             = "check-block-vnet"
  subnets = {
    web = {
      name           = "web"
      address_prefix = "10.0.0.0/24"
    }
  }
}

resource "tls_private_key" "ssh" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "azurerm_public_ip" "pip" {
  allocation_method   = "Static"
  location            = azurerm_resource_group.example.location
  name                = "check-pip"
  resource_group_name = azurerm_resource_group.example.name
}

module "ubuntu_server" {
  source  = "Azure/avm-res-compute-virtualmachine/azurerm"
  version = "0.20.0"

  enable_telemetry    = false
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
  name                = "check-vm"
  zone                = null
  encryption_at_host_enabled = false
  network_interfaces = {
    "nic" = {
      name                  = "check-nic"
      ip_forwarding_enabled = true
      is_primary            = true
      ip_configurations = {
        "ipconfig" = {
          name                          = "check-ipconfig"
          private_ip_subnet_resource_id = module.main_network.subnets["web"].resource_id
          public_ip_address_resource_id = azurerm_public_ip.pip.id
        }
      }
    }
  }

  os_type = "Linux"

  sku_size = "Standard_D2s_v6"
  source_image_reference = {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts-gen2"
    version   = "latest"
  }

  os_disk = {
    caching              = "ReadWrite"
    storage_account_type = "Premium_LRS"
  }

  account_credentials = {
    admin_username                     = "azureuser"
    ssh_keys                           = [tls_private_key.ssh.public_key_openssh]
    generate_admin_password_or_ssh_key = false
  }

  custom_data = base64encode(templatefile("${path.module}/userdata.tpl", {}))

}

resource "azurerm_network_security_group" "allow_web" {
  resource_group_name = azurerm_resource_group.example.name
  location            = azurerm_resource_group.example.location
  name                = "check-example"
}

resource "azurerm_network_security_rule" "http" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.example.name
  network_security_group_name = azurerm_network_security_group.allow_web.name
}

resource "azurerm_network_interface_security_group_association" "allow_web" {
  network_interface_id      = module.ubuntu_server.network_interfaces["nic"].id
  network_security_group_id = azurerm_network_security_group.allow_web.id
}

data "azurerm_public_ip" "pip" {
  name                = azurerm_public_ip.pip.name
  resource_group_name = azurerm_resource_group.example.name

  depends_on = [module.ubuntu_server]
}