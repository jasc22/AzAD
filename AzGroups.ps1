#Group Information and Membership

# Input group name
$groupName = Read-Host "Enter Group Name"
$adGroup = Get-AzADGroup -DisplayName $groupName

Write-Host "-------------------"
Write-Host "Group Information"
Write-Host "------------------"
Write-Host "`nName:" $($adGroup.DisplayName)
Write-Host "`nDescription:" $($adGroup.Description)

#Get group membership
Write-Host "-------------------"
Write-Host "Group Members"
Write-Host "------------------"
Get-AzADGroupMember -GroupDisplayName $groupName | select UserPrincipalName
#Write-Host $($groupMembership.DisplayName)
