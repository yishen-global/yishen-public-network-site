# =========================================================
# YISHEN SOVEREIGN: CITY GRID + BUYER RADAR + RFQ CORE + COUNTRY MATRIX
# Root: J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site
# =========================================================

$ErrorActionPreference = "Stop"

$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
if (!(Test-Path $ROOT)) { throw "SITE ROOT not found: $ROOT" }

# ---------- CONFIG ----------
$countries = @(
  "us","sa","mx","br","ca","uk","de","fr","nl","au","nz","ae","sg","th","my","id","vn","ph","tw","jp","kr"
)

# Top 100 seed cities (can expand anytime)
$cities = @(
"new-york","los-angeles","chicago","houston","miami","dallas","san-francisco","seattle","boston","atlanta",
"toronto","vancouver","montreal","calgary","ottawa","london","manchester","birmingham","glasgow","edinburgh",
"paris","lyon","marseille","berlin","hamburg","munich","frankfurt","amsterdam","rotterdam","utrecht",
"dubai","abu-dhabi","riyadh","jeddah","dammam","doha","kuwait-city","manama","muscat","cairo",
"singapore","kuala-lumpur","bangkok","hanoi","ho-chi-minh-city","jakarta","surabaya","manila","cebu","taipei",
"tokyo","osaka","nagoya","fukuoka","seoul","busan","incheon","sydney","melbourne","brisbane",
"perth","auckland","wellington","christchurch","sao-paulo","rio-de-janeiro","brasilia","belo-horizonte","curitiba","porto-alegre",
"mexico-city","guadalajara","monterrey","tijuana","bogota","medellin","lima","santiago","buenos-aires","cordoba",
"madrid","barcelona","valencia","rome","milan","naples","istanbul","ankara","tel-aviv","nairobi",
"lagos","johannesburg","cape-town","casablanca","rabat","stockholm","oslo","copenhagen","helsinki","zurich"
)

# Industry seeds (expand later)
$industries = @(
"office-furniture","office-chairs","ergonomic-chairs","mesh-chairs","gaming-chairs","standing-desks",
"recliners","sofas","education-furniture","medical-furniture","hotel-furniture","outdoor-furniture",
"construction-materials","wpc-flooring","bamboo-flooring","hardware-parts","chains","logistics"
)

# ---------- UI: SOVEREIGN NAV + LOGO (no null errors) ----------
$NAV = @"
<header id="sovereign-nav" style="position:sticky;top:0;z-index:9999;background:#0b0f1a;color:#fff;border-bottom:1px solid rgba(255,255,255,.12)">
  <div style="max-width:1180px;margin:0 auto;display:flex;align-items:center;gap:14px;padding:12px 14px">
    <a href="/" style="display:flex;align-items:center;gap:10px;text-decoration:none;color:#fff">
      <img src="/assets/logo.svg" alt="YiShen" style="height:26px;width:auto" />
      <strong style="letter-spacing:.4px">YiShen Global</strong>
    </a>
    <nav style="margin-left:auto;display:flex;flex-wrap:wrap;gap:10px;font-size:14px">
      <a href="/country" style="color:#fff;text-decoration:none;opacity:.92">Countries</a>
      <a href="/city" style="color:#fff;text-decoration:none;opacity:.92">Cities</a>
      <a href="/industry" style="color:#fff;text-decoration:none;opacity:.92">Industries</a>
      <a href="/radar" style="color:#fff;text-decoration:none;opacity:.92">Buyer Radar</a>
      <a href="/rfq" style="color:#fff;text-decoration:none;opacity:.92">RFQ Gate</a>
      <a href="/contact" style="color:#fff;text-decoration:none;opacity:.92">Contact</a>
    </nav>
  </div>
</header>
"@

function Ensure-Dir([string]$p){ if(!(Test-Path $p)){ New-Item -ItemType Directory -Force -Path $p | Out-Null } }

function Write-FileUtf8NoBom([string]$path, [string]$content){
  $utf8NoBom = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($path, $content, $utf8NoBom)
}

function Safe-InjectNav([string]$file){
  try {
    $c = Get-Content $file -Raw -ErrorAction Stop
    if ([string]::IsNullOrWhiteSpace($c)) { return }
    if ($c -match 'id="sovereign-nav"') { return }

    if ($c -match "<body[^>]*>") {
      $c = [regex]::Replace($c, "(<body[^>]*>)", "`$1`n$NAV", 1)
    } else {
      # if no body tag, wrap minimal
      $c = "<!doctype html><html><head><meta charset='utf-8'></head><body>`n$NAV`n$c`n</body></html>"
    }
    Write-FileUtf8NoBom $file $c
  } catch {
    Write-Host "Inject failed: $file" -ForegroundColor Yellow
  }
}

function Html-Scaffold([string]$title, [string]$h1, [string]$desc, [string]$linksHtml){
@"
<!doctype html>
<html lang="en">
<head>
  <meta charset="utf-8"/>
  <meta name="viewport" content="width=device-width,initial-scale=1"/>
  <title>$title</title>
  <meta name="description" content="$desc"/>
  <style>
    body{margin:0;font-family:system-ui,-apple-system,Segoe UI,Roboto,Arial;background:#0b0f1a;color:#e8eefc}
    main{max-width:1180px;margin:0 auto;padding:26px 14px 60px}
    .grid{display:grid;grid-template-columns:repeat(auto-fit,minmax(220px,1fr));gap:12px}
    a.card{display:block;padding:14px 14px;border:1px solid rgba(255,255,255,.12);border-radius:14px;text-decoration:none;color:#e8eefc;background:rgba(255,255,255,.04)}
    a.card:hover{border-color:rgba(255,255,255,.22);transform:translateY(-1px)}
    .muted{opacity:.78}
    .cta{margin-top:16px;display:flex;gap:10px;flex-wrap:wrap}
    .btn{padding:10px 12px;border-radius:12px;border:1px solid rgba(255,255,255,.18);text-decoration:none;color:#fff;background:rgba(255,255,255,.06)}
  </style>
</head>
<body>
  $NAV
  <main>
    <h1 style="margin:0 0 8px">$h1</h1>
    <div class="muted" style="margin:0 0 18px">$desc</div>
    $linksHtml
    <div class="cta">
      <a class="btn" href="/radar">Open Buyer Radar</a>
      <a class="btn" href="/rfq">Open RFQ Gate</a>
      <a class="btn" href="/contact">Contact</a>
    </div>
  </main>
</body>
</html>
"@
}

# ---------- Assets ----------
Ensure-Dir "$ROOT\assets"
if (!(Test-Path "$ROOT\assets\logo.svg")) {
  $logoSvg = @"
<svg xmlns="http://www.w3.org/2000/svg" width="220" height="60" viewBox="0 0 220 60">
  <rect x="0" y="0" width="220" height="60" rx="14" fill="#111a2e"/>
  <path d="M28 40 L40 20 L52 40" fill="none" stroke="#58a6ff" stroke-width="4" stroke-linecap="round" stroke-linejoin="round"/>
  <circle cx="40" cy="40" r="4" fill="#58a6ff"/>
  <text x="72" y="38" fill="#e8eefc" font-family="Segoe UI, Arial" font-size="18" font-weight="700">YiShen Global</text>
</svg>
"@
  Write-FileUtf8NoBom "$ROOT\assets\logo.svg" $logoSvg.Trim()
}

# ---------- Core Pages ----------
# Home
$homeLinks = @"
<div class="grid">
  <a class="card" href="/country"><b>Country Matrix</b><div class="muted">All sovereign country nodes</div></a>
  <a class="card" href="/city"><b>City Grid</b><div class="muted">Top 100 buyer cities</div></a>
  <a class="card" href="/industry"><b>Industry Grid</b><div class="muted">All industries we serve</div></a>
  <a class="card" href="/radar"><b>Buyer Signal Radar</b><div class="muted">Intent + signals (public view)</div></a>
  <a class="card" href="/rfq"><b>Global RFQ Gate</b><div class="muted">RFQ intake + routing</div></a>
</div>
"@
Write-FileUtf8NoBom "$ROOT\index.html" (Html-Scaffold "YiShen Global Network" "Sovereign Global Network" "All continents. All cities. All industries. Zero 404." $homeLinks)

# Contact / Why-us (pretty route targets)
Write-FileUtf8NoBom "$ROOT\contact.html" (Html-Scaffold "Contact | YiShen" "Contact" "Email / WhatsApp / RFQ intake." @"
<div class="grid">
  <a class="card" href="mailto:alex.yang@yishenglobal.net"><b>Email</b><div class="muted">alex.yang@yishenglobal.net</div></a>
  <a class="card" href="/rfq"><b>RFQ Gate</b><div class="muted">Send your requirement</div></a>
</div>
"@)

Write-FileUtf8NoBom "$ROOT\why-us.html" (Html-Scaffold "Why YiShen | Predictable Supply" "Why YiShen" "Predictability > Price. Global delivery discipline. OEM/ODM. Compliance-ready." @"
<div class="grid">
  <a class="card" href="/industry/office-furniture"><b>Office Furniture</b><div class="muted">Chairs / desks / project supply</div></a>
  <a class="card" href="/industry/logistics"><b>Logistics</b><div class="muted">DDP / Express / clearance</div></a>
</div>
"@)

# ---------- City Grid ----------
Ensure-Dir "$ROOT\city"
$cityCards = ($cities | ForEach-Object { "<a class='card' href='/city/$_'><b>$($_ -replace '-', ' ')</b><div class='muted'>Buyer node / distributors / RFQ</div></a>" }) -join "`n"
Write-FileUtf8NoBom "$ROOT\city\index.html" (Html-Scaffold "City Grid | YiShen" "Top 100 Cities" "City distributor vault entry points." "<div class='grid'>$cityCards</div>")

foreach ($ct in $cities) {
  Ensure-Dir "$ROOT\city\$ct"
  $links = @"
<div class="grid">
  <a class="card" href="/rfq"><b>Open RFQ</b><div class="muted">Request quote for this city</div></a>
  <a class="card" href="/radar"><b>Buyer Radar</b><div class="muted">Signals & intent</div></a>
  <a class="card" href="/industry"><b>Industries</b><div class="muted">Choose category</div></a>
</div>
"@
  Write-FileUtf8NoBom "$ROOT\city\$ct\index.html" (Html-Scaffold "City | $ct | YiShen" ("City Node: " + ($ct -replace '-', ' ')) "Sovereign city landing. This node never 404." $links)
}

# ---------- Industry Grid ----------
Ensure-Dir "$ROOT\industry"
$indCards = ($industries | ForEach-Object { "<a class='card' href='/industry/$_'><b>$($_ -replace '-', ' ')</b><div class='muted'>Products / specs / RFQ</div></a>" }) -join "`n"
Write-FileUtf8NoBom "$ROOT\industry\index.html" (Html-Scaffold "Industry Grid | YiShen" "All Industries" "Category entry points." "<div class='grid'>$indCards</div>")

foreach ($ind in $industries) {
  Ensure-Dir "$ROOT\industry\$ind"
  $links = @"
<div class="grid">
  <a class="card" href="/rfq"><b>RFQ for $ind</b><div class="muted">MOQ / lead time / spec</div></a>
  <a class="card" href="/city"><b>Pick a City</b><div class="muted">Distributor vault</div></a>
</div>
"@
  Write-FileUtf8NoBom "$ROOT\industry\$ind\index.html" (Html-Scaffold "Industry | $ind | YiShen" ("Industry: " + ($ind -replace '-', ' ')) "Industry node. SEO + buyer routing." $links)
}

# ---------- Country Matrix ----------
Ensure-Dir "$ROOT\country"
$countryCards = ($countries | ForEach-Object { "<a class='card' href='/$($_)'><b>$($_.ToUpper())</b><div class='muted'>Country sovereign node</div></a>" }) -join "`n"
Write-FileUtf8NoBom "$ROOT\country\index.html" (Html-Scaffold "Country Matrix | YiShen" "Country Matrix" "All active country sovereignty nodes." "<div class='grid'>$countryCards</div>")

foreach ($cc in $countries) {
  Ensure-Dir "$ROOT\$cc"
  $links = @"
<div class="grid">
  <a class="card" href="/$cc/why-us"><b>Why Us</b><div class="muted">Localized landing</div></a>
  <a class="card" href="/$cc/contact"><b>Contact</b><div class="muted">Local contact route</div></a>
  <a class="card" href="/city"><b>City Grid</b><div class="muted">Top cities</div></a>
  <a class="card" href="/industry"><b>Industry Grid</b><div class="muted">All categories</div></a>
</div>
"@
  Write-FileUtf8NoBom "$ROOT\$cc\index.html" (Html-Scaffold "Country | $cc | YiShen" ("Country Node: " + $cc.ToUpper()) "Country entry. Never 404." $links)

  # pretty routes inside country (no .html)
  Write-FileUtf8NoBom "$ROOT\$cc\why-us.html" (Html-Scaffold "Why Us | $cc | YiShen" "Why YiShen" "Predictable supply + compliance + fast delivery." "<div class='muted'>Localized messaging placeholder.</div>")
  Write-FileUtf8NoBom "$ROOT\$cc\contact.html" (Html-Scaffold "Contact | $cc | YiShen" "Contact" "Email / RFQ / WhatsApp." "<div class='muted'>Localized contact placeholder.</div>")
}

# ---------- Buyer Signal Radar ----------
Ensure-Dir "$ROOT\radar"
$radarHtml = @"
<div class="grid">
  <a class="card" href="/radar/signals"><b>Signals Feed</b><div class="muted">Intent signals list (stub)</div></a>
  <a class="card" href="/rfq"><b>RFQ Gate</b><div class="muted">Convert intent → RFQ</div></a>
</div>
"@
Write-FileUtf8NoBom "$ROOT\radar\index.html" (Html-Scaffold "Buyer Radar | YiShen" "Buyer Signal Radar" "Public radar shell (signals can be wired later)." $radarHtml)

Ensure-Dir "$ROOT\radar\signals"
Write-FileUtf8NoBom "$ROOT\radar\signals\index.html" (Html-Scaffold "Signals | YiShen" "Signals Feed" "Placeholder feed. Next step: connect your lead sources." @"
<div class="muted">Signals are ready to be wired: ImportYeti / ImportGenius / Sinoimex / LinkedIn / website events.</div>
"@)

# ---------- RFQ CORE ----------
Ensure-Dir "$ROOT\rfq"
Write-FileUtf8NoBom "$ROOT\rfq\index.html" (Html-Scaffold "RFQ Gate | YiShen" "Global RFQ Gate" "Open RFQ intake. Routes to sales." @"
<form style="display:grid;gap:10px;max-width:720px" onsubmit="event.preventDefault(); const p=new URLSearchParams(new FormData(this)); window.location.href='/rfq/confirm?'+p.toString();">
  <input name="company" placeholder="Company name" required style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.06);color:#fff">
  <input name="country" placeholder="Country / City" style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.06);color:#fff">
  <input name="category" placeholder="Category (e.g., mesh chairs / standing desks)" required style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.06);color:#fff">
  <input name="qty" placeholder="Quantity" style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.06);color:#fff">
  <textarea name="details" placeholder="Specs / target price / delivery time" rows="4" style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.14);background:rgba(255,255,255,.06);color:#fff"></textarea>
  <button type="submit" style="padding:12px;border-radius:12px;border:1px solid rgba(255,255,255,.18);background:rgba(88,166,255,.22);color:#fff;font-weight:700">Submit RFQ</button>
</form>
"@)

Ensure-Dir "$ROOT\rfq\confirm"
Write-FileUtf8NoBom "$ROOT\rfq\confirm\index.html" (Html-Scaffold "RFQ Confirm | YiShen" "RFQ Received" "Your RFQ is captured. Next step: auto-routing." @"
<div class="muted">This is the confirmation node. Next step we wire: WhatsApp bot / email router / CRM.</div>
<div class="cta">
  <a class="btn" href="/rfq">Submit another RFQ</a>
  <a class="btn" href="/contact">Contact</a>
</div>
"@)

# ---------- Robots + Sitemap ----------
Write-FileUtf8NoBom "$ROOT\robots.txt" @"
User-agent: *
Allow: /
Sitemap: https://yishen.ai/sitemap.xml
"@

# Minimal sitemap (index, country, city, industry, radar, rfq + all countries)
$urls = New-Object System.Collections.Generic.List[string]
$base = "https://yishen.ai"
$urls.Add("$base/")
$urls.Add("$base/country")
$urls.Add("$base/city")
$urls.Add("$base/industry")
$urls.Add("$base/radar")
$urls.Add("$base/rfq")
$urls.Add("$base/contact")
$urls.Add("$base/why-us")

foreach($cc in $countries){ $urls.Add("$base/$cc") }

$sitemap = @()
$sitemap += '<?xml version="1.0" encoding="UTF-8"?>'
$sitemap += '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">'
foreach($u in $urls){
  $sitemap += "  <url><loc>$u</loc></url>"
}
$sitemap += '</urlset>'
Write-FileUtf8NoBom "$ROOT\sitemap.xml" ($sitemap -join "`n")

# ---------- vercel.json (built via object => valid JSON, no PS parsing errors) ----------
$vercel = [ordered]@{
  version = 2
  routes = @(
    @{ src = "^/robots\.txt$"; dest = "/robots.txt" },
    @{ src = "^/sitemap\.xml$"; dest = "/sitemap.xml" },

    # pretty top-level routes
    @{ src = "^/contact/?$"; dest = "/contact.html" },
    @{ src = "^/why-us/?$"; dest = "/why-us.html" },
    @{ src = "^/country/?$"; dest = "/country/index.html" },
    @{ src = "^/city/?$"; dest = "/city/index.html" },
    @{ src = "^/industry/?$"; dest = "/industry/index.html" },
    @{ src = "^/radar/?$"; dest = "/radar/index.html" },
    @{ src = "^/radar/signals/?$"; dest = "/radar/signals/index.html" },
    @{ src = "^/rfq/?$"; dest = "/rfq/index.html" },
    @{ src = "^/rfq/confirm/?$"; dest = "/rfq/confirm/index.html" },

    # country pretty routes
    @{ src = "^/([a-z]{2})/?$"; dest = "/$1/index.html" },
    @{ src = "^/([a-z]{2})/(why-us|contact)/?$"; dest = "/$1/$2.html" },

    # city / industry nodes
    @{ src = "^/city/([a-z0-9-]+)/?$"; dest = "/city/$1/index.html" },
    @{ src = "^/industry/([a-z0-9-]+)/?$"; dest = "/industry/$1/index.html" },

    # 404 immunity: anything else -> home
    @{ src = "^/(.*)$"; dest = "/index.html" }
  )
}

$vercelJson = ($vercel | ConvertTo-Json -Depth 20)
Write-FileUtf8NoBom "$ROOT\vercel.json" $vercelJson

# ---------- Final: Inject NAV into all html files (safe, no null errors) ----------
Get-ChildItem -Path $ROOT -Recurse -File -Filter *.html | ForEach-Object {
  Safe-InjectNav $_.FullName
}

Write-Host "✅ CITY GRID / BUYER RADAR / RFQ CORE / COUNTRY MATRIX GENERATED" -ForegroundColor Green
Write-Host "✅ vercel.json + sitemap.xml + robots.txt DONE" -ForegroundColor Green
Write-Host "✅ 404 IMMUNITY ACTIVE (catch-all -> /index.html)" -ForegroundColor Green

# ---------- Deploy ----------
Write-Host "🚀 DEPLOYING TO VERCEL..." -ForegroundColor Cyan
Set-Location $ROOT
vercel --prod --force
Write-Host "🔥 IGNITE COMPLETE." -ForegroundColor Green
