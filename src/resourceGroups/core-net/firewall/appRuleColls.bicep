param policyId string
param ipgs object

resource policy 'Microsoft.Network/firewallPolicies@2021-05-01' existing = {
  name: last(split(policyId,'/'))
}

resource apprc 'Microsoft.Network/firewallPolicies/ruleCollectionGroups@2021-05-01' = {
  name: 'DefaultApplicationRuleCollectionGroup'
  parent: policy
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
              ipgs.ipgIdAzureVnets
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
