$LIST = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site\submit_list.txt"

$PING = @(
  "https://www.google.com/ping?sitemap=",
  "https://www.bing.com/ping?sitemap=",
  "https://search.yahoo.com/ping?sitemap="
)

foreach ($url in Get-Content $LIST) {
  foreach ($engine in $PING) {
    $pingUrl = "$engine$url"
    try {
      Invoke-WebRequest -Uri $pingUrl -UseBasicParsing -TimeoutSec 10 | Out-Null
      Write-Host "🚀 SUBMITTED $pingUrl"
    } catch {
      Write-Host "⚠️ FAIL $pingUrl"
    }
  }
}

Write-Host "🌐 GLOBAL MASS SUBMIT COMPLETE"
