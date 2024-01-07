// main.bicep

module variables './variables.bicep' = {
  name: 'variables'
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-06-01-preview' existing = {
  name: variables.outputs.keyVaultName
}

resource adminPassword 'Microsoft.KeyVault/vaults/secrets@2021-06-01-preview' existing = {
  name: variables.outputs.adminPasswordSecretName
  parent: keyVault
}

// Network resources (VNet, Subnet, NSG, Pub IP, NIC)

resource vm 'Microsoft.Compute/virtualMachines@2020-06-01' = {
  name: variables.outputs.vmName
  location: variables.outputs.location
  properties: {
    hardwareProfile: {
      vmSize: variables.outputs.virtualMachineSize
    }
    osProfile: {
      computerName: variables.outputs.vmName
      adminUsername: variables.outputs.adminUsername
      adminPassword: adminPassword.value
    }
    storageProfile: {
      imageReference: {
        publisher: 'Debian'
        offer: 'debian-12'
        sku: '12'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic.id // Substitua pela ID correta da NIC após criar o recurso de NIC
        }
      ]
    }
  }
}

resource vmExtension 'Microsoft.Compute/virtualMachines/extensions@2020-06-01' = {
  name: '${vm.name}/ansibleConfig'
  properties: {
    publisher: 'Microsoft.Azure.Extensions'
    type: 'CustomScript'
    typeHandlerVersion: '2.1'
    settings: {
      fileUris: ['<URL-to-your-ansible-playbook-and-related-scripts>']
      commandToExecute: 'sh configure_vm.sh' // Este script deve instalar o Ansible e executar o playbook
    }
  }
}
