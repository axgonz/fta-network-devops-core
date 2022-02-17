param location string = resourceGroup().location

var name = 'pol-main'

resource polMain 'Microsoft.Network/firewallPolicies@2021-05-01' = {
  name: name
  location: location
  properties: {
     sku: {
       tier: 'Standard'
     }
     threatIntelMode: 'Alert'
     threatIntelWhitelist: {
       fqdns: []
       ipAddresses: []
     }
  }
}

module ipgs 'ipgroups.bicep' = {
  name: '${name}-ipgs'
}

module netrc 'netRuleColls.bicep' = {
  name: '${name}-netrulecollections'
  params: {
    policy: polMain
    ipgs: ipgs
  }
}

module apprc 'appRuleColls.bicep' = {
  name: '${name}-apprulecollections'
  params: {
    policy: polMain
    ipgs: ipgs
  }
}

module dnatrc 'dnatRuleColls.bicep' = {
  name: '${name}-dnatrulecollections'
  params: {
    policy: polMain
    ipgs: ipgs
  }
}

output polIdMain string = polMain.id
