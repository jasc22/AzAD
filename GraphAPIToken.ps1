#LO12 - This script accepts an MS Graph Access Token and prints Enterprise Applications and their AppId 
# Input access token
$graphAccessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"

$token = $graphAccessToken
$URI = 'https://graph.microsoft.com/v1.0/applications'
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}

$enterpriseApps = (Invoke-RestMethod @RequestParams).value

Write-Host "`n----------------"
Write-Host "Enterprise Apps"
Write-Host "----------------`n"

foreach ($enterpriseApp in $enterpriseApps) {
        Write-Host $($enterpriseApp.displayName)
        Write-Host $($enterpriseApp.userPrincipalName)
        Write-Host $($enterpriseApp.appId)
        Write-Host `n
    }
