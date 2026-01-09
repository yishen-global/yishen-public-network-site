$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$NODES = @("us","sa","mx","br")

Write-Host "🌍 YiShen Nation Node Spawner"

foreach ($n in $NODES) {

    $path = "$ROOT\$n"
    New-Item -ItemType Directory $path -Force | Out-Null
    New-Item -ItemType Directory "$path\public" -Force | Out-Null

    "<html><body><h1>YiShen Node $n</h1><a href='/contact'>Start</a></body></html>" |
        Out-File "$path\index.html" -Encoding utf8

    "<?xml version='1.0'?><urlset></urlset>" |
        Out-File "$path\public\sitemap.xml" -Encoding utf8

    "User-agent: *`nAllow: /" |
        Out-File "$path\robots.txt" -Encoding utf8

    Write-Host "✓ Node $n generated"
}

Write-Host "🚀 Nation Nodes Online"
