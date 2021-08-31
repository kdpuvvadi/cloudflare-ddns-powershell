Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json

#Printing the Public IP
Write-Host "Public IP Address of your machine is"$getIP.ip_addr

#Read variables from vars.ini
$actVars = Get-Content -Path 'vars.ini' | ConvertFrom-StringData

$apiHeader = @{
        Method = "GET"
        "X-Auth-Email" = $actVars.email
        "X-Auth-Key" = $actVars.apikey
        "Content-Type" = "application/json"
}

$getUri = "https://api.cloudflare.com/client/v4/zones/$actVars.zoneID/dns_records?type=A&name=ss.puvvadi.me"


Invoke-RestMethod -Method Get -Headers $apiHeader -Uri $getUri