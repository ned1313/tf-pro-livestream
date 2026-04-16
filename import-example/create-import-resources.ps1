[CmdletBinding()]
param(
    [Parameter()]
    [string]$Prefix = "tf-pro-import",

    [Parameter()]
    [string]$Location = "eastus",

    [Parameter()]
    [string]$OutputFileName = "created-resources.json"
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

$suffix = Get-Date -Format "yyMMddHHmmss"
$randomDigits = Get-Random -Minimum 100 -Maximum 999

$resourceGroupName = "$Prefix-rg-$suffix-$randomDigits"
$storageAccountPrefix = ($Prefix -replace "[^a-z0-9]", "").ToLowerInvariant()
$storageSuffix = "$suffix$randomDigits"
$maxStorageNameLength = 24
$trimmedPrefixLength = [Math]::Min($storageAccountPrefix.Length, $maxStorageNameLength - $storageSuffix.Length)
$storageAccountName = $storageAccountPrefix.Substring(0, $trimmedPrefixLength) + $storageSuffix

$resourceGroup = Get-JsonCommandResult -Arguments @(
    "group", "create",
    "--name", $resourceGroupName,
    "--location", $Location,
    "--output", "json"
)

$storageAccount = Get-JsonCommandResult -Arguments @(
    "storage", "account", "create",
    "--name", $storageAccountName,
    "--resource-group", $resourceGroupName,
    "--location", $Location,
    "--kind", "StorageV2",
    "--sku", "Standard_LRS",
    "--access-tier", "Hot",
    "--https-only", "true",
    "--allow-blob-public-access", "false",
    "--min-tls-version", "TLS1_2",
    "--output", "json"
)

$result = [pscustomobject]@{
    resourceGroupName   = $resourceGroup.name
    resourceGroupId     = $resourceGroup.id
    storageAccountName  = $storageAccount.name
    storageAccountId    = $storageAccount.id
    location            = $resourceGroup.location
}

$outputPath = Join-Path -Path $PSScriptRoot -ChildPath $OutputFileName
$resultJson = $result | ConvertTo-Json -Depth 3
$resultJson | Set-Content -Path $outputPath -Encoding utf8

$resultJson