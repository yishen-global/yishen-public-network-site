$ROOT="J:\YISHEN_SOVEREIGN_GROWTH_OS\PUBLIC_NETWORK\site\city"
$urls=Get-ChildItem $ROOT -Directory
$xml = "<urlset xmlns='http://www.sitemaps.org/schemas/sitemap/0.9'>"
foreach($u in $urls){
 $xml+="<url><loc>https://yishen.ai/city/$($u.Name)</loc></url>"
}
$xml+="</urlset>"
$xml | Set-Content "$ROOT\..\sitemap-world.xml"
