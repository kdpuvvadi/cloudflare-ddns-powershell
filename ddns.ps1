Param($varfile = 'vars.ini') # argument variable  in INI file

Write-Host "DDNS for Cloudflare with Powershell"

# Get Public IP with ifconfig
$getIP = Invoke-RestMethod -Method GET -Uri  https://ifconfig.me/all.json
$PublicIP = $getIP.ip_addr


#Read variables from ini
$actVars = Get-Content -Path $varfile | ConvertFrom-StringData
$TOKEN =  $actVars.apiToken
$domain = $actVars.domain
$subdomain = $actVars.subdomain
$record= "$subdomain.$domain"

# API auth headers with apitoken
$apiHeader = @{
	Authorization = "Bearer $TOKEN"
	"Content-Type" = "application/json"
}

# Get Zone id
$zoneID=(Invoke-RestMethod -Method Get -Headers $apiHeader -Uri  https://api.cloudflare.com/client/v4/zones?name=$($actVars.domain)).result.Id

#api url
$getUri = "https://api.cloudflare.com/client/v4/zones/$zoneID/dns_records?type=A&name=$record"

#record ID with get request
$getRecord = Invoke-RestMethod -Method Get -Headers $apiHeader -Uri $getUri -PassThru -OutFile .\log.txt

$updateBody = @{
	"type"    = "A"
	"name"    = "$record"
	"content" = "$($PublicIP)"
	"ttl"     = 1
	"proxied" = $true
}

#converting powershell to json
$jsonBody = $updateBody | ConvertTo-Json

#check command status
function resultDNS ($checkRecord, $updateType) { 
	if ( $checkRecord -eq $true ) {
		Write-Host "Successfully $updateType DNS record for $record to $($PublicIP)"
	}
	else {
		Write-Host "An error occured"		
	}    
}

# skip if the recrod is upto date
if ($PublicIP -eq $getRecord.result.content ) {
	Write-Host "$record is already upto date."
}
# Create new record if does not exist
elseif ($null -eq $($getRecord.result)) {
	Write-Host "$record does not exist on the cloudflare"
	$createUri = "https://api.cloudflare.com/client/v4/zones/$zoneID/dns_records/"
	$createRecord = Invoke-RestMethod -Method POST -Headers $apiHeader -Uri $createUri -Body $jsonBody
	resultDNS -checkRecord $($createRecord.success) -updateType created
}
# Update if the record exist but different content
else {
	$updateUri = "https://api.cloudflare.com/client/v4/zones/$zoneID/dns_records/$($getRecord.result.id)"
	$updateRecord = Invoke-RestMethod -Method PUT -Headers $apiHeader -Uri $updateUri -Body $jsonBody
	resultDNS -checkRecord $($updateRecord.success) -updateType updated
}
