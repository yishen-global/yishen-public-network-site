$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site\public"

$pages = @(
"$ROOT\us\dealers.html",
"$ROOT\sa\wholesale.html",
"$ROOT\mx\distributors.html",
"$ROOT\br\resellers.html",
"$ROOT\eu\importers.html"
)

$payload = '<div id="conversion-core" style="background:#000;color:#0f0;padding:40px;font-family:Arial">' +
'<h2>Instant Wholesale Access</h2>' +
'<p>Direct Factory | Low MOQ | Global DDP Delivery</p>' +
'<a href="https://wa.me/8618857277313" style="display:inline-block;padding:14px 28px;background:#0f0;color:#000;font-size:18px;text-decoration:none;">Get Quote via WhatsApp</a>' +
'</div>'

foreach($p in $pages){
 if(Test-Path $p){
    $html = Get-Content $p -Raw
    if($html -notmatch "conversion-core"){
        $html = $html -replace "</body>", "$payload</body>"
        Set-Content $p $html -Encoding UTF8
        Write-Host "Injected: $p" -ForegroundColor Green
    } else {
        Write-Host "Already injected: $p" -ForegroundColor Yellow
    }
 } else {
    Write-Host "Missing: $p" -ForegroundColor Red
 }
}

Write-Host "🔥 Phase VI Conversion Engine Fully Activated." -ForegroundColor Cyan
