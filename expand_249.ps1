param(
  [string]$Domain = "https://yishen.ai",
  [string]$PublicDir = ".\public",
  [string]$NationList = ".\nations_249.txt",
  [string]$SitemapOut = ".\sitemap-world.xml",
  [string]$SubmitListOut = ".\submit_list_249.txt",
  [switch]$Force
)

$ErrorActionPreference = "Stop"

if (!(Test-Path $NationList)) { throw "Missing: $NationList" }
if (!(Test-Path $PublicDir)) { New-Item -ItemType Directory -Force $PublicDir | Out-Null }

$codes = Get-Content $NationList | ForEach-Object { $_.Trim().ToLower() } | Where-Object { $_ -and ($_ -notmatch "^\s*#") } | Select-Object -Unique
if ($codes.Count -lt 1) { throw "No nation codes found in $NationList" }

Write-Host "🔥 YISHEN 249 NATION SOVEREIGN ENGINE" -ForegroundColor Green
Write-Host ("TOTAL NATIONS: {0}" -f $codes.Count)

# --- Generate nation pages ---
foreach ($c in $codes) {
  $dir = Join-Path $PublicDir $c
  $index = Join-Path $dir "index.html"
  if (!(Test-Path $dir)) { New-Item -ItemType Directory -Force $dir | Out-Null }

  if ((Test-Path $index) -and (-not $Force)) {
    Write-Host "↪ skip $c (exists)" -ForegroundColor DarkGray
    continue
  }

  $html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width, initial-scale=1"/>
  <title>YiShen Global · $c</title>
  <link rel="canonical" href="$Domain/$c/"/>
  <meta name="robots" content="index,follow"/>
</head>
<body>
  <h1>YiShen Global · $c</h1>
  <p>Sovereign Nation Node: <b>$c</b></p>
</body>
</html>
"@
  $html | Set-Content -Encoding UTF8 $index
  Write-Host "✅ node $c generated"
}

# --- Build submit list (absolute URLs) ---
$urls = $codes | ForEach-Object { "$Domain/$($_)/" }
$urls | Set-Content -Encoding UTF8 $SubmitListOut
Write-Host "✅ submit list written: $SubmitListOut" -ForegroundColor Green

# --- Build sitemap-world.xml ---
$ts = (Get-Date).ToString("yyyy-MM-dd")
$xml = @()
$xml += '<?xml version="1.0" encoding="UTF-8"?>'
$xml += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
foreach ($u in $urls) {
  $xml += "  <url><loc>$u</loc><lastmod>$ts</lastmod></url>"
}
$xml += '</urlset>'
$xml -join "`n" | Set-Content -Encoding UTF8 $SitemapOut
Write-Host "✅ sitemap written: $SitemapOut" -ForegroundColor Green

Write-Host "🚀 DONE. Next: IndexNow submit" -ForegroundColor Yellow
