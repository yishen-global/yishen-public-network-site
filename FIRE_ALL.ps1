Write-Host "🔥 Sovereign NAV + LOGO + 404 Immunity Injecting..."

$site = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

Get-ChildItem $site -Recurse -Filter *.html | ForEach-Object {
    $p = $_.FullName
    $c = Get-Content $p -Raw

    if ($c -notmatch "sovereign-nav") {
        $inject = "<div id='sovereign-nav' style='background:#000;color:#fff;padding:10px;text-align:center'>YISHEN GLOBAL NETWORK</div>"
        $c = $c -replace "<body>", "<body>$inject"
        Set-Content $p $c -Encoding UTF8
        Write-Host "Injected $p"
    }
}

Write-Host "✅ ALL PAGES IMMUNIZED"
