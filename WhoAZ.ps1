<# Install and import AzureAD module if not already installed
if (-not (Get-Module -Name AzureAD -ErrorAction SilentlyContinue)) {
    Install-Module -Name AzureAD -Scope CurrentUser -Force -AllowClobber
    Install-Module -Name Az -Scope CurrentUser -Force -AllowClobber
}#>

#Import-Module AzureAD

# Prompt for Azure AD credentials
$credential = Get-Credential -Message "Enter your Azure AD credentials"

# Connect using Azure AD
Connect-AzureAD -Credential $credential | Out-Null

# Connect using Az with Username and Password
Connect-AzAccount -Credential $credential | Out-Null

# Input user principal name
$userPrincipalName = Read-Host "Enter User Principal Name (e.g., user@contoso.com)"

# Get user object
$user = Get-AzureADUser -Filter "UserPrincipalName eq '$userPrincipalName'"

Write-Host "------------"
Write-Host "User Info"
Write-Host "------------"
Write-Host "`nTarget:" $($user.UserPrincipalName)
Write-Host "`User ObjectId: $($user.objectId)`n"

#Get Azure tenant details
$tenant = Get-AzureADTenantDetail
Write-Host "------------"
Write-Host "Tenant Info"
Write-Host "------------"
Write-Host "Tenant Name: $($tenant.DisplayName)"
Write-Host "Tenant Domain: $($tenant.VerifiedDomains.Name)"
Write-Host "Tenant ObjectId: $($tenant.ObjectId)"
Write-Host ""

if ($user -eq $null) {
    Write-Host "User not found."
} else {
    # Get group memberships
    $groupMemberships = Get-AzureADUserMembership -ObjectId $($user.ObjectId)

    Write-Host "`n----------------"
    Write-Host "Group Memberships"
    Write-Host "-----------------`n"
    
if ($groupMemberships) {
    foreach ($group in $groupMemberships) {
        Write-Host "Group Name: $($group.DisplayName)"
        Write-Host "Group Description: $($group.Membership)"
        Write-Host "Group ObjectId: $($group.ObjectId)"
    }
} else {
    Write-Host "User $($User.UserPrincipalName) is not a member of any groups."
}

    # Get role assignments using AzureADDirectoryRole and AzureADDirectoryRoleMember
    Write-Host "`n----------------------------------"
    Write-Host "User Assigned Roles"
    Write-Host "----------------------------------`n"
    if ($user) {
    $userId = $user.ObjectId
    Get-AzureADDirectoryRole | ForEach-Object {
        $roleName = $_.DisplayName
        $roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $_.ObjectId -ErrorAction SilentlyContinue
        $userRole = $roleMembers | Where-Object { $_.ObjectId -eq $userId }
        if ($userRole) {
            Write-Host "Azure AD Role Name: $roleName"
            Write-Host "Azure ADObject Type: $($userRole.ObjectType)"
            Write-Host ""
        }
    }
} else {
    Write-Host "'$userPrincipalName' not found."
}


    # Get role assignments using AzureADDirectoryRole and AzureADDirectoryRoleMember
    Write-Host "`n----------------------------------"
    Write-Host "Group Assigned Roles"
    Write-Host "----------------------------------`n"

    foreach ($group in $groupMemberships) {
        if ($group) {
        $groupId = $group.ObjectId
        Get-AzureADDirectoryRole | ForEach-Object {
            $roleName = $_.DisplayName
            $roleMembers = Get-AzureADDirectoryRoleMember -ObjectId $_.ObjectId -ErrorAction SilentlyContinue
            $groupRole = $roleMembers | Where-Object { $_.ObjectId -eq $groupId }
            if ($groupRole) {
                Write-Host "Azure AD Group Role Name: $roleName"
                Write-Host "Azure ADObject Type: $($groupRole.ObjectType)"
                Write-Host ""
            }
        }
    } else {
        Write-Host "'$userPrincipalName' is not part of a group with an assigned role."
    }
}

    # Get administrative unit memberships
    Get-AzureADMSAdministrativeUnit | ForEach-Object { $AUDisplayName=$_.DisplayName; $AUDesc=$_.Description; $AUId=$_.Id; Get-AzureADMSScopedRoleMembership -Id $_.Id | ForEach-Object { $DisplayNameR=$_.RoleMemberInfo.DisplayName; $IdR=$_.RoleMemberInfo.Id; Get-AzureADDirectoryRole -ObjectId $_.RoleId | ForEach-Object { $ADRole = $($_.DisplayName); $ADRoleDesc = $($_.Description) } } }

    Write-Host "`n----------------------------------"
    Write-Host "Administrative Unit Memberships"
    Write-Host "----------------------------------`n"
    Write-Host "AU Name: $($AUDisplayName)"
    Write-Host "AU Id: $($AUId)"
    Write-Host "AU Description: $($AUDesc)"
    Write-Host "Administrative Role: $($ADRole)"
    Write-Host "Administrative Role Description: $($ADRoleDesc)"
    Write-Host "$($DisplayNameR) is a member of $($ADRole)"
  

    # Get Azure resources
    $resources = Get-AzResource
    Write-Host "`n---------------------------------------------------------------------------------"
    Write-Host "$($User.UserPrincipalName) has access to the following Azure resources"
    Write-Host "---------------------------------------------------------------------------------`n"

    #Iterate over each resource for the current account and print
    foreach ($resource in $resources) {
        Write-Host "Name: "$($resource.Name)
        Write-Host "Resource Group: "$($resource.ResourceGroupName)
        Write-Host "Resource Id: "$($resource.ResourceId)`n
        
    }

    # Get Azure Role assignments
    $roles = Get-AzRoleAssignment -Scope $($resource.ResourceId)
    Write-Host "`n---------------------------------------------------------------------------------"
    Write-Host "$($User.UserPrincipalName) has the following role assignments"
    Write-Host "---------------------------------------------------------------------------------`n"

    #Iterate over each resource for the current account and print
    foreach ($role in $roles) {
        Write-Host "Name: "$($role.DisplayName)
        Write-Host "Role Definition Name: "$($role.RoleDefinitionName)
        Write-Host "RoleDefinitionId: "$($role.RoleDefinitionId)`n
    }

    # Get Azure Role actions
    $roles = Get-AzRoleAssignment -Scope $($resource.ResourceId)
    Write-Host "`n---------------------------------------------------------------------------------"
    Write-Host "$($User.UserPrincipalName) has the following role actions"
    Write-Host "---------------------------------------------------------------------------------`n"

    foreach ($role in $roles) {
        Write-Host "Role Definition Name: "$($role.RoleDefinitionName)
        $roleDefinition = Get-AzRoleDefinition -Name $($role.RoleDefinitionName)
        Write-Host "Actions: "$($roleDefinition.Actions)`n
    
    }
}
