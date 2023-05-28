---
title: "Azure Bicep Resource Output Types" # Title of the blog post.
date: '2023-05-19' # Date of post creation.
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

- VS Code
  - Azure Bicep Extension
- Azure Bicep
  - Understand Azure Bicep basics
  - Understand Bicep module basics

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

Now let's fill out the `storage.bicep` file to return the newly created storage resource as the last line in this code.

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

[bicep-existing-keyword]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/existing-resource

[bicep-modules]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/modules

[bicep-experimental-features]: https://learn.microsoft.com/azure/azure-resource-manager/bicep/bicep-config#enable-experimental-features

[bicep-resourcetype-proposal]: https://github.com/azure/bicep/issues/2245
