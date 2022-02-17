param policy object
param ipgs object

resource apprc 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: '${last(split(policy.id,'/'))}/DefaultApplicationRuleCollectionGroup'
  properties: {
    priority: 1000
    ruleCollections: [
      {
        name: 'SafeSites'
        priority: 1000
        ruleCollectionType: 'FirewallPolicyFilterRuleCollection'
        action: {
          type: 'Allow'
        }
        rules: [
          {
            ruleType: 'ApplicationRule'
            name: 'github'
            protocols: [
              {
                protocolType: 'Http'
                port: 80
              }
              {
                protocolType: 'Https'
                port: 443
              }
            ]
            terminateTLS: false
            sourceIpGroups: [
              ipgs.outputs.ipgIdAzureVnets
            ]
            targetFqdns: [
              '*.github.com'
            ]
          }
        ]
      }
    ]
  }
}
