[CmdletBinding()]
param(
    [Parameter()]
    [string]$ResourceGroupName = "tf-pro-drift-rg",

    [Parameter()]
    [string]$VirtualNetworkName = "tf-pro-drift-vnet",

    [Parameter()]
    [string]$EnvironmentTagValue = "prod"
)

$ErrorActionPreference = "Stop"

function Get-JsonCommandResult {
    param(
        [Parameter(Mandatory)]
        [string[]]$Arguments
    )

    $output = az @Arguments 2>&1
    if ($LASTEXITCODE -ne 0) {
        throw ($output | Out-String).Trim()
    }

    return ($output | Out-String | ConvertFrom-Json)
}

if (-not (Get-Command az -ErrorAction SilentlyContinue)) {
    throw "Azure CLI ('az') is required but was not found in PATH."
}

$null = Get-JsonCommandResult -Arguments @("account", "show", "--output", "json")

$virtualNetwork = Get-JsonCommandResult -Arguments @(
    "network", "vnet", "show",
    "--resource-group", $ResourceGroupName,
    "--name", $VirtualNetworkName,
    "--output", "json"
)

$updatedTags = @{}
if ($virtualNetwork.tags) {
    foreach ($property in $virtualNetwork.tags.PSObject.Properties) {
        $updatedTags[$property.Name] = [string]$property.Value
    }
}

$updatedTags["environment"] = $EnvironmentTagValue

$tagArguments = @()
foreach ($entry in $updatedTags.GetEnumerator()) {
    $tagArguments += "{0}={1}" -f $entry.Key, $entry.Value
}

$updateArguments = @(
    "tag", "update",
    "--resource-id", $virtualNetwork.id,
    "--operation", "Merge",
    "--tags"
) + $tagArguments + @(
    "--output", "json"
)

$null = Get-JsonCommandResult -Arguments $updateArguments

$updatedVirtualNetwork = Get-JsonCommandResult -Arguments @(
    "network", "vnet", "show",
    "--resource-group", $ResourceGroupName,
    "--name", $VirtualNetworkName,
    "--output", "json"
)

[pscustomobject]@{
    resourceId          = $updatedVirtualNetwork.id
    resourceGroupName   = $updatedVirtualNetwork.resourceGroup
    virtualNetworkName  = $updatedVirtualNetwork.name
    tags                = $updatedVirtualNetwork.tags
} | ConvertTo-Json -Depth 5