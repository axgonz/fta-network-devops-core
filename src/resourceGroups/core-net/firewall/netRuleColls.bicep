param policyId string
param ipgs object

resource netrc 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: '${last(split(policyId,'/'))}/DefaultNetworkRuleCollectionGroup'
  properties: {
    priority: 1000
    ruleCollections: [
      {
        name: 'basic'
        priority: 200
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'NetworkRule'
            name: 'azure-TO-onprem'
            ipProtocols: [
              'Any'
            ]
            sourceIpGroups: [
              ipgs.outputs.ipgIdAzureVnets
            ]
            destinationIpGroups: [
              ipgs.outputs.ipgIdOnPremSubnets
            ]
            destinationPorts: [
              '*'
            ]
          }
          {
            ruleType: 'NetworkRule'
            name: 'onprem-TO-azure'
            ipProtocols: [
              'Any'
            ]
            sourceIpGroups: [
              ipgs.outputs.ipgIdOnPremSubnets
            ]
            destinationIpGroups: [
              ipgs.outputs.ipgIdAzureVnets
            ]
            destinationPorts: [
              '*'
            ]
          }          
        ]
      }
    ]
  }
}
