param config object
param location string = resourceGroup().location

var shortLocation = config.regionPrefixLookup[location]
var name = 'bastion'

resource vnetHub 'Microsoft.Network/virtualNetworks@2021-02-01' existing = {
  name: '${config.hub.name}'
}

resource ipBastion 'Microsoft.Network/publicIPAddresses@2021-02-01' = {
  name: '${shortLocation}-${name}-ip'
  location: location
  sku: {
    name: 'Standard'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Static'
    idleTimeoutInMinutes: 4
  }
}

resource bastion 'Microsoft.Network/bastionHosts@2021-02-01' = {
  name: '${shortLocation}-${name}'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: ipBastion.id
          }
          subnet: {
            id: '${vnetHub.id}/subnets/AzureBastionSubnet'
          }
        }
      }
    ]
  }
  sku: {
    name: 'Basic'
  }
}
