// variables.bicep

// params
param location string = 'North Europe'
param vmName string = 'debian-vm'
param adminUsername string = 'adminuser'
param keyVaultName string = '<Your-KeyVault-Name>'
param adminPasswordSecretName string = '<Your-Secret-Name>'

// Net Settings
param networkSecurityGroupName string = toLower('${vmName}-nsg')
param virtualNetworkName string = toLower('${vmName}-vnet')
param subnetName string = 'default'
param publicIpAddressName string = toLower('${vmName}-ip')
param networkInterfaceName string = toLower('${vmName}-nic')

// VM Settings
param virtualMachineSize string = 'Standard_B1s' // Exemplo: Standard_B1s
