---
title: "Azure Bicep Resource Output Types" # Title of the blog post.
date: '2023-05-28' # Date of post creation.
description: 'Experimental Azure Bicep feature for resource output types'
summary: "When using `Azure Bicep Modules`, I have always found it suboptimal to return the bits and pieces of a newly created resource back to the main deployment bicep file. Wouldn't it be great if you could just return a strongly typed object of the resource? We already have features like the `existing` keyword so why not a resource return type? Well there currently is an experimental feature that does just that! And we will be going through it in this post"
draft: false 
toc: true
usePageBundles: true
categories:
  - 'How To'
tags:
  - Bicep
  - Azure
---

When using Azure [Bicep Modules][bicep-modules], I have always found it suboptimal to return the bits and pieces of a newly created resource back to the main deployment bicep file. Wouldn't it be great if you could just return a strongly typed object of the resource? We already have features like the [existing][bicep-existing-keyword] keyword so why not a resource return type? Well there currently is an experimental feature that does just that! And we will be going through it in this post.

## Prerequisites

- [VS Code][vs-code-download]
  - [Azure Bicep Extension][vs-code-bicep-ext]
- [Azure Bicep][azure-bicep-overview]
  - [Understand Azure Bicep basics][azure-bicep-basics]
  - [Understand Bicep module basics][azure-bicep-modules]

## Setup

Start by creating a folder to hold the Azure Bicep project called `src`

```powershell
New-Item "src" -ItemType Directory
```

Then add a `deploy.bicep` file as the entrypoint and a folder called `modules` for us to put the modules we will consume in our main `deploy.bicep` file

```powershell
New-Item "src/deploy.bicep" -ItemType File
New-Item "src/modules" -ItemType Directory
```

Create the files in our modules folder for us to test passing resource types for this demo

```powershell
New-Item "src/modules/other.bicep" -ItemType File
New-Item "src/modules/storage.bicep" -ItemType File
```

Then lastly, we need to turn on the [experimental feature][bicep-experimental-features] so we can support resource output types. So let's create a `bicepconfig.json` file. We will configure it in the solution steps coming up.

```powershell
New-Item "src/bicepconfig.json" -ItemType File
```

Your project should look like this after following the previous steps

```text
src
├── modules
│   ├── other.bicep
│   └── storage.bicep
├─── deploy.bicep
└─── bicepconfig.json
```

## Solution

Now add the bicepconfig.json fields to turn on the [experimental feature][bicep-resourcetype-proposal]

```json
{
    // See https://aka.ms/bicep/config for more information on Bicep configuration options
    // Press CTRL+SPACE/CMD+SPACE at any location to see Intellisense suggestions
    "analyzers": {
        "core": {
            "rules": {
                "no-unused-params": {
                    "level": "warning"
                }
            }
        }
    },
    "experimentalFeaturesEnabled": {
        "resourceTypedParamsAndOutputs": true
    }
}
```

Now let's fill out the `storage.bicep` file to output the newly created storage resource as the last line in this code.

{{% notice tip "TIP" %}}
If the word "resource" isn't recognized, double-check the bicepconfig.json is filled out correctly and your bicep installation is on the newest version. If all that fails, it could be that the experimental feature had a breaking change since this post was made.

- [Feature Proposal](https://github.com/azure/bicep/issues/2245)
{{% /notice %}}

```bicep
param storageName string
param location string = resourceGroup().location

resource storage 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: storageName
  location: location
  tags: resourceGroup().tags
  sku: {
    name: 'Standard_LRS'
  }
  kind:  'StorageV2'
}

output storageInfo resource = storage
```

Then fill out the `other.bicep` file to require a resource type input. For this demo we won't actually do anything with it, we just want to see how it works inside the linter in VS Code.

```bicep
param storage resource 'Microsoft.Storage/storageAccounts@2022-09-01'

output storageInfo resource = storage
```

Finally, let's fill out our main deployment file so we can pass this new resource type around. Go to the `deploy.bicep` file which we are using as the main entry point to connect all the modules for this deployment. We will pass the output from the `storage.bicep` up to the main `deployment.bicep`. Then pass it back into the `other.bicep` and lastly, pass it back up one last time to the main deployment file and output it to the person deploying it. That final output is handled at the bottom of the deploy.bicep file.

```bicep
targetScope = 'resourceGroup'

// This avoids the linter rule https://learn.microsoft.com/azure/azure-resource-manager/bicep/linter-rule-no-loc-expr-outside-params
param location string = resourceGroup().location 

module storageModule 'modules/storage.bicep' = {
  name: '${az.deployment().name}-storage' // This is a trick for making the names of everything match
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
```

## Summary

This is an exciting feature I hope to see pushed through to help make authoring modules a lot easier. the [existing][bicep-existing-keyword] has been extremely helpful but this will take it to the next level, in my opinion. Good or bad, let me know you thoughts on one of my social media links or give me feedback on what else you would like to see. Thank you for joining me and happy tinkering!

[bicep-existing-keyword]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/existing-resource

[bicep-modules]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules

[bicep-experimental-features]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-config#enable-experimental-features

[bicep-resourcetype-proposal]: https://github.com/azure/bicep/issues/2245

[vs-code-download]: https://code.visualstudio.com/download
[vs-code-bicep-ext]: https://marketplace.visualstudio.com/items?itemName=ms-azuretools.vscode-bicep
[azure-bicep-overview]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/overview?tabs=bicep
[azure-bicep-basics]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/file
[azure-bicep-modules]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules
