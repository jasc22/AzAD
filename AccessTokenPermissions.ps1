#L10 - This script accepts an access token and prints 

# Prompt for Azure AD credentials
#$credential = Get-Credential -Message "Enter your Azure AD credentials"

# Connect using Azure AD
#Connect-AzureAD -Credential $credential | Out-Null

# Input user principal name
#$userPrincipalName = Read-Host "Enter User Principal Name (e.g., user@contoso.com)"

# Input access token
$AccessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"

$token = $AccessToken
$URI = 'https://management.azure.com/subscriptions?api-version=2020-01-01'
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}
$subscription = (Invoke-RestMethod @RequestParams).value

# Get subscription id

$URI = 'https://management.azure.com'+$($subscription.id)+'/resources?api-version=2020-01-01'
#Write-Host $URI
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}
$resources = (Invoke-RestMethod @RequestParams).value

Write-Host "`n--------------------------------------"
Write-Host "Resource Permissions for Access Token"
Write-Host "--------------------------------------`n"

foreach ($resource in $resources) {

$URI = 'https://management.azure.com'+$($resource.id)+'/providers/Microsoft.Authorization/permissions?api-version=2022-04-01'
Write-Host $URI
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}
(Invoke-RestMethod @RequestParams).value
}
