Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json

#Printing the Public IP
Write-Host "Public IP Address of your machine is"$getIP.ip_addr

#Read variables from vars.ini
$actVars = Get-Content -Path 'vars.ini' | ConvertFrom-StringData

# API auth headers
$apiHeader = @{
        "X-Auth-Email" = $actVars.email
        "X-Auth-Key" = $actVars.apikey
        "Content-Type" = "application/json"
}

#api url
$getUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records?type=$($actVars.recordType)&name=$($actVars.record)"

#record ID with get request
$getRecord = Invoke-RestMethod -Method Get -Headers $apiHeader -Uri $getUri

#output record id
Write-Host $getRecord.result.id

$putUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records/$($getRecord.result.id)"

Write-Host $putUri