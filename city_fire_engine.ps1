param(
    [string]$Country,
    [string]$Cities
)

$root = "J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site"
$template = Join-Path $root "_city_template.html"

$cityList = $Cities.Split(",")

foreach ($city in $cityList) {
    $cityPath = Join-Path $root ($Country + "\" + $city)
    if (!(Test-Path $cityPath)) {
        New-Item -ItemType Directory -Path $cityPath -Force | Out-Null
    }

    $target = Join-Path $cityPath "index.html"
    Copy-Item $template $target -Force

    (Get-Content $target) -replace "{{COUNTRY}}", $Country `
                          -replace "{{CITY}}", $city | Set-Content $target
}

Write-Host ("CITY PAGES ADDED: " + $cityList.Count + " FOR " + $Country.ToUpper())
