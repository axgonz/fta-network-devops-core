resource ipgAzureVnets 'Microsoft.Network/ipGroups@2021-05-01' = {
  name: 'ipg-azure-nvets'
  properties: {
    ipAddresses: [
      '10.1.0.0/16'
      '10.50.0.0/16'
    ]
  }
}

output ipgIdAzureVnets string = ipgAzureVnets.id


