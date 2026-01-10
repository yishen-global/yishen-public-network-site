import os

countries = [
    "us","sa","mx","br","de","fr","uk","it","es","pl","nl","be","se","no","fi","dk",
    "ru","ua","tr","jp","kr","tw","sg","th","vn","my","id","ph","au","nz",
    "ae","qa","kw","bh","om","eg","ma","ng","ke","za",
    "in","pk","bd","lk",
    "il","ir","iq","jo","lb",
    "cl","co","pe","ar","uy","py","bo","ve","ec","gt","hn","sv","cr","pa",
    "ca","do","cu","ht",
]

template = open("index.html", "r", encoding="utf-8").read()

for c in countries:
    path = os.path.join(c)
    os.makedirs(path, exist_ok=True)
    with open(f"{c}/index.html", "w", encoding="utf-8") as f:
        f.write(template.replace("{{COUNTRY}}", c.upper()))
