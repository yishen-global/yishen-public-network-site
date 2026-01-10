Clear-Host
Write-Host '=== YISHEN PHASE V SAFE CORE START ===' -ForegroundColor Green

$ROOT   = 'J:\YISHEN_SOVEREIGN_GROWTH_OS'
$DEPLOY = "$ROOT\DEPLOY"
$SITE   = "$ROOT\PUBLIC_NETWORK\site"
$LOG    = "$DEPLOY\phase_v.log"

function Log($m){
  Add-Content -Path $LOG -Value ('['+(Get-Date)+'] '+$m)
}

Log 'Phase V started'

$countries = 'us','sa','mx','br','de','fr','it','es','jp','kr','ae','uk','ca','au','sg','th','vn'
foreach($c in $countries){
  $p="$SITE\$c"
  if(!(Test-Path $p)){
    New-Item -ItemType Directory -Path $p | Out-Null
    Copy-Item "$SITE\index.html" "$p\index.html"
    Log "Country node: $c"
  }
}

$langs = 'en','es','pt','fr','de','ar','jp','kr','th','vi'
foreach($l in $langs){
  $p="$SITE\lang\$l"
  if(!(Test-Path $p)){
    New-Item -ItemType Directory -Path $p | Out-Null
    Copy-Item "$SITE\index.html" "$p\index.html"
    Log "Lang node: $l"
  }
}

$q="$DEPLOY\outreach_queue.json"
if(!(Test-Path $q)){
  '{""status"":""ready"",""daily_limit"":100}' | Out-File $q -Encoding UTF8
  Log 'Outreach queue ready'
}

cd $DEPLOY
git add .
git commit -m 'phase v safe core' 2>$null
git push origin main

Write-Host '=== PHASE V SAFE CORE COMPLETE ===' -ForegroundColor Green
Log 'Phase V complete'
