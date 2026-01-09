$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

$LANGMAP = @{
  "us" = @("en","es")
  "sa" = @("ar")
  "br" = @("pt")
  "fr" = @("fr")
  "de" = @("de")
  "jp" = @("ja")
  "cn" = @("zh")
  "ru" = @("ru")
}

foreach ($country in $LANGMAP.Keys) {
  foreach ($lang in $LANGMAP[$country]) {

    $path = "$ROOT\$country\$lang"
    New-Item -ItemType Directory $path -Force | Out-Null
    New-Item -ItemType Directory "$path\public" -Force | Out-Null

    "<html><body><h1>YiShen $country-$lang</h1></body></html>" | Out-File "$path\index.html" -Encoding utf8
    "<?xml version='1.0'?><urlset></urlset>" | Out-File "$path\public\sitemap.xml" -Encoding utf8
    "User-agent: *`nAllow: /" | Out-File "$path\robots.txt" -Encoding utf8

    Write-Host "✓ $country/$lang online"
  }
}

Write-Host "🌐 Multilingual Sovereign Layer deployed"
