# Cloudflare DDNS service for Windows

![cloudflare-ddns](img/ddns_cloudflare_powershell.png)

DDNS service for cloudflare users with PowerShell

## Creating a Cloudflare API token

To create a CloudFlare API token for your DNS zone go to [https://dash.cloudflare.com/profile/api-tokens](https://dash.cloudflare.com/profile/api-tokens) and follow these steps:

* Click Create Token
* Provide the token a name, for example, cloudflare-ddns
* Grant the token the following permissions:
* `Zone` - `Zone Settings` - `Read`
* `Zone` - `Zone` - `Read`
* `Zone` - `DNS` - `Edit`
* Set the zone resources to:
* Include - All zones

## Getting Started

Copy `eg.vars.ini` to `vars.ini` or whatever you like e.g. `file.ini`

```powershell
Copy-Item -Path eg.vars.ini -Destination vars.ini
```

Edit `vars.ini` and replace the values with your own.

```ini
apiToken=
domain=      
subdomain=
```

* apiToken: Cloudflare `token` (generated from previsous wizard)
* domain: Domain Name (example.com)
* Subdomain: `cname` for the subdomain (test is test.example.com)

## Deployment

To deploy this project run

```powershell
.\ddns.ps1
```

## Auto Update

Create a task Scheduler task to repeat the task every 5 min to update the record periodically.

### Trigger

* `Begin the task`: `On a Shedule`
* Settings: `Daily` & Recur Every `1` Day
* Repeat the task every `5 minutes` for a duration of `indefinitely`

### Actions

* Action: `Start a program`
* Program/Script:
  * `"C:\Program Files\PowerShell\7\pwsh.exe"` for Powershell 7
  * `"C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe"` for Powershell 5
* Add arguments: `-File "~\Documents\cloudflare-ddns-powershell\ddns.ps1"`
* Start in: `"~\Documents\cloudflare-ddns-powershell\"`

> Change the path to actual path. Here assuming it is store in Documents.

## LICENSE

Licensed under [MIT](/LICENSE)
