param policyId string
param ipgs object

resource dnatrc 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: '${last(split(policyId,'/'))}/DefaultDnatRuleCollectionGroup'
  properties: {
    priority: 1000
    ruleCollections: [
      {
        name: 'website'
        priority: 200
        ruleCollectionType: 'FirewallPolicyNatRuleCollection'
        rules: [
          {
            ruleType: 'NatRule'
            name: 'port80bind'
            ipProtocols: [
              'Any'
            ]
            sourceAddresses: [
              '*'
            ]
            destinationAddresses: [
              '*'
            ]
            destinationPorts: [
              '80'
            ]
            translatedAddress: '10.1.43.4'
            translatedPort: '80'
          }         
        ]
      }
    ]
  }
}
