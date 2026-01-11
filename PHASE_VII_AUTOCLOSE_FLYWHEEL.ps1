# ==============================
# PHASE VII - GLOBAL AUTOCLOSE FLYWHEEL (SOVEREIGN)
# One-click generate assets + inject into 5-country pages + git push
# Root: J:\YISHEN_SOVEREIGN_GROWTH_OS
# ==============================

$ErrorActionPreference = "Stop"
$BASE = "J:\YISHEN_SOVEREIGN_GROWTH_OS"
$DEPLOY = Join-Path $BASE "DEPLOY"
$ROOT  = Join-Path $BASE "PUBLIC_NETWORK\site\public"

Write-Host "=== PHASE VII AUTOCLOSE FLYWHEEL START ===" -ForegroundColor Green
Write-Host "ROOT: $ROOT" -ForegroundColor Cyan

# ---------- Paths ----------
$ENGINE_DIR = Join-Path $ROOT "engine"
$API_DIR    = Join-Path $ROOT "api"
$LEADS_DIR  = Join-Path $ROOT "leads"
$QUEUE_DIR  = Join-Path $ROOT "queue"
$PAGES = @(
  (Join-Path $ROOT "us\dealers.html"),
  (Join-Path $ROOT "sa\wholesale.html"),
  (Join-Path $ROOT "mx\distributors.html"),
  (Join-Path $ROOT "br\resellers.html"),
  (Join-Path $ROOT "eu\importers.html")
)

# ---------- Ensure dirs ----------
@($ENGINE_DIR,$API_DIR,$LEADS_DIR,$QUEUE_DIR) | ForEach-Object {
  if(!(Test-Path $_)){ New-Item -ItemType Directory -Force -Path $_ | Out-Null }
}

# ---------- Core data ----------
$WHATSAPP_E164 = "8618857277313"      # your WA
$BRAND = "YISHEN / LEISA"
$PRODUCTS = "Office Chair / Mesh Chair / Gaming Chair / Standing Desk"
$COUNTRIES = @("US","SA","MX","BR","EU")

# ---------- 1) Create RFQ + AutoQuote + ICP detector JS ----------
$engine_js = @"
(function(){
  function qs(sel){ return document.querySelector(sel); }
  function qsa(sel){ return Array.from(document.querySelectorAll(sel)); }

  const cfg = {
    whatsapp: "$WHATSAPP_E164",
    brand: "$BRAND",
    products: "$PRODUCTS"
  };

  function detectICP(form){
    const channel = (form.channel.value||"").toLowerCase();
    const volume  = (form.monthlyVolume.value||"").toLowerCase();
    const model   = (form.model.value||"").toLowerCase();

    // simple rules (no fake automation, just classification)
    if(channel.includes("amazon") || channel.includes("e-commerce") || channel.includes("shopify")) return "E-commerce Seller";
    if(channel.includes("retail") || channel.includes("store") || channel.includes("chain")) return "Retail Buyer";
    if(channel.includes("distributor") || channel.includes("wholesale") || channel.includes("importer")) return "Distributor/Importer";
    if(channel.includes("project") || channel.includes("contract") || channel.includes("fit-out")) return "Project/Contract Buyer";

    // fallback by volume
    if(volume.includes("500") || volume.includes("1000") || volume.includes("2000")) return "High-volume Procurement";
    return "General B2B Buyer";
  }

  function buildQuote(form){
    // safe, generic tier quote (you can later replace with your real price table)
    const sku = form.model.value || "Selected Model";
    const vol = parseInt(form.qty.value||"0",10) || 0;

    let tier = "Sample/Trial";
    if(vol >= 50) tier = "Tier A (50+)";
    if(vol >= 200) tier = "Tier B (200+)";
    if(vol >= 500) tier = "Tier C (500+)";
    if(vol >= 1000) tier = "Tier D (1000+)";

    const incoterm = form.incoterm.value || "FOB/CIF/DDP";
    const dest = form.country.value || "Your Country";
    const note = "Auto-quote is indicative. Final price depends on config/material/cert/packaging.";

    return { sku, vol, tier, incoterm, dest, note };
  }

  function waLink(text){
    const u = "https://wa.me/" + cfg.whatsapp + "?text=" + encodeURIComponent(text);
    return u;
  }

  function render(){
    const host = qs("#phase7");
    if(!host) return;

    host.innerHTML = `
      <div style="max-width:980px;margin:0 auto;padding:26px;border:1px solid #1f1f1f;border-radius:14px;background:#0b0b0b;color:#e7e7e7;font-family:Arial">
        <div style="display:flex;gap:18px;flex-wrap:wrap;align-items:center;justify-content:space-between">
          <div>
            <div style="font-size:13px;opacity:.8">PHASE VII · AUTOCLOSE FLYWHEEL</div>
            <h2 style="margin:6px 0 6px;font-size:26px;color:#8DFF57">Instant RFQ → Auto Quote → WhatsApp Close</h2>
            <div style="font-size:14px;opacity:.9">Direct factory · Low MOQ · Fast delivery · Customization · Certifications</div>
          </div>
          <a id="waTop" href="https://wa.me/${cfg.whatsapp}" style="padding:12px 16px;background:#8DFF57;color:#000;border-radius:10px;text-decoration:none;font-weight:bold">Chat on WhatsApp</a>
        </div>

        <hr style="margin:18px 0;border:none;border-top:1px solid #1f1f1f"/>

        <form id="rfqForm" style="display:grid;grid-template-columns:repeat(2,minmax(0,1fr));gap:12px">
          <input name="name" placeholder="Name" required style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>
          <input name="company" placeholder="Company" required style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>

          <input name="email" placeholder="Email" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>
          <input name="whatsapp" placeholder="WhatsApp (+country code)" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>

          <select name="country" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff">
            <option value="">Country</option>
            <option>United States</option><option>Saudi Arabia</option><option>Mexico</option><option>Brazil</option>
            <option>Germany</option><option>France</option><option>Netherlands</option><option>Spain</option><option>Italy</option>
          </select>

          <select name="channel" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff">
            <option value="">Buyer Type / Channel</option>
            <option>Retail chain</option>
            <option>Distributor / Importer</option>
            <option>E-commerce (Amazon/Shopify)</option>
            <option>Project / Contract</option>
            <option>Brand / Private Label</option>
          </select>

          <select name="model" required style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff">
            <option value="">Product</option>
            <option>Ergonomic Mesh Chair</option>
            <option>Gaming Chair</option>
            <option>Leather Office Chair</option>
            <option>Standing Desk</option>
          </select>

          <input name="qty" type="number" min="1" placeholder="Quantity (pcs)" required style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>
          <select name="monthlyVolume" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff">
            <option value="">Monthly volume</option>
            <option>10-50</option><option>50-200</option><option>200-500</option><option>500-1000</option><option>1000+</option>
          </select>

          <select name="incoterm" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff">
            <option value="">Incoterm</option><option>FOB</option><option>CIF</option><option>DDP</option>
          </select>

          <input name="targetPrice" placeholder="Target price (optional)" style="padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff"/>
          <textarea name="notes" placeholder="Notes (color, cert, packaging, lead time…)" style="grid-column:1/-1;padding:12px;border-radius:10px;border:1px solid #222;background:#121212;color:#fff;min-height:90px"></textarea>

          <div style="grid-column:1/-1;display:flex;gap:10px;flex-wrap:wrap;align-items:center">
            <button type="submit" style="padding:12px 16px;background:#8DFF57;color:#000;border:none;border-radius:10px;font-weight:bold;cursor:pointer">Get Auto Quote</button>
            <a id="waCta" href="#" style="padding:12px 16px;background:#222;color:#8DFF57;border:1px solid #333;border-radius:10px;text-decoration:none;font-weight:bold">Send RFQ to WhatsApp</a>
            <span id="icp" style="opacity:.85"></span>
          </div>
        </form>

        <div id="quoteBox" style="margin-top:14px;padding:14px;border-radius:12px;border:1px solid #222;background:#0f0f0f;display:none"></div>
        <div style="margin-top:10px;font-size:12px;opacity:.75">This tool generates indicative tiers only. Final quotation confirmed on WhatsApp.</div>
      </div>
    `;

    const form = qs("#rfqForm");
    const quoteBox = qs("#quoteBox");
    const waCta = qs("#waCta");
    const icpEl = qs("#icp");

    form.addEventListener("submit", function(e){
      e.preventDefault();
      const data = Object.fromEntries(new FormData(form).entries());
      const icp = detectICP(form);
      const q = buildQuote(form);

      icpEl.textContent = "ICP: " + icp;

      const msg = [
        "[RFQ] " + cfg.brand,
        "Name: " + (data.name||""),
        "Company: " + (data.company||""),
        "Email: " + (data.email||""),
        "WA: " + (data.whatsapp||""),
        "Country: " + (data.country||""),
        "Channel: " + (data.channel||""),
        "ICP: " + icp,
        "Product: " + q.sku,
        "Qty: " + q.vol,
        "Tier: " + q.tier,
        "Incoterm: " + q.incoterm,
        "Dest: " + q.dest,
        "Notes: " + (data.notes||""),
        "----",
        q.note
      ].join("\n");

      quoteBox.style.display = "block";
      quoteBox.innerHTML = `
        <div style="font-weight:bold;color:#8DFF57">Auto Quote (Indicative)</div>
        <div style="margin-top:8px;line-height:1.55">
          <div><b>Product</b>: ${q.sku}</div>
          <div><b>Qty</b>: ${q.vol}</div>
          <div><b>Tier</b>: ${q.tier}</div>
          <div><b>Incoterm</b>: ${q.incoterm}</div>
          <div><b>Destination</b>: ${q.dest}</div>
          <div style="opacity:.8;margin-top:8px">${q.note}</div>
        </div>
      `;

      waCta.href = waLink(msg);
      waCta.textContent = "Send RFQ + Auto Quote to WhatsApp";
    });
  }

  if(document.readyState === "loading"){
    document.addEventListener("DOMContentLoaded", render);
  } else {
    render();
  }
})();
"@

Set-Content (Join-Path $ENGINE_DIR "phase7_autoclose.js") $engine_js -Encoding UTF8

# ---------- 2) Create API placeholders (static JSON endpoints) ----------
# Note: Vercel static only; no server running. These are for pipeline handoff.
$icp_json = @{
  version="1.0"
  note="Static placeholder. Replace with real enrichment later."
  icp_rules=@(
    "Retail chain / Distributor / Ecom / Project / Private Label",
    "Volume tiers map to A/B/C/D"
  )
} | ConvertTo-Json -Depth 8

Set-Content (Join-Path $API_DIR "icp_rules.json") $icp_json -Encoding UTF8

$autoquote_json = @{
  version="1.0"
  note="Static placeholder. Auto quote computed client-side in phase7_autoclose.js"
  tiers=@(
    @{name="Tier A"; qty="50+"},
    @{name="Tier B"; qty="200+"},
    @{name="Tier C"; qty="500+"},
    @{name="Tier D"; qty="1000+"}
  )
} | ConvertTo-Json -Depth 8

Set-Content (Join-Path $API_DIR "autoquote_tiers.json") $autoquote_json -Encoding UTF8

# ---------- 3) Leads template + queues ----------
$csv = "created_at,country,icp,company,name,email,whatsapp,product,qty,incoterm,notes,status,source`n"
Set-Content (Join-Path $LEADS_DIR "country_leads_template.csv") $csv -Encoding UTF8

$queue = @{
  version="1.0"
  note="Manual/External runner can consume this queue (no auto-sending here)."
  items=@()
} | ConvertTo-Json -Depth 8

Set-Content (Join-Path $QUEUE_DIR "outreach_queue.json") $queue -Encoding UTF8
Set-Content (Join-Path $QUEUE_DIR "linkedin_sync_queue.json") $queue -Encoding UTF8

# ---------- 4) Inject Phase VII block into 5 pages ----------
$inject = @"
<!-- ===== PHASE VII AUTOCLOSE FLYWHEEL ===== -->
<div id="phase7"></div>
<script src="/engine/phase7_autoclose.js"></script>
<!-- ===== /PHASE VII ===== -->
"@

foreach($p in $PAGES){
  if(Test-Path $p){
    $html = Get-Content $p -Raw
    if($html -notmatch 'id="phase7"'){
      $html = $html -replace "</body>", "$inject`n</body>"
      Set-Content $p $html -Encoding UTF8
      Write-Host "Injected Phase VII: $p" -ForegroundColor Green
    } else {
      Write-Host "Already injected Phase VII: $p" -ForegroundColor Yellow
    }
  } else {
    Write-Host "Missing page: $p" -ForegroundColor Red
  }
}

# ---------- 5) Git commit + push (trigger Vercel) ----------
Push-Location $DEPLOY
try{
  git add -A | Out-Null
  $status = git status --porcelain
  if($status){
    git commit -m "phase vii global autoclose flywheel" | Out-Null
    git push origin main | Out-Null
    Write-Host "Git pushed. Vercel deploy should trigger." -ForegroundColor Cyan
  } else {
    Write-Host "No changes to commit." -ForegroundColor Yellow
  }
} finally {
  Pop-Location
}

Write-Host "=== PHASE VII AUTOCLOSE FLYWHEEL COMPLETE ===" -ForegroundColor Green
Write-Host "Open pages:" -ForegroundColor Cyan
Write-Host "US: /us/dealers.html" -ForegroundColor White
Write-Host "SA: /sa/wholesale.html" -ForegroundColor White
Write-Host "MX: /mx/distributors.html" -ForegroundColor White
Write-Host "BR: /br/resellers.html" -ForegroundColor White
Write-Host "EU: /eu/importers.html" -ForegroundColor White
