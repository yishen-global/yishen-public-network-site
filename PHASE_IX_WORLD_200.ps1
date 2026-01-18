# ==============================
# PHASE-IX WORLD 200 IGNITER
# YiShen Sovereign Country Matrix
# ==============================

$ErrorActionPreference = "Stop"

# ---- CONFIG ----
$SITE_ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$DOMAIN_PRIMARY = "https://yishen.ai"   # 你主域名（可改 yishenglobal.net）
$INDEXNOW_HOST  = "yishen.ai"           # 只填域名，不带 https
$ENABLE_VERCEL_DEPLOY = $false          # true=跑完自动 vercel --prod --force
$ENABLE_INDEXNOW_PUSH = $false          # true=跑完自动 IndexNow 推送
# ----------------

# 200+ country codes (ISO-ish, enough for matrix ignition)
$COUNTRIES = @(
"us","ca","mx","br","ar","cl","co","pe","ec","uy","py","bo","ve","gt","hn","sv","ni","cr","pa","do",
"gb","ie","fr","de","it","es","pt","nl","be","lu","ch","at","dk","se","no","fi","is","pl","cz","sk","hu",
"ro","bg","gr","cy","mt","si","hr","rs","ba","me","mk","al","lt","lv","ee","ua","md",
"tr","il","sa","ae","qa","kw","om","bh","jo","lb","iq","ir","eg","ma","dz","tn","ly","sd",
"ng","gh","ci","sn","cm","ke","tz","ug","rw","et","za","zm","zw","mz","ao","na","bw","mg",
"in","pk","bd","lk","np","bt","mv",
"cn","hk","mo","tw","jp","kr","sg","my","th","vn","ph","id","kh","la","mm","bn","tl",
"au","nz","pg","fj","sb","vu","ws","to",
"ru","kz","uz","kg","tj","tm","mn","az","am","ge"
)

function Ensure-Dir($p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Path $p | Out-Null } }

Write-Host "`n=== PHASE-IX WORLD 200 START ===" -ForegroundColor Cyan
Write-Host "SITE_ROOT: $SITE_ROOT" -ForegroundColor DarkGray

Ensure-Dir $SITE_ROOT

# 1) base index.html (if missing)
$indexFile = Join-Path $SITE_ROOT "index.html"
if(!(Test-Path $indexFile)){
@"
<!doctype html><html><head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>YiShen AI · Global Sovereign Gateway</title>
<link rel="canonical" href="$DOMAIN_PRIMARY/"/>
</head><body style="font-family:system-ui;margin:40px;">
<h1>YiShen AI · Global Gateway</h1>
<p>200-country node matrix is live.</p>
<p><a href="/sitemap.index.xml">Sitemap Index</a></p>
</body></html>
"@ | Set-Content $indexFile -Encoding UTF8
}

# 2) generate 200 country pages
$generated = 0
foreach($cc in $COUNTRIES){
  $cc = $cc.ToLower()
  $file = Join-Path $SITE_ROOT "$cc.html"
@"
<!doctype html><html><head>
<meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>YiShen AI · $cc Sovereign Node</title>
<link rel="canonical" href="$DOMAIN_PRIMARY/$cc"/>
<meta name="robots" content="index,follow"/>
</head><body style="font-family:system-ui;margin:40px;">
<h1>YiShen AI · Sovereign Node: $cc</h1>
<p>Country gateway node for $cc.</p>
<p><a href="/">Home</a> · <a href="/contact">Contact</a> · <a href="/solutions">Solutions</a></p>
</body></html>
"@ | Set-Content $file -Encoding UTF8
  $generated++
}

Write-Host "OK generated country HTML: $generated" -ForegroundColor Green

# 3) 404 immunity: copy all html to root already (they are in root)
# (If you have nested folders, you can uncomment below)
# Get-ChildItem -Path $SITE_ROOT -Filter "*.html" -Recurse | ForEach-Object {
#   $target = Join-Path $SITE_ROOT $_.Name
#   if($_.FullName -ne $target){ Copy-Item $_.FullName $target -Force }
# }

# 4) build sitemap.world.xml
$worldSitemap = Join-Path $SITE_ROOT "sitemap.world.xml"
$urls = New-Object System.Collections.Generic.List[string]
$urls.Add("$DOMAIN_PRIMARY/")

foreach($cc in $COUNTRIES){
  $urls.Add("$DOMAIN_PRIMARY/$cc")
}

$sb = New-Object System.Text.StringBuilder
$null = $sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
$null = $sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
foreach($u in $urls){
  $null = $sb.AppendLine("  <url><loc>$u</loc></url>")
}
$null = $sb.AppendLine('</urlset>')
$sb.ToString() | Set-Content $worldSitemap -Encoding UTF8
Write-Host "OK sitemap.world.xml" -ForegroundColor Green

# 5) sitemap.index.xml
$sitemapIndex = Join-Path $SITE_ROOT "sitemap.index.xml"
@"
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap><loc>$DOMAIN_PRIMARY/sitemap.world.xml</loc></sitemap>
</sitemapindex>
"@ | Set-Content $sitemapIndex -Encoding UTF8
Write-Host "OK sitemap.index.xml" -ForegroundColor Green

# 6) robots.txt
$robots = Join-Path $SITE_ROOT "robots.txt"
@"
User-agent: *
Allow: /
Sitemap: $DOMAIN_PRIMARY/sitemap.index.xml
"@ | Set-Content $robots -Encoding ASCII
Write-Host "OK robots.txt" -ForegroundColor Green

# 7) vercel.json (routing + cleanUrls + trailingSlash=false)
$vercelJson = Join-Path $SITE_ROOT "vercel.json"
@"
{
  "version": 2,
  "cleanUrls": true,
  "trailingSlash": false,
  "routes": [
    { "src": "^/$", "dest": "/index.html" },
    { "src": "^/([a-z]{2})/?$", "dest": "/\$1.html" },
    { "src": "^/contact/?$", "dest": "/contact.html" },
    { "src": "^/solutions/?$", "dest": "/solutions.html" },
    { "src": "^(.*)$", "dest": "/index.html" }
  ]
}
"@ | Set-Content $vercelJson -Encoding UTF8
Write-Host "OK vercel.json (404 immunity routes)" -ForegroundColor Green

# 8) sitemap.matrix.xml for IndexNow
$matrix = Join-Path $SITE_ROOT "sitemap.matrix.xml"
$sb2 = New-Object System.Text.StringBuilder
$null = $sb2.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
$null = $sb2.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
foreach($u in $urls){
  $null = $sb2.AppendLine("  <url><loc>$u</loc></url>")
}
$null = $sb2.AppendLine('</urlset>')
$sb2.ToString() | Set-Content $matrix -Encoding UTF8
Write-Host "OK sitemap.matrix.xml (IndexNow list)" -ForegroundColor Green

# 9) optional deploy
if($ENABLE_VERCEL_DEPLOY){
  Write-Host "Deploying to Vercel..." -ForegroundColor Cyan
  Push-Location $SITE_ROOT
  vercel --prod --force
  Pop-Location
}

# 10) optional IndexNow push
if($ENABLE_INDEXNOW_PUSH){
  $keyFile = Join-Path $SITE_ROOT "key.txt"
  if(!(Test-Path $keyFile)){
    # create key if missing
    $key = -join ((48..57)+(65..90)+(97..122) | Get-Random -Count 32 | ForEach-Object {[char]$_})
    Set-Content $keyFile $key -Encoding ASCII
  }else{
    $key = (Get-Content $keyFile -Raw).Trim()
  }

  $urlsToPush = $urls.ToArray()
  $bingEndpoint = "https://www.bing.com/indexnow"
  $payload = @{
    host = $INDEXNOW_HOST
    key = $key
    keyLocation = "https://$INDEXNOW_HOST/key.txt"
    urlList = $urlsToPush
  } | ConvertTo-Json -Depth 6

  Write-Host "IndexNow pushing ${($urlsToPush.Count)} URLs..." -ForegroundColor Cyan
  [Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
  Invoke-RestMethod -Uri $bingEndpoint -Method POST -ContentType "application/json; charset=utf-8" -Body $payload -TimeoutSec 30 | Out-Null
  Write-Host "OK IndexNow push complete." -ForegroundColor Green
}

Write-Host "`n=== PHASE-IX WORLD 200 COMPLETE ===" -ForegroundColor Green
Write-Host "Open: $DOMAIN_PRIMARY/sitemap.index.xml" -ForegroundColor DarkGray
