Param($varfile='vars.ini') # argument variable  in INI file

Write-Host "DDNS for Cloudflare on Windows 10"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json
$PublicIP = $getIP.ip_addr


#Read variables from ini
$actVars = Get-Content -Path $varfile | ConvertFrom-StringData

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
        "content"= "$($PublicIP)"
        "ttl"= 1
        "proxied"= $true
}

#converting powershell to json
$jsonBody = $updateBody | ConvertTo-Json

#check command status
function resultDNS ($checkRecord, $updateType) {
        
        if ( $checkRecord -eq $true ) {
                Write-Host "Successfully $updateType DNS record for $($actVars.record) to $($PublicIP)"
        }
        else {
                Write-Host "An error occured"
                
        }
        
}

# skip if the recrod is upto date
if ($PublicIP -eq $getRecord.result.content ) {
        Write-Host "$($actVars.record) is already upto date."
}
# Create new record if does not exist
elseif ($null -eq $($getRecord.result)) {
        Write-Host "$($actVars.record) does not exist on the cloudflare"

        $createUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records/"

        $createRecord = Invoke-RestMethod -Method POST -Headers $apiHeader -Uri $createUri -Body $jsonBody

        resultDNS -checkRecord $($createRecord.success) -updateType created

}
# Update if the record exist but different content
else {
        $updateUri = "https://api.cloudflare.com/client/v4/zones/$($actVars.zoneID)/dns_records/$($getRecord.result.id)"

        $updateRecord = Invoke-RestMethod -Method PUT -Headers $apiHeader -Uri $updateUri -Body $jsonBody

        resultDNS -checkRecord $($updateRecord.success) -updateType updated

}

