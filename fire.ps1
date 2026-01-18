Write-Host "🔥 YiShen Sovereign OS Fire Starting..." -ForegroundColor Cyan

# 主权入口
$index = @'
<!DOCTYPE html><html><head><meta charset="utf-8"><title>YiShen Global</title></head>
<body style="background:#020617;color:#7dd3fc;display:flex;align-items:center;justify-content:center;height:100vh;text-align:center;font-family:Arial">
<a href="/sovereign/dashboard.html"><button style="padding:18px 44px;border:none;border-radius:12px;background:#0ea5e9;color:white;font-size:20px">ENTER SYSTEM</button></a>
</body></html>
'@
Set-Content index.html $index

mkdir sovereign -Force | Out-Null

# 后台
$dashboard = @'
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

# 子模块
"nodes.html","radar.html","rfq.html","autoquote.html","supplier.html" | %{
  Set-Content "sovereign\$_" "<html><body style='background:#020617;color:#7dd3fc;font-family:Arial;padding:30px'><h2>$_ module</h2></body></html>"
}

# 一键上线
vercel --prod --force

Write-Host "🚀 DONE"
