$ErrorActionPreference = "SilentlyContinue"

$SITE_PATH = Split-Path -Parent $MyInvocation.MyCommand.Path
$KEY_FILE  = "$SITE_PATH\key.txt"
$LIST_FILE = "$SITE_PATH\submit_list.txt"

$INDEXNOW_APIS = @(
    "https://api.indexnow.org/indexnow",
    "https://www.bing.com/indexnow",
    "https://search.seznam.cz/indexnow"
)

$KEY = (Get-Content $KEY_FILE | Select-Object -First 1).Trim()
$URLS = Get-Content $LIST_FILE | Where-Object { $_ -match "^https?://" }

$BATCH = 100
$SLEEP = 600

$total = $URLS.Count
$sent  = 0

Write-Host "`n🚀 YISHEN SOVEREIGN INDEXNOW ENGINE"
Write-Host "--------------------------------"
Write-Host "KEY: $KEY"
Write-Host "TOTAL URLS: $total"
Write-Host ""

for ($i = 0; $i -lt $total; $i += $BATCH) {

    $batchUrls = $URLS[$i..([Math]::Min($i+$BATCH-1, $total-1))]

    $payload = @{
        host = ([System.Uri]$batchUrls[0]).Host
        key  = $KEY
        keyLocation = "https://$(([System.Uri]$batchUrls[0]).Host)/$KEY.txt"
        urlList = $batchUrls
    } | ConvertTo-Json -Depth 4

    foreach ($api in $INDEXNOW_APIS) {
        try {
            Invoke-RestMethod -Uri $api -Method POST -ContentType "application/json" -Body $payload | Out-Null
            Write-Host "✅ OK $api batch $i"
        } catch {
            Write-Host "⚠️ FAIL $api batch $i"
        }
    }

    $sent += $batchUrls.Count
    Start-Sleep -Milliseconds $SLEEP
}

Write-Host ""
Write-Host "🌍 INDEXNOW SUBMIT DONE."
Write-Host "SUBMITTED: $sent / $total"
Write-Host "CRAWLERS WARMING UP..."
