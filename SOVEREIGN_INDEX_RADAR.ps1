$base = "https://yishen.ai"
$NATIONS = @("us","sa","mx","br","ae","de","fr","jp","kr")

Write-Host "SOVEREIGN INDEX RADAR BOOTING..." -ForegroundColor Cyan

$missing = @()

foreach ($n in $NATIONS) {
    $url = "$base/$n"
    try {
        $resp = Invoke-WebRequest -Uri $url -UseBasicParsing -TimeoutSec 10
        if ($resp.StatusCode -ne 200) { $missing += $n }
        else { Write-Host "OK → $url" -ForegroundColor Green }
    } catch {
        Write-Host "MISS → $url" -ForegroundColor Yellow
        $missing += $n
    }
}

if ($missing.Count -gt 0) {
    Write-Host "`nMISSING NATIONS DETECTED → $($missing -join ', ')" -ForegroundColor Red
    foreach ($m in $missing) {
        Invoke-WebRequest "https://www.yandex.com/ping?sitemap=https://yishen.ai/sitemap.xml" -UseBasicParsing
        Invoke-WebRequest "https://www.bing.com/indexnow?url=https://yishen.ai/$m&key=sovereignradar" -UseBasicParsing
        Write-Host "RE-FIRED → $m" -ForegroundColor Magenta
    }
} else {
    Write-Host "`nALL NATIONS INDEXED." -ForegroundColor Green
}

Write-Host "`nSOVEREIGN INDEX RADAR COMPLETE" -ForegroundColor Green
