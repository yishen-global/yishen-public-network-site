# ================= PHASE-X FINAL =================
$ErrorActionPreference = "Stop"

$SITE_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
Write-Host "PHASE-X FINAL START" -ForegroundColor Cyan

if (!(Test-Path $SITE_ROOT)) { throw "SITE_ROOT not found" }

# robots.txt
$robots = Join-Path $SITE_ROOT "robots.txt"
if (!(Test-Path $robots)) {
@"
User-agent: *
Allow: /

Sitemap: https://yishen.ai/sitemap.index.xml
"@ | Set-Content $robots -Encoding utf8
}

# build valid vercel.json
$vercel = @{
  version = 2
  routes = @(
    @{ src="^/robots\.txt$"; dest="/robots.txt" },
    @{ src="^/key\.txt$"; dest="/key.txt" },
    @{ src="^/sitemap\.index\.xml$"; dest="/sitemap.index.xml" },
    @{ src="^/sitemap\.world\.xml$"; dest="/sitemap.world.xml" },
    @{ src="^/sitemap\.matrix\.xml$"; dest="/sitemap.matrix.xml" },
    @{ handle="filesystem" },
    @{ src="^/$"; dest="/index.html" },
    @{ src="^/([a-z]{2})/?$"; dest="/$1.html" },
    @{ src="^/(.*)$"; dest="/index.html" }
  )
}

$vercelPath = Join-Path $SITE_ROOT "vercel.json"
($vercel | ConvertTo-Json -Depth 10) | Set-Content $vercelPath -Encoding utf8

# JSON sanity
Get-Content $vercelPath -Raw | ConvertFrom-Json | Out-Null
Write-Host "vercel.json OK"

# deploy
Push-Location $SITE_ROOT
vercel --prod --force
Pop-Location

Write-Host "PHASE-X FINAL COMPLETE" -ForegroundColor Green
