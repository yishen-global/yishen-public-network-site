# =========================
# YISHEN GLOBAL SOVEREIGN PAGE FACTORY
# =========================

$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$BASE_URL = "https://yishen.ai"

$NATIONS = @(
@{cc="us"; name="United States"},
@{cc="sa"; name="Saudi Arabia"},
@{cc="mx"; name="Mexico"},
@{cc="br"; name="Brazil"},
@{cc="de"; name="Germany"},
@{cc="fr"; name="France"},
@{cc="uk"; name="United Kingdom"},
@{cc="jp"; name="Japan"},
@{cc="kr"; name="South Korea"},
@{cc="ae"; name="United Arab Emirates"}
)

$SUBMIT = @()
$SITEMAP = @()

foreach ($n in $NATIONS) {

    $cc = $n.cc
    $name = $n.name
    $dir = "$ROOT\$cc"
    $url = "$BASE_URL/$cc/"

    if (!(Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir | Out-Null
    }

    $html = @"
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<title>$name | YiShen Global</title>
<meta name="description" content="YiShen Global $name sovereign logistics & supply chain network">
</head>
<body>
<h1>YiShen Global $name Node</h1>
<p>Official sovereign node for $name</p>
</body>
</html>
"@

    Set-Content "$dir\index.html" $html -Encoding UTF8

    $SUBMIT += "$url"
    $SITEMAP += "<url><loc>$url</loc></url>"
}

# submit list
$SUBMIT | Set-Content "$ROOT\submit_list_249.txt" -Encoding UTF8

# sitemap
$xml = @"
<?xml version="1.0" encoding="UTF-8"?>
<urlset xmlns="http://www.sitemaps.org/schemas/sitemap/0.9">
$($SITEMAP -join "`n")
</urlset>
"@

Set-Content "$ROOT\sitemap-world.xml" $xml -Encoding UTF8

Write-Host "GLOBAL SOVEREIGN PAGE FACTORY COMPLETE" -ForegroundColor Green
