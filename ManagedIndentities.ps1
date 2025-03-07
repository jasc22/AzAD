Get-AzRoleAssignment | Where-Object {
    (Get-AzADServicePrincipal -ObjectId $_.ObjectId).ServicePrincipalType -eq "ManagedIdentity"
} | Select-Object DisplayName, ObjectId, RoleDefinitionName, Scope
