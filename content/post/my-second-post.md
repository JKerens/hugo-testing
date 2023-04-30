---
author: "James Kerens"
title: "Azure PowerShell Intro" # Title of the blog post.
date: 2023-04-30T14:32:13-05:00 # Date of post creation.
description: "Another Example Placeholder" # Description used for search engine.
featured: true # Sets if post is a featured post, making appear on the home page side bar.
draft: false # Sets whether to render this page. Draft of true will not be rendered.
toc: false # Controls if a table of contents should be generated for first-level links automatically.
# menu: main
usePageBundles: false # Set to true to group assets like images in the same folder as this post.
# featureImage: "/images/path/file.jpg" # Sets featured image on blog post.
# featureImageAlt: 'Description of image' # Alternative text for featured image.
# featureImageCap: 'This is the featured image.' # Caption (optional).
# thumbnail: "/images/path/thumbnail.png" # Sets thumbnail image appearing inside card on homepage.
shareImage: "/images/path/share.png" # Designate a separate image for social media sharing.
codeMaxLines: 10 # Override global value for how many lines within a code block before auto-collapsing.
codeLineNumbers: false # Override global value for showing of line numbers within code block.
figurePositionShow: true # Override global value for showing the figure label.
categories:
  - Tricks
tags:
  - Azure
  - PowerShell
# comment: false # Disable comment if false.
---

# Azure PowerShell Basics

{{% notice tip "Complex Notices are Possible!" %}}
This is a notice that has a lot of various kinds of content in it.  

* Here is a bulleted list
* With more than one bullet
  * And even more than one level

```PowerShell
function WithRetry {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [ValidateNotNull()]
        [ScriptBlock] $Command,

        [Parameter(Mandatory = $false)]
        [int]$RetryCount = 3
    )
    Write-Host "Retry Injection Scope"  
    $i = 0
    do {
        try {
            return Invoke-Command $Command
        }
        catch {
            Write-Host "Retry #$((++$i))" -fore Red
        }
    } until ($i -ge $RetryCount)
}

function Invoke-FlakyCommand {
    param (
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)]
        [int]$Number
    )
    # Retries the command on transient errors.
    WithRetry {
        if (Get-Random -InputObject $true, $false) {
            throw "Oooops"
        }
        return $Number
    }
}

(1..5) | ForEach-Object { $_ | Invoke-FlakyCommand }
```

{{% /notice %}}
