provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resources"
  location = "East US" # Escolha a região desejada
}

# Configuração das VMs de Kibana
resource "azurerm_virtual_machine" "kibana" {
  count                 = 2
  name                  = "kibana-${count.index}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.kibana[count.index].id]
  vm_size               = "Standard_B2s" # Altere para "Standard_B8s" para VMs maiores

  storage_os_disk {
    name              = "kibana-osdisk-${count.index}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  storage_image_reference {
    publisher = "elastic"
    offer     = "elasticsearch"
    sku       = "7.15.0"
    version   = "latest"
  }

  os_profile {
    computer_name  = "kibana-${count.index}"
    admin_username = "adminuser" # Defina o nome de usuário desejado
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = "YOUR_SSH_PUBLIC_KEY" # Insira sua chave pública SSH aqui
    }
  }
}

resource "azurerm_network_interface" "kibana" {
  count               = 2
  name                = "kibana-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  ip_configuration {
    name                          = "kibana-ipconfig"
    subnet_id                     = azurerm_subnet.kibana[count.index].id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_subnet" "kibana" {
  count                 = 2
  name                  = "kibana-subnet-${count.index}"
  resource_group_name   = azurerm_resource_group.example.name
  virtual_network_name  = azurerm_virtual_network.example.name
  address_prefixes      = ["10.0.${count.index}.0/24"] # Subnets diferentes para cada VM
}

# Configuração das VMs de Elasticsearch
resource "azurerm_virtual_machine" "elasticsearch" {
  count                 = 4
  name                  = "elasticsearch-${count.index}"
  location              = azurerm_resource_group.example.location
  resource_group_name   = azurerm_resource_group.example.name
  network_interface_ids = [azurerm_network_interface.elasticsearch[count.index].id]
  vm_size               = "Standard_B8s" # VMs maiores para Elasticsearch

  # ... configurações de armazenamento e imagem semelhantes às VMs de Kibana ...

  os_profile {
    computer_name  = "elasticsearch-${count.index}"
    admin_username = "adminuser" # Defina o nome de usuário desejado
  }

  os_profile_linux_config {
    disable_password_authentication = true
    ssh_keys {
      path     = "/home/adminuser/.ssh/authorized_keys"
      key_data = "YOUR_SSH_PUBLIC_KEY" # Insira sua chave pública SSH aqui
    }
  }
}

resource "azurerm_network_interface" "elasticsearch" {
  count               = 4
  name                = "elasticsearch-nic-${count.index}"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  # ... configuração semelhante às VMs de Kibana ...
}

# Configuração da rede virtual
resource "azurerm_virtual_network" "example" {
  name                = "example-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name
}

# ... defina a configuração do Subnet para Elasticsearch semelhante às VMs de Kibana ...

# Definindo regras de firewall para permitir SSH
resource "azurerm_network_security_group" "example" {
  name                = "example-nsg"
  location            = azurerm_resource_group.example.location
  resource_group_name = azurerm_resource_group.example.name

  security_rule {
    name                       = "allow-ssh"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}
