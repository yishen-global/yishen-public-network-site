Write-Host "🔥 YiShen Sovereign OS Fire Starting..." -ForegroundColor Cyan

# ===== 主权入口 =====
$index = @'
<!DOCTYPE html>
<html><head><meta charset="utf-8"><title>YiShen Global</title></head>
<body style="background:#020617;color:#7dd3fc;display:flex;align-items:center;justify-content:center;height:100vh;text-align:center;font-family:Arial">
<a href="/sovereign/dashboard.html"><button style="padding:18px 44px;border:none;border-radius:12px;background:#0ea5e9;color:white;font-size:20px">ENTER SYSTEM</button></a>
</body></html>
'@
Set-Content index.html $index

# ===== 后台 =====
New-Item -ItemType Directory -Path sovereign -Force | Out-Null

$dashboard = @'
<!DOCTYPE html>
<html><body style="background:#020617;color:#7dd3fc;font-family:Arial;padding:30px">
<h2>Sovereign Control Panel</h2>
<a href="nodes.html">National Nodes</a> |
<a href="radar.html">Buyer Radar</a> |
<a href="rfq.html">RFQ</a> |
<a href="autoquote.html">AutoQuote</a> |
<a href="supplier.html">Supplier</a>
</body></html>
'@
Set-Content sovereign\dashboard.html $dashboard

# ===== 子模块 =====
$pages = @{
 "nodes.html" = "<h2>National Nodes</h2><p>USA / UAE / MEXICO / BRAZIL</p>";
 "radar.html" = "<h2>Buyer Radar</h2>";
 "rfq.html" = "<h2>RFQ Gateway</h2><textarea style='width:100%;height:100px'></textarea>";
 "autoquote.html" = "<h2>Auto Quote</h2><input placeholder='Product'><br><input placeholder='Qty'>";
 "supplier.html" = "<h2>Supplier Interface</h2>"
}

foreach($p in $pages.Keys){
  $content = "<html><body style='background:#020617;color:#7dd3fc;font-family:Arial;padding:30px'>" + $pages[$p] + "</body></html>"
  Set-Content "sovereign\$p" $content
}

# ===== 一键上线 =====
vercel --prod --force

Write-Host "🚀 Sovereign OS Fire Completed" -ForegroundColor Green
