$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS"
$SITE = "$ROOT\PUBLIC_NETWORK\site"
$ASSETS = "$SITE\assets"
$NAV = "$SITE\_nav.html"
$FOOT = "$SITE\_footer.html"
$LOGO = "$ASSETS\logo.svg"
$ERR404 = "$SITE\404.html"

New-Item -ItemType Directory -Force $ASSETS | Out-Null
New-Item -ItemType Directory -Force "$ASSETS\css" | Out-Null
New-Item -ItemType Directory -Force "$ASSETS\js" | Out-Null
New-Item -ItemType Directory -Force "$ASSETS\img" | Out-Null

@"
<svg width="260" height="60" xmlns="http://www.w3.org/2000/svg">
<text x="0" y="40" font-size="36" font-family="Arial" fill="black">YishenGlobal</text>
</svg>
"@ | Set-Content $LOGO -Encoding UTF8

@"
<nav class='yg-nav'>
<img src='/assets/logo.svg' class='logo'/>
<a href='/'>Home</a>
<a href='/us'>USA</a>
<a href='/sa'>Saudi</a>
<a href='/ae'>UAE</a>
<a href='/mx'>Mexico</a>
<a href='/br'>Brazil</a>
</nav>
"@ | Set-Content $NAV -Encoding UTF8

@"
<footer class='yg-footer'>© YishenGlobal — Global Sourcing Authority</footer>
"@ | Set-Content $FOOT -Encoding UTF8

@"
<!doctype html><meta charset='utf-8'>
<title>YishenGlobal 404 Shield</title>
<h1>404 Immunity Active</h1>
<a href='/'>Return Home</a>
"@ | Set-Content $ERR404 -Encoding UTF8

Get-ChildItem -Recurse $SITE -Filter *.html | ForEach-Object {
 $html = Get-Content $_.FullName -Raw
 if($html -notmatch "yg-nav"){
   $html = $html -replace "<body>", "<body>`n$(Get-Content $NAV -Raw)"
   $html = $html -replace "</body>", "$(Get-Content $FOOT -Raw)`n</body>"
   Set-Content $_.FullName $html -Encoding UTF8
 }
}

Write-Host "🔥 WORLD MASTER PATCH APPLIED" -ForegroundColor Green
