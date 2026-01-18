import os

countries = ["us","br","jp","sa","ae","kr","mx","de","fr","uk","it","es","pl","nl","se","au","ca"]

industries = [
    "office-chairs",
    "gaming-chairs",
    "standing-desks",
    "mesh-chairs",
    "ergonomic-chairs",
    "recliners",
    "sofas",
    "bar-stools",
    "dining-chairs",
    "accent-chairs"
]

template = open("index.html", "r", encoding="utf-8").read()

for c in countries:
    for i in industries:
        path = os.path.join(c, i)
        os.makedirs(path, exist_ok=True)
        with open(f"{c}/{i}/index.html", "w", encoding="utf-8") as f:
            html = template.replace("{{COUNTRY}}", c.upper()).replace("{{INDUSTRY}}", i.replace("-", " ").title())
            f.write(html)
