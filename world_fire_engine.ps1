param(
    [string]$Mode = "GLOBAL",
    [switch]$InjectSitemap,
    [switch]$AutoIndex,
    [switch]$FullMesh
)

$DEMO_MODE = $false

$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK"
$CITY_DB = "$ROOT\world_cities\world_full_cities.json"
$SITE = "$ROOT\site"
$SITEMAP = "$SITE\sitemap.xml"

Write-Host "YISHEN GLOBAL FIRE ENGINE"

$cities = Get-Content $CITY_DB -Encoding UTF8 | ConvertFrom-Json

foreach ($c in $cities) {
    $city = $c.city.ToLower().Replace(" ","-")
    $cc   = $c.country_code.ToLower()
    $path = "$SITE\$cc\$city"
    if (!(Test-Path $path)) { New-Item -ItemType Directory -Path $path | Out-Null }

@"
<!DOCTYPE html>
<html><head><title>$($c.city)</title></head>
<body><h1>$($c.city), $($c.country_name)</h1></body>
</html>
"@ | Set-Content "$path\index.html" -Encoding UTF8
}

Write-Host "GLOBAL FIRE COMPLETED"
Write-Host "TOTAL CITIES:" $cities.Count
