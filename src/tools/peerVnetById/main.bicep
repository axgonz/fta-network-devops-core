targetScope = 'subscription'

param vnetId string 
param remoteVnetId string
param allowGatewayTransit bool = false
param useRemoteGateways bool = false

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' existing = {
  name: last(split(vnetId,'/'))[4]
}

module dep 'peerings.bicep' = {
  name: '${rg.name}-peerVnetById'
  scope: rg
  params: {
    vnetId: vnetId
    remoteVnetId: remoteVnetId
    allowGatewayTransit: allowGatewayTransit
    useRemoteGateways: useRemoteGateways
  } 
} 

output peerId string = dep.outputs.peerId
