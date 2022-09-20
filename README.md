# Cloudflare DDNS service for Windows

![cloudflare-ddns](ddns_cloudflare_powershell.png)

DDNS service for cloudflare users with PowerShell

## Getting Started

Copy `eg.vars.ini` to `vars.ini` or whatever you like e.g. `file.ini`

```powershell
Copy-Item -Path eg.vars.ini -Destination vars.ini
```

Edit `vars.ini` and replace the values with your own.

```ini
apiKey=
apiToken=
email=
zoneID=
record=
recordType=
```

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

Complete the wizard and copy the generated token into the API_KEY variable for the container

* `apiKey`: Go to your [Cloudflare Profile](https://dash.cloudflare.com/profile/api-tokens) and grab the `API Key`
* `email`: Your Cloudflare Email
* `zoneID`: Go to [Cloudflare Dashboard](https://dash.cloudflare.com/), select the Zone and copy the Zone ID on the right side
* `record`: Full record name e.g exmaple.com or subdomain site1.example.com
* `recordType`: Set this to A

## Deployment

To deploy this project run

```powershell
ddns.ps1 -varfile vars.ini
```

## Auto Update

Create a task Scheduler task to repeat the task every 5 min to update the record periodically.
