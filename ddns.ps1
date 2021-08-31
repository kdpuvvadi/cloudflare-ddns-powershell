Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json

#Printing the Public IP
Write-Host "Public IP Address of your machine is"$getIP.ip_addr

#Read variables from vars.ini
$actVars = Get-Content -Path 'vars.ini' | ConvertFrom-StringData

Write-Host $actVars

# $getParametrs = @{
#     Method = "GET"
#     "X-Auth-Email" = $actVars.email
#     "X-Auth-Key" = $actVars.apikey
#     ContentType = "application/json"
#     Uri = "https://api.cloudflare.com/client/v4/zones/$actVars.zoneID/dns_records?type=$actVars.recordtype&name=$actVars.recordName.$actVars.domain"
# }

$apiHeader = @{
        Method = "GET"
        "X-Auth-Email" = $actVars.email
        "X-Auth-Key" = $actVars.apikey
}

$getUri = "https://api.cloudflare.com/client/v4/zones/b80f905f6a7cee8c93502a448400bf6e/dns_records?type=A&name=ss.puvvadi.me"


Invoke-RestMethod -Method Get -Headers $apiHeader -Uri $getUri -ContentType application/json