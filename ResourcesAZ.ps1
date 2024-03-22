# Install and import AzureAD module if not already installed
#if (-not (Get-Module -Name Az -ErrorAction SilentlyContinue)) {
#    Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber
#}

#Import-Module Az

# Prompt user for choice
$choice = Read-Host "Choose authentication method:`n1. Access Token`n2. MS Graph Access Token`n3. Username and Password`n4. Service Principal-Username==App Id/Password==Secret"

if ($choice -eq "1") {
    # Get Access Token
    $AccessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"
    $accountID = Read-Host "Enter Account ID"
    
    # Connect to Azure with Access Token
    Connect-AzAccount -AccessToken $AccessToken -AccountId $accountID
}
elseif ($choice -eq "2") {
    # Get Microsoft Graph Access Token
    $AccessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"
    $MSGraphAccessToken =  Read-Host "Enter Microsoft Graph Access Token (e.g. eyJ0eX...)"
    $accountID = Read-Host "Enter Account ID"

    # Connect to MS Graph Access Token
    Connect-AzAccount -AccessToken $AccessToken -MicrosoftGraphAccessToken $MSGraphAccessToken -AccountId $accountID
}
elseif ($choice -eq "3") {
    # Get Azure Credentials
    $credential = Get-Credential -Message "Enter your Azure credentials"
    
    # Connect to Azure with Username and Password
    Connect-AzAccount -Credential $credential | Out-Null
}
elseif ($choice -eq "4") {
    # Authenticate as Service Principal -- Username == App Id and Password == Secret
    $servicePrincipal = Get-Credential -Message "Enter your Azure credentials"
    $tenantId = Read-Host "Enter Tenant Id"
    
    # Connect to Azure with Username and Password
    Connect-AzAccount -ServicePrincipal -Credential $servicePrincipal -Tenant $tenantId
}
else {
    Write-Host "Invalid choice. Please choose 1, 2, or 3."
}
Write-Host ""

# Get Azure resources
$resources = Get-AzResource
Write-Host "----------"
Write-Host "Resources"
Write-Host "----------"

#Iterate over each resource for the current account and print
foreach ($resource in $resources) {
    Write-Host "Name: "$($resource.Name)
    Write-Host "Resource Group: "$($resource.ResourceGroupName)
    Write-Host "Resource Id: "$($resource.ResourceId)
    if ($resource.ResourceId -like '*publicIPAddresses*') {
        $publicIpAddress = Get-AzPublicIpAddress -Name $resource.Name -ResourceGroupName $resource.ResourceGroupName
        if ($publicIpAddress) {
            Write-Host "Public IP Address: $($publicIpAddress.IpAddress)"
        } else {
            Write-Host "Public IP Address not found for $($resource.Name)."
        }
    } else {
        Write-Host `n
    }
}
Write-Host ""

# Get Azure resource groups
$resGroups = Get-AzResourceGroup
Write-Host "-----------------"
Write-Host "Resource Groups"
Write-Host "----------------"

#Iterate over each resource and print group
foreach ($resGroup in $resGroups) {
    Write-Host "Name: "$($resGroup.ResourceGroupName)
    Write-Host "Resource Id: "$($resGroup.ResourceId)
    Write-Host "Read Deployment of "$($resGroup.ResourceGroupName)
    $deployment = Get-AzResourceGroupDeployment -ResourceGroupName $($resGroup.ResourceGroupName)
    Write-Host "Deployment Name: "$($deployment.DeploymentName)
    Write-Host "Parameter String: "$($deployment.ParametersString)
}
Write-Host ""

# List VMs the user has access to
$vms = Get-AzVM
Write-Host "----------"
Write-Host "VMs"
Write-Host "----------"

#Iterate over each resource for the current account and print
foreach ($vm in $vms) {
    Write-Host "Name: "$($vm.Name)
    Write-Host "Resource Group: "$($vm.ResourceGroupName)
    Write-Host "Resource Id: "$($vm.VmId)`n
    }
Write-Host ""

# List Apps the user has access to
$apps = Get-AzWebApp
Write-Host "----------"
Write-Host "Web Apps"
Write-Host "----------"

#Iterate over each web app
foreach ($app in $apps) {
    Write-Host "Name: "$($app.Name)
    Write-Host "Host Names: "$($app.DefaultHostName)
    Write-Host "Resource Group: "$($app.ResourceGroup)
    Write-Host "Kind : "$($app.Kind)
    Write-Host "Scope: "$($app.Id)`n
    }
Write-Host ""

# List storage the user has access to
$stores = Get-AzStorageAccount
Write-Host "----------"
Write-Host "Storage"
Write-Host "----------"

#Iterate over each storage account
foreach ($store in $stores) {
    Write-Host "Name: "$($store.StorageAccountName)
    Write-Host "Resource Group: "$($store.ResourceGroupName)
    Write-Host "Kind : "$($store.Kind)
    Write-Host "Scope: "$($store.Id)
    $context = Get-AzStorageContainer -Context (New-AzStorageContext -StorageAccountName $($store.StorageAccountName))
    Write-Host "User has access to: "$($context.Name)`n
    }
Write-Host ""

# List keyvault the user has access to
$vaults = Get-AzKeyVault
Write-Host "----------"
Write-Host "Key Vault"
Write-Host "----------"

#Iterate over each key vault
foreach ($vault in $vaults) {
    # Retrieve secret from the current Key Vault
    $secrets = Get-AzKeyVaultSecret -VaultName $vault.VaultName
    foreach ($secret in $secrets) {
        Write-Host "Name: "$($vault.VaultName)
        Write-Host "Resource Group: "$($vault.ResourceGroupName)
        Write-Host "Scope: "$($vault.ResourceId)
        Write-Host "Secret Name: "$($secret.Name)`n
    }
}
