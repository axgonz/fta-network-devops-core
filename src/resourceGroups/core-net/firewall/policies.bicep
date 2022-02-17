param config object
param location string = resourceGroup().location

var shortLocation = config.regionPrefixLookup[location]
var name = 'pol-main'

resource polMain 'Microsoft.Network/firewallPolicies@2021-05-01' = {
  name: '${shortLocation}-${name}'
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
  name: '${shortLocation}-${name}-ipgs'
  params: {
    config: config
  }
}

module netrc 'netRuleColls.bicep' = {
  name: '${shortLocation}-${name}-netrulecollections'
  params: {
    policyId: polMain.id
    ipgs: ipgs
  }
}

module apprc 'appRuleColls.bicep' = {
  name: '${shortLocation}-${name}-apprulecollections'
  params: {
    policyId: polMain.id
    ipgs: ipgs
  }
}

module dnatrc 'dnatRuleColls.bicep' = {
  name: '${shortLocation}-${name}-dnatrulecollections'
  params: {
    policyId: polMain.id
    ipgs: ipgs
  }
}

output polIdMain string = polMain.id
