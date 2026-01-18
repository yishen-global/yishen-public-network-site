$SITEMAP = "https://yishen.ai/sitemap.xml"

$ENGINES = @(
    "https://www.google.com/ping?sitemap=$SITEMAP",
    "https://www.bing.com/ping?sitemap=$SITEMAP",
    "https://search.yahoo.com/ping?sitemap=$SITEMAP",
    "https://www.yandex.com/ping?sitemap=$SITEMAP",
    "https://naver.me/ping?sitemap=$SITEMAP",
    "https://search.seznam.cz/ping?sitemap=$SITEMAP"
)

Write-Host "GLOBAL SOVEREIGN INDEX FIRE STARTING..." -ForegroundColor Cyan

foreach ($e in $ENGINES) {
    try {
        Invoke-WebRequest -Uri $e -UseBasicParsing -TimeoutSec 15
        Write-Host "INDEX SIGNAL SENT -> $e" -ForegroundColor Green
    }
    catch {
        Write-Host "FAIL -> $e" -ForegroundColor Yellow
    }
}

Write-Host "GLOBAL SEARCH ENGINE IGNITION COMPLETE" -ForegroundColor Green
