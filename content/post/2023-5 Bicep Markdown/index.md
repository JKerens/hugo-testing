---
title: 'Using Markdown Syntax in your Bicep Modules'
description: 'Using Markdown Syntax in your Bicep Modules'
summary: "Until recently I was only authoring Azure Bicep files in my own projects or shared projects with a few close knit people. But once you start publishing modules to things like `Azure Container Registry (ACR)`, you might want to start considering a more verbose description. Here's a few basic examples to `flex your biceps`."
date: '2023-05-13'
aliases:
  - azure-bicep-markdown
author: 'James Kerens'
usePageBundles: true
draft: true
# Top image on post.
# featureImageAlt: 'Description of image' # Alternative text for featured image.
# featureImageCap: 'This is the featured image.' # Caption (optional).
# thumbnail: 'thumbnail.jpg' # Image in lists of posts.
# shareImage: 'share.jpg' # For SEO and social media snippets.

categories:
  - 'How To'
tags:
  - Bicep
  - Azure
---

Until recently I was only authoring Azure Bicep files in my own projects or shared projects with a few close knit people. But once you start publishing modules to things like Azure Container Registry (ACR), you might want to start considering a more verbose description. Here's a few basic examples to "flex your biceps".

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

Then lastly create a file in our modules folder for us to add the markdown syntax description for this demo

```powershell
New-Item "src/modules/example.bicep" -ItemType File
```

Your project should look like this after following the previous steps

```text
src
├── modules
│   ├── example.bicep
└── deploy.bicep
```

Full code example - [here](/src)
