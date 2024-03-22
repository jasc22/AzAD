$passwd = ConvertTo-SecureString "PASSWORD" -AsPlainText -Force


New-LocalUser -Name studentX -Password $passwd 
Add-LocalGroupMember -Group Administrators -Member studentX
