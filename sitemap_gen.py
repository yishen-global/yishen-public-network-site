import glob, os

urls = []
for f in glob.glob("**/index.html", recursive=True):
    url = f.replace("\\","/").replace("index.html","")
    urls.append("https://yishen.ai/" + url)

os.makedirs("sitemaps", exist_ok=True)
with open("sitemaps/sitemap-master.xml","w") as s:
    s.write("<urlset>")
    for u in urls:
        s.write(f"<url><loc>{u}</loc></url>")
    s.write("</urlset>")
