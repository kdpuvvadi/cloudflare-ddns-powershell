Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method Get -Uri  https://ifconfig.me/all.json

#Printing the Public IP
Write-Host "Public IP Address of your machine is"$getIP.ip_addr

#Read variables from vars.ini
$actVars = Get-Content -Path 'vars.ini' | ConvertFrom-StringData

Write-Host $actVars.apikey
