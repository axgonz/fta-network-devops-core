param config object
param allowGatewayTransit bool = false

resource hubVnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: config.hub.name
}

resource peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = [for target in config.spokes._peerToHub: {
  name: '${toUpper(last(split(hubVnet.id,'/')))}-to-${toUpper(last(split(config.spokes[target].id,'/')))}'
  parent: hubVnet
  properties: {
    remoteVirtualNetwork: {
      id: config.spokes[target].id
    }
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    allowGatewayTransit: allowGatewayTransit
  }
}]
