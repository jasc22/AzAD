#LO16 - This script accepts an Access Token and Key Vault Access Token
# Input access token
$accessToken = Read-Host "Enter Access Token (e.g. eyJ0eX...)"

# Input Key Vault Access token
$vaultAccessToken = Read-Host "Enter Key Vault Access Token (e.g. eyJ0eX...)"

# Input Account Id
$accountId = Read-Host "Enter Account Id (e.g. eyJ0eX...)"

Connect-AzAccount -AccessToken $accessToken -KeyVaultAccessToken $vaultAccessToken -AccountId $accountId

$keyvault.VaultName
$secretName = Get-AzKeyVaultSecret -VaultName $keyvault.VaultName
Write-Host "------------------"
Write-Host "Key Vault Secret"
Write-Host "-----------------"
Get-AzKeyVaultSecret -VaultName $keyvault.VaultName -Name $secretName.Name -AsPlainText
