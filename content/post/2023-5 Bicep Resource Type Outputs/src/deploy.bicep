targetScope = 'resourceGroup'

param location string = resourceGroup().location

module storageModule 'modules/storage.bicep' = {
  name: '${az.deployment().name}-storage'
  params: {
    storageName: 'mystorage'
    location: location
  }
}

module otherModule 'modules/other.bicep' = {
  name: '${az.deployment().name}-other'
  params: {
    storage: storageModule.outputs.storageInfo
  }
}

output passThruStorageInfo resource = otherModule.outputs.storageInfo
