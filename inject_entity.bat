@echo off
chcp 65001

echo ===== YiShen Entity Authority Injector =====

if not exist index.html (
  echo ❌ 没找到 index.html，请把本文件放到网站根目录再运行
  pause
  exit
)

echo ▶ 正在备份 index.html...
copy index.html index_backup_before_entity.html >nul

echo ▶ 注入实体模块...

powershell -Command ^
"$html = Get-Content index.html -Raw; ^
if ($html -match 'entity-authority') { Write-Host '已检测到实体模块，跳过'; exit }; ^
$entity = @'
<section id=""entity-authority"" style=""max-width:1200px;margin:80px auto;padding:40px;border:1px solid rgba(255,255,255,0.08);border-radius:16px;"">
<h2>YiShen Global – Office Furniture Manufacturer & Global DDP Supplier</h2>
<p>YiShen Global is a China-based office furniture manufacturer and global DDP furniture supplier, specializing in ergonomic office chairs, gaming chairs, standing desks, and functional sofas. We provide OEM & ODM production, private label manufacturing, and factory-direct wholesale solutions for distributors, retailers, and e-commerce brands worldwide.</p>
<p>Our manufacturing ecosystem integrates ISO-certified factories, BIFMA-compliant testing, environmental material sourcing, and global DDP fulfillment to the USA, EU, Middle East, Latin America, and Asia-Pacific markets.</p>
<ul>
<li>Office Chair Manufacturer</li>
<li>Gaming Chair Factory</li>
<li>Standing Desk Manufacturer</li>
<li>OEM Furniture Supplier</li>
<li>Private Label Furniture Factory</li>
<li>DDP Furniture Supplier to USA / EU / GCC</li>
</ul>
</section>
'@; ^
$schema = @'
<script type=""application/ld+json"">
{
 ""@context"": ""https://schema.org"",
 ""@type"": ""Organization"",
 ""name"": ""YiShen Global"",
 ""url"": ""https://yishen.ai"",
 ""logo"": ""https://yishen.ai/logo.webp"",
 ""description"": ""Office furniture manufacturer and global DDP supplier specializing in ergonomic office chairs, gaming chairs, standing desks, and functional sofas."",
 ""areaServed"": [""US"",""CA"",""MX"",""BR"",""DE"",""FR"",""GB"",""AE"",""SA"",""SG"",""JP"",""KR"",""AU""]
}
</script>
'@; ^
$html = $html -replace '</body>', ($entity + \"`n\" + $schema + \"`n</body>\"); ^
Set-Content index.html $html -Encoding UTF8"

echo ✅ 注入完成！
echo 备份文件：index_backup_before_entity.html
pause
