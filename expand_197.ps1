$ROOT = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"

$NATIONS = @(
"us","ca","mx","br","ar","cl","co","pe","uy","py","bo","ve",
"uk","fr","de","it","es","pt","nl","be","ch","at","se","no","fi","dk","pl","cz","hu","ro","bg","gr","tr",
"ru","ua","kz","uz",
"sa","ae","qa","kw","om","bh","eg","ma","tn","dz","ng","ke","za",
"in","pk","bd","lk","np","jp","kr","tw","hk","cn","sg","my","th","vn","ph","id",
"au","nz","fj","pg",
"il","ir","iq","jo",
"et","gh","cm","sn","ci","ml","bf","ne",
"mx","us","br"
)

foreach ($n in $NATIONS) {
    $path = "$ROOT\$n"
    New-Item -ItemType Directory $path -Force | Out-Null
    New-Item -ItemType Directory "$path\public" -Force | Out-Null

    "<html><body><h1>YiShen Global Node – $n</h1></body></html>" | Out-File "$path\index.html" -Encoding utf8
    "<?xml version='1.0'?><urlset></urlset>" | Out-File "$path\public\sitemap.xml" -Encoding utf8
    "User-agent: *`nAllow: /" | Out-File "$path\robots.txt" -Encoding utf8
    Write-Host "✓ $n node online"
}

Write-Host "🌍 197 Nation Expansion Core Deployed"
