#LO9 - This script accepts an access token and prints 
# Input access token
$AccessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"

$token = $AccessToken
$URI = 'https://graph.microsoft.com/v1.0/users'
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}
(Invoke-RestMethod @RequestParams).value
$users = (Invoke-RestMethod @RequestParams).value

foreach ($users in $users) {
        Write-Host $($users.displayName)
        Write-Host $($users.userPrincipalName)
        Write-Host $($users.id)`n
    }
