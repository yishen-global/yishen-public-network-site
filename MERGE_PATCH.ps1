# ============================================================
# MERGE_PATCH.ps1  (YiShen Sovereign Takeover Patch)
# - One-click merge + 404 immunity + route sovereignty + deploy-ready
# - DO NOT mix routes with rewrites/redirects/headers/cleanUrls/trailingSlash
# ============================================================

$ErrorActionPreference = "Stop"

# === 0) Set your SITE ROOT (edit if needed)
$SITE_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

Write-Host "=== YiShen Sovereign Takeover Patch ===" -ForegroundColor Cyan
Write-Host "SITE_ROOT: $SITE_ROOT" -ForegroundColor Yellow

if (!(Test-Path $SITE_ROOT)) {
  throw "SITE_ROOT not found: $SITE_ROOT"
}

Set-Location $SITE_ROOT

# === 1) Backup
$backupDir = Join-Path $SITE_ROOT ("_backup_" + (Get-Date -Format "yyyyMMdd_HHmmss"))
New-Item -ItemType Directory -Path $backupDir | Out-Null

Get-ChildItem -Path $SITE_ROOT -Force | ForEach-Object {
  if ($_.Name -notmatch "^_backup_") {
    Copy-Item $_.FullName -Destination $backupDir -Recurse -Force
  }
}

Write-Host "Backup created: $backupDir" -ForegroundColor Green

# === 2) Ensure index.html exists (hard requirement)
if (!(Test-Path (Join-Path $SITE_ROOT "index.html"))) {
  # Try to promote home.html or publicpassport.html if exists
  if (Test-Path (Join-Path $SITE_ROOT "home.html")) {
    Copy-Item (Join-Path $SITE_ROOT "home.html") (Join-Path $SITE_ROOT "index.html") -Force
    Write-Host "index.html created from home.html" -ForegroundColor Green
  }
  elseif (Test-Path (Join-Path $SITE_ROOT "publicpassport.html")) {
    Copy-Item (Join-Path $SITE_ROOT "publicpassport.html") (Join-Path $SITE_ROOT "index.html") -Force
    Write-Host "index.html created from publicpassport.html" -ForegroundColor Green
  }
  else {
    # Create a minimal index.html
    @"
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>YiShen Global</title></head><body>
<h1>YiShen Global</h1>
<p>index.html was missing and has been auto-created by MERGE_PATCH.ps1.</p>
</body></html>
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "index.html")
    Write-Host "index.html auto-created (minimal)" -ForegroundColor Yellow
  }
}

# === 3) Create 404.html that never dies (fallback page)
@"
<!doctype html><html><head><meta charset="utf-8"><meta name="viewport" content="width=device-width,initial-scale=1">
<title>YiShen Global · Redirecting</title>
<meta http-equiv="refresh" content="0; url=/" />
<style>body{font-family:system-ui,Segoe UI,Arial;margin:40px;line-height:1.6}</style>
</head><body>
<h2>Routing Sovereignty Active</h2>
<p>If you see this page, the system is redirecting you to the Sovereign Home.</p>
<p><a href="/">Go Home</a></p>
</body></html>
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "404.html")

Write-Host "404.html generated" -ForegroundColor Green

# === 4) robots.txt (allow crawl; you can tighten later)
@"
User-agent: *
Allow: /
Sitemap: /sitemap.xml
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "robots.txt")

Write-Host "robots.txt generated" -ForegroundColor Green

# === 5) package.json (static site marker; safe even without build)
if (!(Test-Path (Join-Path $SITE_ROOT "package.json"))) {
@"
{
  "name": "yishen-sovereign-site",
  "private": true,
  "version": "1.0.0",
  "scripts": {
    "build": "echo build-ok",
    "start": "echo start-ok"
  }
}
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "package.json")
  Write-Host "package.json generated" -ForegroundColor Green
} else {
  Write-Host "package.json exists (kept)" -ForegroundColor DarkGreen
}

# === 6) vercel.json (ONLY routes, no rewrites/redirects/etc)
# IMPORTANT: This prevents the 'mix routing props' error.
@"
{
  "version": 2,
  "builds": [
    { "src": "**/*.html", "use": "@vercel/static" },
    { "src": "**/*", "use": "@vercel/static" }
  ],
  "routes": [
    { "src": "^/$", "dest": "/index.html" },

    { "src": "^/([^/.]+)$", "dest": "/$1.html" },
    { "src": "^/(.+)/([^/.]+)$", "dest": "/$1/$2.html" },

    { "src": "^/robots\\.txt$", "dest": "/robots.txt" },
    { "src": "^/sitemap\\.xml$", "dest": "/sitemap.xml" },

    { "handle": "filesystem" },

    { "src": ".*", "dest": "/index.html" }
  ]
}
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "vercel.json")

Write-Host "vercel.json generated (routes-only, 404 immunity enabled)" -ForegroundColor Green

# === 7) OPTIONAL: Ensure sitemap.xml exists (placeholder)
if (!(Test-Path (Join-Path $SITE_ROOT "sitemap.xml"))) {
@"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>/</loc></url>
</urlset>
"@ | Set-Content -Encoding UTF8 (Join-Path $SITE_ROOT "sitemap.xml")
  Write-Host "sitemap.xml placeholder generated" -ForegroundColor Yellow
} else {
  Write-Host "sitemap.xml exists (kept)" -ForegroundColor DarkGreen
}

# === 8) Quick sanity
Write-Host "`n=== SANITY CHECK ===" -ForegroundColor Cyan
Write-Host "index.html:  " (Test-Path (Join-Path $SITE_ROOT "index.html"))
Write-Host "404.html:    " (Test-Path (Join-Path $SITE_ROOT "404.html"))
Write-Host "vercel.json: " (Test-Path (Join-Path $SITE_ROOT "vercel.json"))
Write-Host "robots.txt:  " (Test-Path (Join-Path $SITE_ROOT "robots.txt"))

Write-Host "`n✅ MERGE PATCH DONE. Next: deploy (optional) with DEPLOY_VERCEL.ps1" -ForegroundColor Green
