import glob, os

groups = {
    "countries": [],
    "cities": [],
    "industries": []
}

for f in glob.glob("**/index.html", recursive=True):
    p = f.replace("\\","/")
    depth = p.count("/")
    if depth == 1: groups["countries"].append(p)
    elif depth == 2: groups["cities"].append(p)
    else: groups["industries"].append(p)

os.makedirs("sitemaps", exist_ok=True)

def write(name, urls):
    with open(f"sitemaps/sitemap-{name}.xml","w") as s:
        s.write("<urlset>")
        for u in urls:
            s.write(f"<url><loc>https://yishen.ai/{u.replace('index.html','')}</loc></url>")
        s.write("</urlset>")

for k,v in groups.items():
    write(k,v)
