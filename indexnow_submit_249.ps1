param(
    [Parameter(Mandatory=$true)]
    [string]$Key,

    [Parameter(Mandatory=$true)]
    [string]$Site
)

Write-Host "========================================"
Write-Host "🛡 YISHEN GLOBAL SOVEREIGN INDEX ENGINE"
Write-Host "========================================"
Write-Host "🌍 SITE:" $Site
Write-Host "🔑 KEY:" $Key
Write-Host "----------------------------------------"

$listFile = "submit_list_249.txt"

if (!(Test-Path $listFile)) {
    Write-Host "❌ submit_list_249.txt not found." -ForegroundColor Red
    exit
}

$urls = Get-Content $listFile | Where-Object { $_ -match '^https?://' }

Write-Host "TOTAL URLS:" $urls.Count
Write-Host "----------------------------------------"

$headers = @{
    "Content-Type" = "application/json"
}

$body = @{
    host = $Site
    key  = $Key
    urlList = $urls
} | ConvertTo-Json -Depth 5

$endpoints = @(
    "https://api.indexnow.org/indexnow",
    "https://www.bing.com/indexnow",
    "https://search.seznam.cz/indexnow"
)

foreach ($endpoint in $endpoints) {
    try {
        Write-Host "🚀 Submitting to $endpoint ..."
        $res = Invoke-RestMethod -Uri $endpoint -Method POST -Headers $headers -Body $body
        Write-Host "✔ SUCCESS" -ForegroundColor Green
    } catch {
        Write-Host "❌ FAILED: $endpoint" -ForegroundColor Red
    }
}

Write-Host "========================================"
Write-Host "🌐 WORLD FRACTAL SUBMIT COMPLETE"
Write-Host "========================================"
