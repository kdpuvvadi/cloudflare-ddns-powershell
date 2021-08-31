Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json

#Printing the Public IP
Write-Host "Public IP Address of your machine is"$getIP.ip_addr

#Read variables from vars.ini
$actVars = Get-Content -Path 'vars.ini' | ConvertFrom-StringData

#API auth headers
$apiHeader = @{
        "X-Auth-Email" = $actVars.email
        "X-Auth-Key" = $actVars.apikey
        "Content-Type" = "application/json"
}

#api url
$getUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records?type=$($actVars.recordType)&name=$($actVars.record)"

#record ID with get request
$getRecord = Invoke-RestMethod -Method Get -Headers $apiHeader -Uri $getUri -PassThru -OutFile .\log.txt

$updateBody = @{
        "type"= "$($actVars.recordType)"
        "name"= "$($actVars.record)"
        "content"= "$($getIP.ip_addr)"
        "ttl"= 1
        "proxied"= $true
}

$jsonBody = $updateBody | ConvertTo-Json

if ($null -eq $($getRecord.result)) {
        Write-Host "$($actVars.record) does not exist on the cloudflare"

        $createUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records/"

        $createRecord = Invoke-RestMethod -Method POST -Headers $apiHeader -Uri $createUri -Body $jsonBody

        if ( $createRecord.success -eq $true ) {
                Write-Host "Success fully updated DNS record for $($actVars.record) to $($getIP.ip_addr)"
        }
        else {
                Write-Host "An error occured"
                Write-Host "$($createRecord.errors)"
                Write-Host "$($createRecord.messages)"
        }

}
else {
        $updateUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records/$($getRecord.result.id)"

        $updateRecord = Invoke-RestMethod -Method PUT -Headers $apiHeader -Uri $updateUri -Body $jsonBody

        if ( $updateRecord.success -eq $true ) {
                Write-Host "Success fully updated DNS record for $($actVars.record) to $($getIP.ip_addr)"
        }
        else {
                Write-Host "An error occured"
                Write-Host "$($updateRecord.errors)"
                Write-Host "$($updateRecord.messages)"
        }
}

