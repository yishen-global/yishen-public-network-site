$ErrorActionPreference = "SilentlyContinue"

$BASE = Split-Path -Parent $MyInvocation.MyCommand.Path

$KEY  = (Get-Content "$BASE\key.txt").Trim()
$URLS = Get-Content "$BASE\submit_list.txt" | Where-Object { $_ -match "^https?://" }

$APIS = @(
 "https://api.indexnow.org/indexnow",
 "https://www.bing.com/indexnow",
 "https://search.seznam.cz/indexnow"
)

$BATCH = 100
$SLEEP = 800

$total = $URLS.Count
$sent  = 0

Write-Host "`n🌍 YISHEN GLOBAL SOVEREIGN INDEX ENGINE"
Write-Host "-------------------------------------"
Write-Host "TOTAL URLS: $total"
Write-Host ""

for ($i=0; $i -lt $total; $i+=$BATCH) {

  $batch = $URLS[$i..([Math]::Min($i+$BATCH-1,$total-1))]

  $payload = @{
    host = ([System.Uri]$batch[0]).Host
    key  = $KEY
    keyLocation = "https://$(([System.Uri]$batch[0]).Host)/$KEY.txt"
    urlList = $batch
  } | ConvertTo-Json -Depth 4

  foreach ($api in $APIS) {
    try {
      Invoke-RestMethod -Uri $api -Method POST -ContentType "application/json" -Body $payload | Out-Null
      Write-Host "✅ $api batch $i"
    } catch {
      Write-Host "⚠️ $api batch $i"
    }
  }

  $sent += $batch.Count
  Start-Sleep -Milliseconds $SLEEP
}

Write-Host "`n🚀 INDEXNOW SUBMIT DONE"
Write-Host "SUBMITTED: $sent / $total"
Write-Host "CRAWLERS WARMING UP..."
