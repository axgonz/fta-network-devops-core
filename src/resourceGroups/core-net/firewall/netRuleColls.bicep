param policyId string
param ipgs object

resource policy 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: last(split(policyId,'/'))
}

resource netrc 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: 'DefaultNetworkRuleCollectionGroup'
  parent: policy
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
              ipgs.ipgIdAzureVnets
            ]
            destinationIpGroups: [
              ipgs.ipgIdOnPremSubnets
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
