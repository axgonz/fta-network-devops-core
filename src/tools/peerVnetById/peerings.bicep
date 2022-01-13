param vnetId string 
param remoteVnetId string
param allowGatewayTransit bool = false
param useRemoteGateways bool = false

resource vnet 'Microsoft.Network/virtualNetworks@2021-05-01' existing = {
  name: toUpper(last(split(vnetId,'/')))
}

resource peer 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2021-05-01' = {
  name: '${toUpper(last(split(vnetId,'/')))}-to-${toUpper(last(split(remoteVnetId,'/')))}'
  parent: vnet
  properties: {
    remoteVirtualNetwork: {
      id: remoteVnetId
    }
    allowForwardedTraffic: true
    allowVirtualNetworkAccess: true
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  }
}

output peerId string = peer.id
