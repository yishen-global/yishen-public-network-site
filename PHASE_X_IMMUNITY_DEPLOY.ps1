# ==========================================================
# PHASE-X : ROUTE IMMUNITY + VERCEL.JSON FIX + DEPLOY
# Root: J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site
# ==========================================================

$ErrorActionPreference = "Stop"

$SITE_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$DEPLOY_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\DEPLOY"

Write-Host "=== PHASE-X START : IMMUNITY + DEPLOY ===" -ForegroundColor Cyan
Write-Host "SITE_ROOT: $SITE_ROOT" -ForegroundColor DarkGray

if (!(Test-Path $SITE_ROOT)) {
  throw "SITE_ROOT not found: $SITE_ROOT"
}

# 0) Ensure required files exist (robots/key/sitemaps)
# ----------------------------------------------------------
# robots.txt (basic, you can customize)
$robotsPath = Join-Path $SITE_ROOT "robots.txt"
if (!(Test-Path $robotsPath)) {
@"
User-agent: *
Allow: /

Sitemap: https://yishen.ai/sitemap.index.xml
"@ | Set-Content -Path $robotsPath -Encoding utf8
  Write-Host "OK robots.txt created" -ForegroundColor Green
} else {
  Write-Host "OK robots.txt exists" -ForegroundColor Green
}

# key.txt (IndexNow key file) - if you already have it elsewhere, copy it here
$keyPath = Join-Path $SITE_ROOT "key.txt"
if (!(Test-Path $keyPath)) {
  $maybeKey = Join-Path $SITE_ROOT "indexnow_key.txt"
  if (Test-Path $maybeKey) {
    Copy-Item $maybeKey $keyPath -Force
    Write-Host "OK key.txt copied from indexnow_key.txt" -ForegroundColor Green
  } else else {
    Write-Host "WARN key.txt not found. (IndexNow needs it) You can create later." -ForegroundColor Yellow
  }
} else {
  Write-Host "OK key.txt exists" -ForegroundColor Green
}

# 1) Build a VALID vercel.json (NO parse error)
# ----------------------------------------------------------
# Important: whitelist files first, then allow filesystem, then rewrite.
$vercelObj = @{
  version = 2
  routes  = @(
    # Immunity whitelist (NEVER rewrite these)
    @{ src = "^/robots\.txt$";        dest = "/robots.txt" }
    @{ src = "^/key\.txt$";           dest = "/key.txt" }
    @{ src = "^/sitemap\.index\.xml$"; dest = "/sitemap.index.xml" }
    @{ src = "^/sitemap\.world\.xml$"; dest = "/sitemap.world.xml" }
    @{ src = "^/sitemap\.matrix\.xml$"; dest = "/sitemap.matrix.xml" }
    @{ src = "^/sitemap\.xml$";       dest = "/sitemap.xml" }

    # If file exists, serve it
    @{ handle = "filesystem" }

    # Home
    @{ src = "^/$"; dest = "/index.html" }

    # Two-letter country node: /us  or /us/  -> /us.html
    @{ src = "^/([a-z]{2})/?$"; dest = "/$1.html" }

    # Common pages (optional, if you have these html files)
    @{ src = "^/home/?$";      dest = "/index.html" }
    @{ src = "^/why-us/?$";    dest = "/why-us.html" }
    @{ src = "^/solutions/?$"; dest = "/solutions.html" }
    @{ src = "^/contact/?$";   dest = "/contact.html" }
    @{ src = "^/confirm/?$";   dest = "/confirm.html" }

    # Final fallback (SPA-like): everything else -> index.html
    @{ src = "^/(.*)$"; dest = "/index.html" }
  )
}

$vercelJsonPath = Join-Path $SITE_ROOT "vercel.json"
($vercelObj | ConvertTo-Json -Depth 20) | Set-Content -Path $vercelJsonPath -Encoding utf8
Write-Host "OK vercel.json written (valid JSON)" -ForegroundColor Green

# 2) Quick sanity check: verify vercel.json is valid JSON
# ----------------------------------------------------------
try {
  Get-Content $vercelJsonPath -Raw | ConvertFrom-Json | Out-Null
  Write-Host "OK vercel.json parse check passed" -ForegroundColor Green
} catch {
  throw "vercel.json still invalid. Abort. Error: $($_.Exception.Message)"
}

# 3) Deploy (force)
# ----------------------------------------------------------
Write-Host "Deploying to Vercel (prod --force)..." -ForegroundColor Cyan
Push-Location $SITE_ROOT
try {
  vercel --prod --force
} finally {
  Pop-Location
}

Write-Host "=== PHASE-X COMPLETE : IMMUNITY + DEPLOY ===" -ForegroundColor Green
Write-Host "Test URLs:" -ForegroundColor Cyan
Write-Host " - https://yishen.ai/robots.txt" -ForegroundColor Gray
Write-Host " - https://yishen.ai/sitemap.index.xml" -ForegroundColor Gray
Write-Host " - https://yishen.ai/key.txt" -ForegroundColor Gray
Write-Host " - https://yishen.ai/us" -ForegroundColor Gray
