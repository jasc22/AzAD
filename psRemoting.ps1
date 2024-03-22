#PSRemoting to computer

# Input computer name to connect to
$username = Read-Host "Enter username"

# Input computer name to connect to
$password = Read-Host "Enter password" -AsSecureString

# Input computer name to connect to
$computer = Read-Host "Enter computer IP"

$password = ConvertTo-SecureString $password -AsPlainText -Force
$creds = New-Object System.Management.Automation.PSCredential($username, $password)
$vm = New-PSSession -ComputerName $computer -Credential $creds -SessionOption (New-PSSessionOption -ProxyAccessType NoProxyServer)
Enter-PSSession -Session $vm

#Invoke-Command -FilePath C:\AzAD\Tools\lootVM.ps1 -Session $vm
