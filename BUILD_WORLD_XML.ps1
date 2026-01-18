$BASE = "https://yishen.ai"
$GEN_DATE = (Get-Date).ToString("yyyy-MM-dd")

# auto read country folders
$COUNTRIES = Get-ChildItem -Directory | Where-Object {
    $_.Name.Length -eq 2 -and $_.Name -match "^[a-z]{2}$"
} | Select-Object -ExpandProperty Name

$URLS = @()

foreach($cc in $COUNTRIES){
    $URLS += "$BASE/$cc/"
    $URLS += "$BASE/$cc/rfq/"
    $URLS += "$BASE/$cc/autoquote/"
    $URLS += "$BASE/$cc/buyer-radar/"
    $URLS += "$BASE/$cc/distributor/"
}

$xml = @()
$xml += '<?xml version="1.0" encoding="UTF-8"?>'
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'

foreach($u in $URLS){
    $xml += "  <url><loc>$u</loc><lastmod>$GEN_DATE</lastmod></url>"
}

$xml += '</urlset>'

$xml -join "`n" | Set-Content sitemap.world.xml -Encoding UTF8

Write-Host "🌍 WORLD XML GENERATED:" -ForegroundColor Green
Write-Host "   sitemap.world.xml"
Write-Host "   Total URLs:" $URLS.Count
