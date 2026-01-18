$ROOT="J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
Set-Location $ROOT

Write-Host "🌍 SOVEREIGN WORLD ENGINE IGNITION..." -ForegroundColor Cyan

# 1. FLATTEN
Get-ChildItem -Recurse -Filter *.html | ForEach-Object {
    Copy-Item $_.FullName "$ROOT\$($_.Name)" -Force
}

# 2. UI Inject
$NAV='<div style="background:black;color:#00ffff;padding:14px;font-weight:bold">YiShen GLOBAL · Sovereign Network</div>'
Get-ChildItem -Filter *.html | ForEach-Object {
    $c=Get-Content $_ -Raw
    if($c -notmatch "YiShen GLOBAL"){
        $c=$c -replace "<body>","<body>$NAV"
        Set-Content $_ $c
    }
}

# 3. Country Spawn
$COUNTRIES=@("us","ca","mx","br","sa","ae","de","fr","uk","jp","kr","au")
foreach($c in $COUNTRIES){
@"
<!doctype html><html><body>
<h1>YiShen Global – $c Sovereign Node</h1>
<p>Official Procurement Gateway</p>
<a href="/">Back Home</a>
</body></html>
"@ | Set-Content "$ROOT\$c.html"
}

# 4. Sitemap rebuild
$urls=Get-ChildItem -Filter *.html | ForEach-Object{
"<url><loc>https://yishen.ai/$($_.Name.Replace('.html',''))</loc></url>"
}
@"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($urls -join "`n")
</urlset>
"@ | Set-Content "$ROOT\sitemap.xml"

# 5. FIRE
vercel --prod
