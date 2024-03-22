#LO16 - Get access token and obtain information about UPN using Graph API without any AzureAD or Az PowerShell modules 

# Prompt for Azure AD credentials
$credential = Get-Credential -Message "Enter your Azure AD credentials"

# Connect using Azure AD
Connect-AzureAD -Credential $credential | Out-Null

# Input user principal name
$userPrincipalName = Read-Host "Enter User Principal Name (e.g., user@contoso.com)"

$token = (Get-AzAccessToken -ResourceUrl https://graph.microsoft.caom).Token
$URI = 'https://graph.microsoft.com/v1.0/users/'+ $userPrincipalName + '/memberOf'
   $RequestParams = @{
       Method  = 'GET'
       Uri     = $URI
       Headers = @{
'Authorization' = "Bearer $token" }
}

$members = (Invoke-RestMethod @RequestParams).value


Write-Host "`n----------------------------"
Write-Host "Memberships using Graph API"
Write-Host "----------------------------`n"

foreach ($member in $members) {
        Write-Host $($member.displayName)
        Write-Host $($member.id)
        Write-Host $($member.description)
        $auMember = Get-AzureADMSAdministrativeUnitMember -Id $($member.id)
        Write-Host $($auMember.RoleMemberInfo.DisplayName)
        Write-Host $($auMember.RoleMemberInfo.Id)
        Write-Host $($auMember.RoleMemberInfo.UserPrincipalName)
        Write-Host `n
        Write-Host `n
    }
