param(
  [string]$SITE_HOST = "yishen.ai",
  [string]$MODE = "ALL"
)

$ROOT = Get-Location
$ErrorActionPreference = "Stop"

function Ensure($p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Path $p | Out-Null } }

$countries = "us","ca","mx","br","gb","de","fr","it","es","nl","pl","tr","ru","sa","ae","eg","za","in","jp","kr","au","nz","sg","my","th","vn","ph","id"

function CountryHTML($cc){
@"
<!doctype html><html><head><meta charset="utf-8">
<title>$cc | YiShen Global</title></head>
<body><h1>$cc Gateway</h1>
<a href="/$cc/rfq/">RFQ</a> | <a href="/$cc/autoquote/">AutoQuote</a> | <a href="/$cc/buyer-radar/">Buyer Radar</a>
</body></html>
"@
}

foreach($cc in $countries){
  Ensure $cc
  Ensure "$cc\rfq"; Ensure "$cc\autoquote"; Ensure "$cc\buyer-radar"
  CountryHTML $cc | Set-Content "$cc\index.html"
  CountryHTML $cc | Set-Content "$cc\rfq\index.html"
  CountryHTML $cc | Set-Content "$cc\autoquote\index.html"
  CountryHTML $cc | Set-Content "$cc\buyer-radar\index.html"
}

$urls = $countries | ForEach-Object { "https://$SITE_HOST/$_/" }
$urls | Set-Content "sitemap-world.txt"

$config = @{
  version = 2
  cleanUrls = $true
  rewrites = @(@{ source="/(.*)"; destination="/$1" })
} | ConvertTo-Json -Depth 5

$config | Set-Content vercel.json

vercel --prod --yes --force
