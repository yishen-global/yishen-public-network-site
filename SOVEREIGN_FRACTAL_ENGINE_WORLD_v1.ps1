# ============================
# SOVEREIGN FRACTAL WORLD CORE
# ============================

$root = "J:\WORLD"
$domains = @("yishen.ai","yishenglobal.net")
$countries = @("us","sa","mx","br","ae","ca","de","fr","jp","kr")

New-Item -ItemType Directory -Path $root -Force | Out-Null

$sitemap = "$root\sitemap-world.xml"
$sitemapHeader = '<?xml version="1.0" encoding="UTF-8"?>' + "`n" +
                 '<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">' + "`n"
Set-Content $sitemap $sitemapHeader -Encoding UTF8

foreach ($domain in $domains) {
    foreach ($c in $countries) {

        $path = "$root\$domain\$c"
        New-Item -ItemType Directory -Path $path -Force | Out-Null

        $url = "https://$domain/$c"

        $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<title>$domain | $c Sovereign Node</title>
<meta charset="utf-8">
<meta name="description" content="$domain global supply chain official node for $c">
<link rel="canonical" href="$url">
</head>
<body>
<h1>$domain – Sovereign Index Node ($c)</h1>
<p>YiShen Global official supply network for $c</p>
</body>
</html>
"@

        $indexFile = "$path\index.html"
        Set-Content $indexFile $html -Encoding UTF8

        Add-Content $sitemap "  <url><loc>$url</loc></url>"
    }
}

Add-Content $sitemap "</urlset>"

Write-Host " GLOBAL FRACTAL INDEX ENGINE COMPLETE 🚀 " -ForegroundColor Green
