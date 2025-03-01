# Input Tenant Id
$TenantId = Read-Host "Enter TenantId"
$URL = "https://login.microsoftonline.com/$TenantId/oauth2/token"
$Params = @{
    "URI" = $URL
    "Method" = "POST"
}

$Body = @{
    "grant_type" = "srv_challenge"
}
$Result = Invoke-RestMethod @Params -UseBasicParsing -Body
$Body
$Result.Nonce