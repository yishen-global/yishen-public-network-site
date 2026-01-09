$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

Get-ChildItem $ROOT -Directory | ForEach-Object {
    $c = $_.Name
    Get-ChildItem $_.FullName -Directory | ForEach-Object {
        $l = $_.Name
        $index = "$($_.FullName)\index.html"

        if (Test-Path $index) {
            $tag = "<link rel=`"alternate`" hreflang=`"$l`" href=`"https://yishen.ai/$c/$l/`" />"
            $html = Get-Content $index -Raw

            if ($html -notmatch "hreflang") {
                $html = $html -replace "<head>", "<head>`n$tag"
                $html | Out-File $index -Encoding utf8
            }
        }
    }
}

Write-Host "🌐 Sovereign hreflang mesh injected"
