# ================================
# PHASE-VII : Country + City Matrix Generator (One-Click)
# Root: J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site
# Output:
#   /us/index.html
#   /us/tx/index.html
#   /us/tx/houston/index.html ...
#   /ca/on/toronto/index.html ...
# Also creates: sitemap.matrix.xml (in root)
# ================================

$ErrorActionPreference = "Stop"

$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
Set-Location $ROOT

# ---------- CONFIG (edit here only) ----------
$Brand = "Yishen Global"

# Country -> State/Province -> Cities
$Matrix = @{
  "us" = @{
    "tx" = @("houston","dallas","austin","san-antonio");
    "fl" = @("miami","orlando","tampa","jacksonville");
    "ny" = @("new-york","buffalo","rochester");
    "az" = @("phoenix","tucson");
  };
  "ca" = @{
    "on" = @("toronto","ottawa","mississauga");
    "bc" = @("vancouver","surrey");
    "ab" = @("calgary","edmonton");
  };
  "sa" = @{
    "riyadh" = @("riyadh");
    "jeddah" = @("jeddah");
    "dammam" = @("dammam");
  };
  "mx" = @{
    "cdmx" = @("mexico-city");
    "jal"  = @("guadalajara");
    "nl"   = @("monterrey");
  };
}

$BaseDomain = "https://yishen.ai"  # 改成你要的主域（yishen.ai 或 yishenglobal.net）
# --------------------------------------------

function Ensure-Dir($p){
  if(!(Test-Path $p)){ New-Item -ItemType Directory -Path $p | Out-Null }
}

function Write-Page($path, $title, $h1, $ctaHref){
  $html = @"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8" />
  <meta name="viewport" content="width=device-width,initial-scale=1" />
  <title>$title</title>
  <meta name="robots" content="index,follow" />
  <link rel="canonical" href="$ctaHref" />
  <style>
    body{font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;max-width:980px;margin:40px auto;padding:0 18px;line-height:1.55}
    header{display:flex;align-items:center;justify-content:space-between;margin-bottom:24px}
    nav a{margin-right:14px;text-decoration:none}
    .card{border:1px solid #ddd;border-radius:14px;padding:18px;margin:14px 0}
    .btn{display:inline-block;padding:10px 14px;border-radius:10px;border:1px solid #111;text-decoration:none}
    .muted{opacity:.72}
  </style>
</head>
<body>
<header>
  <strong>$Brand</strong>
  <nav>
    <a href="/">Home</a>
    <a href="/solutions">Solutions</a>
    <a href="/contact">Contact</a>
    <a href="/key.txt" class="muted">Key</a>
  </nav>
</header>

<h1>$h1</h1>

<div class="card">
  <p class="muted">Sovereign Node Active · Country/City Routing · IndexNow Ready</p>
  <p>We help buyers source reliably with predictable lead time, transparent packing, and scalable fulfillment.</p>
  <a class="btn" href="/contact">Request a Quote</a>
</div>

<div class="card">
  <h3>Fast RFQ → Fast Quote</h3>
  <p>Send product + qty + destination city. We reply with a clear landed-cost estimate and timeline.</p>
</div>

<footer class="muted" style="margin-top:40px">
  © $Brand · Matrix Node
</footer>
</body>
</html>
"@
  Set-Content -Path $path -Value $html -Encoding UTF8
}

# ---------- GENERATE ----------
Write-Host "🚀 PHASE-VII START: Generating country/city nodes..." -ForegroundColor Cyan

# Country root pages
foreach($c in $Matrix.Keys){
  $countryDir = Join-Path $ROOT $c
  Ensure-Dir $countryDir
  Ensure-Dir (Join-Path $countryDir "index.html" | Split-Path)
  Write-Page -path (Join-Path $countryDir "index.html") `
    -title "$Brand · $c" `
    -h1 "$Brand · $c Sovereign Node" `
    -ctaHref "$BaseDomain/$c"
}

# City pages
$urls = New-Object System.Collections.Generic.List[string]
$urls.Add("$BaseDomain/")

foreach($c in $Matrix.Keys){
  $urls.Add("$BaseDomain/$c")
  foreach($region in $Matrix[$c].Keys){
    $regionDir = Join-Path (Join-Path $ROOT $c) $region
    Ensure-Dir $regionDir
    Write-Page -path (Join-Path $regionDir "index.html") `
      -title "$Brand · $c/$region" `
      -h1 "$Brand · $c / $region Node" `
      -ctaHref "$BaseDomain/$c/$region"
    $urls.Add("$BaseDomain/$c/$region")

    foreach($city in $Matrix[$c][$region]){
      $cityDir = Join-Path $regionDir $city
      Ensure-Dir $cityDir
      Write-Page -path (Join-Path $cityDir "index.html") `
        -title "$Brand · $c/$region/$city" `
        -h1 "$Brand · $c / $region / $city" `
        -ctaHref "$BaseDomain/$c/$region/$city"
      $urls.Add("$BaseDomain/$c/$region/$city")
    }
  }
}

# ---------- SITEMAP ----------
Write-Host "🧭 Building sitemap.matrix.xml ..." -ForegroundColor Cyan
$sb = New-Object System.Text.StringBuilder
[void]$sb.AppendLine('<?xml version="1.0" encoding="UTF-8"?>')
[void]$sb.AppendLine('<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">')
foreach($u in $urls){
  [void]$sb.AppendLine("  <url><loc>$u</loc></url>")
}
[void]$sb.AppendLine('</urlset>')
Set-Content -Path (Join-Path $ROOT "sitemap.matrix.xml") -Value $sb.ToString() -Encoding UTF8

# ---------- SAFE vercel.json (minimal, valid) ----------
Write-Host "🛡️ Writing minimal valid vercel.json ..." -ForegroundColor Cyan
$vercelJson = @"
{
  "version": 2,
  "cleanUrls": true,
  "trailingSlash": false
}
"@
Set-Content -Path (Join-Path $ROOT "vercel.json") -Value $vercelJson -Encoding UTF8

Write-Host "✅ PHASE-VII GENERATED: $($urls.Count) URLs + sitemap.matrix.xml" -ForegroundColor Green
Write-Host "➡️ Next: Deploy with Vercel: cd `"$ROOT`" ; vercel --prod --force" -ForegroundColor Yellow
