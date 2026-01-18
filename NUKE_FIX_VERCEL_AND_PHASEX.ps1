$ErrorActionPreference = "Stop"
[Console]::OutputEncoding = [System.Text.UTF8Encoding]::new($false)

$SITE_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

Write-Host "🔥 NUKING broken vercel.json..." -ForegroundColor Red
Remove-Item "$SITE_ROOT\vercel.json" -Force -ErrorAction SilentlyContinue

$vercelObject = @{
  version = 2
  cleanUrls = $true
  trailingSlash = $false
  routes = @(
    @{ src = "^/robots\.txt$"; dest = "/robots.txt" }
    @{ src = "^/sitemap\.index\.xml$"; dest = "/sitemap.index.xml" }
    @{ src = "^/sitemap\.world\.xml$"; dest = "/sitemap.world.xml" }
    @{ src = "^/sitemap\.cities\.xml$"; dest = "/sitemap.cities.xml" }
    @{ src = "^/sitemap\.matrix\.xml$"; dest = "/sitemap.matrix.xml" }
    @{ src = "^/$"; dest = "/index.html" }
    @{ src = "^/index/?$"; dest = "/index.html" }
    @{ src = "^/contact/?$"; dest = "/contact.html" }
    @{ src = "^/solutions/?$"; dest = "/solutions.html" }
    @{ handle = "filesystem" }
    @{ src = "^(.*)$"; dest = "/index.html" }
  )
}

$vercelJson = $vercelObject | ConvertTo-Json -Depth 10
[IO.File]::WriteAllText("$SITE_ROOT\vercel.json", $vercelJson, [System.Text.UTF8Encoding]::new($false))

Write-Host "✔ vercel.json REBUILT" -ForegroundColor Green

Write-Host "🚀 Re-running PHASE IX WORLD 200"
cd "J:\YISHEN_SOVEREIGN_GROWTH_OS\DEPLOY"
.\PHASE_IX_WORLD_200.ps1

Write-Host "🚀 Deploying to Vercel"
cd $SITE_ROOT
vercel --prod --force
