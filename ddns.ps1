Write-Host "DDNS for Cloudflare on Windows 10"

$getIP = Invoke-RestMethod -Method Get -Uri  https://ifconfig.me/all.json

Write-Host "Public IP Address of your machine is "$getIP.ip_addr