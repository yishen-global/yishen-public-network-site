$ErrorActionPreference="Stop"
$root = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$sitemap = "$root\sitemap.matrix.xml"
$bing = "https://www.bing.com/indexnow"

Write-Host "`n=== SOVEREIGN INDEXNOW ALL-DOMAIN MATRIX ===" -ForegroundColor Cyan

# Load key
$key = Get-Content "$root\key.txt" -Raw
if($key.Length -lt 20){ throw "Invalid key.txt" }

# Load sitemap via XML engine (immune to regex)
[xml]$xml = Get-Content $sitemap
$urls = $xml.urlset.url.loc

Write-Host "TOTAL URLS: $($urls.Count)" -ForegroundColor Green

# Group by domain
$groups = $urls | Group-Object { ([uri]$_).Host }

foreach($g in $groups){

    Write-Host "`n>>> PUSH DOMAIN: $($g.Name)" -ForegroundColor Cyan

    $payload = @{
        host = $g.Name
        key = $key.Trim()
        keyLocation = "https://$($g.Name)/key.txt"
        urlList = $g.Group
    } | ConvertTo-Json -Depth 10

    try{
        Invoke-RestMethod -Uri $bing -Method POST `
            -ContentType "application/json; charset=utf-8" `
            -Body $payload -TimeoutSec 30

        Write-Host "OK -> $($g.Name)" -ForegroundColor Green
    }catch{
        Write-Host "FAIL -> $($g.Name)" -ForegroundColor Red
        $_.Exception.Response.StatusCode
    }
}

Write-Host "`n=== ALL DOMAIN PUSH COMPLETE ===" -ForegroundColor Green
