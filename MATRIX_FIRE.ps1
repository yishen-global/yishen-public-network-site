# ================================
# PHASE XI · START MATRIX
# YiShen AI Sovereign Node Matrix Builder
# Output:
#   /sitemap.matrix.xml
#   /sitemap.index.xml (points to matrix)
#   /robots.txt (declares sitemaps)
#   /<cc>/index.html (country nodes)
#   /<cc>/sitemap.xml (per-country sitemaps)
# ================================

$ErrorActionPreference = "Stop"

$SITE_ROOT = (Get-Location).Path
Write-Host "✅ SITE_ROOT = $SITE_ROOT" -ForegroundColor Cyan

# ---- Config ----
$BASE = "https://yishen.ai"
$GEN_DATE = (Get-Date).ToString("yyyy-MM-dd")

# 200-country-ish list (ISO 3166-1 alpha-2, lowercase)
# You can add/remove anytime.
$COUNTRIES = @(
"us","ca","mx","br","ar","cl","co","pe","ec","uy","py","bo","ve",
"gb","ie","fr","de","it","es","pt","nl","be","lu","ch","at","se","no","dk","fi","pl","cz","sk","hu","ro","bg","gr","hr","si","rs","ba","me","al","mk","lt","lv","ee","ua",
"tr","ru","kz","uz","kg","tj","tm","az","ge","am",
"sa","ae","qa","kw","om","bh","jo","il","eg","ma","dz","tn","ly","sd","et","ke","tz","ug","ng","gh","ci","sn","cm","za",
"in","pk","bd","lk","np",
"cn","hk","tw","jp","kr","sg","my","th","vn","ph","id","au","nz",
"ir","iq","sy","lb","ye",
"mm","kh","la","mn",
"af","ne","ml","bf","rw","bi","zw","zm","mw","mz","ao","na","bw"
) | Select-Object -Unique

# Ensure root files exist
function Ensure-Dir($p) { if (!(Test-Path $p)) { New-Item -ItemType Directory -Path $p | Out-Null } }

# Create a minimal country node page
function Country-IndexHtml($cc) {
@"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>YiShen AI · $cc Node</title>
  <meta name="robots" content="index,follow"/>
  <link rel="canonical" href="$BASE/$cc/"/>
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;max-width:920px;margin:56px auto;padding:0 18px;line-height:1.45}
    h1{font-size:34px;margin:0 0 8px}
    .tag{display:inline-block;padding:6px 10px;border:1px solid #ddd;border-radius:999px;margin:10px 0 18px}
    a{color:#0b5; text-decoration:none}
    a:hover{text-decoration:underline}
    .grid{display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px;margin-top:18px}
    .card{border:1px solid #eee;border-radius:14px;padding:14px}
    .muted{color:#666}
  </style>
</head>
<body>
  <h1>YiShen AI · $cc Sovereign Node</h1>
  <div class="tag">Country Node Matrix · Live</div>
  <p class="muted">This node is part of the global sovereign gateway network. Indexed for discovery + RFQ routing.</p>

  <div class="grid">
    <div class="card"><b>RFQ Core</b><br/><span class="muted">Request pricing & sourcing</span><br/><a href="$BASE/$cc/rfq/">Open</a></div>
    <div class="card"><b>AutoQuote</b><br/><span class="muted">Instant quote engine</span><br/><a href="$BASE/$cc/autoquote/">Open</a></div>
    <div class="card"><b>Buyer Radar</b><br/><span class="muted">High-intent buyer signals</span><br/><a href="$BASE/$cc/buyer-radar/">Open</a></div>
    <div class="card"><b>Distributor Vault</b><br/><span class="muted">Local distribution pathways</span><br/><a href="$BASE/$cc/distributor/">Open</a></div>
  </div>

  <p style="margin-top:26px">
    <a href="$BASE/sitemap.index.xml">Sitemap Index</a> ·
    <a href="$BASE/sitemap.matrix.xml">Sitemap Matrix</a> ·
    <a href="$BASE/$cc/sitemap.xml">Node Sitemap</a>
  </p>

  <p class="muted" style="margin-top:10px">Generated: $GEN_DATE</p>
</body>
</html>
"@
}

# Create a per-country sitemap.xml
function Country-SitemapXml($cc) {
@"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <url><loc>$BASE/$cc/</loc><lastmod>$GEN_DATE</lastmod></url>
  <url><loc>$BASE/$cc/rfq/</loc><lastmod>$GEN_DATE</lastmod></url>
  <url><loc>$BASE/$cc/autoquote/</loc><lastmod>$GEN_DATE</lastmod></url>
  <url><loc>$BASE/$cc/buyer-radar/</loc><lastmod>$GEN_DATE</lastmod></url>
  <url><loc>$BASE/$cc/distributor/</loc><lastmod>$GEN_DATE</lastmod></url>
</urlset>
"@
}

# Create placeholder subpages (rfq/autoquote/etc) so they exist now
function Ensure-SubPages($cc) {
  $subs = @("rfq","autoquote","buyer-radar","distributor")
  foreach($s in $subs){
    $dir = Join-Path $SITE_ROOT "$cc\$s"
    Ensure-Dir $dir
    $html = @"
<!doctype html><html><head><meta charset="utf-8"/>
<meta name="viewport" content="width=device-width,initial-scale=1"/>
<title>YiShen AI · $cc · $s</title>
<meta name="robots" content="index,follow"/>
<link rel="canonical" href="$BASE/$cc/$s/"/>
</head><body style="font-family:system-ui;margin:48px;max-width:900px">
<h1>$cc · $s</h1>
<p>Placeholder page. This will be upgraded by the Sovereign Content Engine.</p>
<p><a href="$BASE/$cc/">Back to $cc Node</a></p>
</body></html>
"@
    Set-Content -Path (Join-Path $dir "index.html") -Value $html -Encoding UTF8
  }
}

# Build sitemap.matrix.xml (index of all country sitemaps)
function Build-SitemapMatrix() {
  $items = ""
  foreach($cc in $COUNTRIES){
    $items += "  <sitemap><loc>$BASE/$cc/sitemap.xml</loc><lastmod>$GEN_DATE</lastmod></sitemap>`n"
  }
@"
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$items</sitemapindex>
"@
}

# Build sitemap.index.xml (root index -> points to matrix, so you can extend later)
function Build-SitemapIndex() {
@"
<?xml version="1.0" encoding="UTF-8"?>
<sitemapindex xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
  <sitemap>
    <loc>$BASE/sitemap.matrix.xml</loc>
    <lastmod>$GEN_DATE</lastmod>
  </sitemap>
</sitemapindex>
"@
}

# Build robots.txt (declares sitemaps)
function Build-Robots() {
@"
User-agent: *
Allow: /

Sitemap: $BASE/sitemap.index.xml
Sitemap: $BASE/sitemap.matrix.xml
"@
}

# ---- Execute ----
Write-Host "🚀 Building country nodes: $($COUNTRIES.Count) ..." -ForegroundColor Yellow

foreach($cc in $COUNTRIES){
  $ccDir = Join-Path $SITE_ROOT $cc
  Ensure-Dir $ccDir

  # country index
  Set-Content -Path (Join-Path $ccDir "index.html") -Value (Country-IndexHtml $cc) -Encoding UTF8

  # country sitemap
  Set-Content -Path (Join-Path $ccDir "sitemap.xml") -Value (Country-SitemapXml $cc) -Encoding UTF8

  # placeholders
  Ensure-SubPages $cc
}

# Root sitemaps + robots
Set-Content -Path (Join-Path $SITE_ROOT "sitemap.matrix.xml") -Value (Build-SitemapMatrix) -Encoding UTF8
Set-Content -Path (Join-Path $SITE_ROOT "sitemap.index.xml")  -Value (Build-SitemapIndex)  -Encoding UTF8
Set-Content -Path (Join-Path $SITE_ROOT "robots.txt")         -Value (Build-Robots)       -Encoding UTF8

Write-Host "✅ DONE:" -ForegroundColor Green
Write-Host "  - /sitemap.index.xml" -ForegroundColor Green
Write-Host "  - /sitemap.matrix.xml" -ForegroundColor Green
Write-Host "  - /robots.txt" -ForegroundColor Green
Write-Host "  - /<cc>/index.html + /<cc>/sitemap.xml + subpages" -ForegroundColor Green

Write-Host "`nNEXT: deploy to Vercel (git push / vercel --prod) then open:" -ForegroundColor Cyan
Write-Host "  $BASE/sitemap.index.xml" -ForegroundColor Cyan
Write-Host "  $BASE/sitemap.matrix.xml" -ForegroundColor Cyan
Write-Host "  $BASE/us/" -ForegroundColor Cyan
