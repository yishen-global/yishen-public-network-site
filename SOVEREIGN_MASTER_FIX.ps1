$ErrorActionPreference="Stop"

# ===== FORCE ROOT =====
$SITE_ROOT="J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$PUBLIC_ROOT="$SITE_ROOT\public"
Write-Host "⚓ Sovereign Root Locked: $SITE_ROOT" -ForegroundColor Cyan

# ===== CLEAR DEPLOY POLLUTION =====
Remove-Item "$SITE_ROOT\vercel.json" -ErrorAction SilentlyContinue
Remove-Item "$SITE_ROOT\.vercel" -Recurse -Force -ErrorAction SilentlyContinue
Remove-Item "$SITE_ROOT\.vercelignore" -ErrorAction SilentlyContinue

# ===== UPGRADE CLI =====
npm i -g vercel@latest

# ===== REBUILD VERCEL.JSON =====
$routes=@(
 @{handle="filesystem"},
 @{src="^/contact/?$";dest="/contact.html"},
 @{src="^/confirm/?$";dest="/confirm.html"},
 @{src="^/solutions/?$";dest="/solutions.html"},
 @{src="^/resources/?$";dest="/resources.html"},
 @{src="^/sovereign-matrix/?$";dest="/sovereign-matrix.html"},
 @{src="^/(.*)$";dest="/index.html"}
)
$obj=[ordered]@{version=2;cleanUrls=$true;trailingSlash=$false;routes=$routes}
$json=($obj|ConvertTo-Json -Depth 8)
[IO.File]::WriteAllText("$SITE_ROOT\vercel.json",$json,(New-Object System.Text.UTF8Encoding($false)))

# ===== FORCE DEPLOY =====
Set-Location $SITE_ROOT
vercel --prod --yes --force

Write-Host "🛡️ SOVEREIGN ROOT RESTORED · DEPLOY COMPLETE" -ForegroundColor Green
