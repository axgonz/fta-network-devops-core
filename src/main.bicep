targetScope = 'subscription'

param onlySpokeTemplates bool = false

var configText = loadTextContent('./main.config.json')
var configInit = json(configText)

var location = deployment().location

// Get the short location and update place holders in config
var shortLocation = configInit.regionPrefixLookup[location]
var configText_ = replace(configText,'\${shortLocation}','${shortLocation}')

// Get the needed octets to handle different address spaces for each region
var regionAddressPrefix = configInit.addressPrefixLookup[location]
var octet1 = int(split(regionAddressPrefix, '.')[0])
var octet2 = int(split(regionAddressPrefix, '.')[1])
var configText__ = replace(replace(configText_,'\${octet1}','${octet1}'),'\${octet2}','${octet2}')

var config = json(configText__)

// Create core resource group and update the deployment
resource rgCoreNet 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: '${shortLocation}-core-net'
  location: location
}

module depCoreNet 'resourceGroups/core-net/network.bicep' = {
  name: '${rgCoreNet.name}-network'
  scope: rgCoreNet
  params: {
    config: config
    onlySpokeTemplates: onlySpokeTemplates
  }
}

module depCoreNetPeerings 'resourceGroups/core-net/peerings.bicep' = if (!onlySpokeTemplates) {
  name: '${rgCoreNet.name}-peerings'
  scope: rgCoreNet
  params: {
    config: config
    allowGatewayTransit: false
  }  
  dependsOn: [
    depCoreNet
    //depCoreNetGateway
  ]
} 

// module depCoreNetGateway 'resourceGroups/core-net/gateway.bicep' = if (!onlySpokeTemplates) {
//   name: '${rgCoreNet.name}-gateway'
//   scope: rgCoreNet
//   params: {
//     config: config
//   }
// }

// module depCoreNetBastion 'resourceGroups/core-net/bastion.bicep' = if (!onlySpokeTemplates) {
//   name: '${rgCoreNet.name}-bastion'
//   scope: rgCoreNet
//   params: {
//     config: config
//   }
// }

// module depCoreNetFirewall'resourceGroups/core-net/firewall.bicep' = if (!onlySpokeTemplates) {
//   name: '${rgCoreNet.name}-firewall'
//   scope: rgCoreNet
//   params: {
//     config: config
//   }
// }

output vnetId_hub string = depCoreNet.outputs.vnetId_hub
