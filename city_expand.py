import os

city_map = {
    "us": ["new-york","los-angeles","chicago","houston","miami"],
    "br": ["sao-paulo","rio-de-janeiro","curitiba","porto-alegre"],
    "de": ["berlin","hamburg","munich","frankfurt"],
    "jp": ["tokyo","osaka","nagoya","fukuoka"],
    "sa": ["riyadh","jeddah","dammam","mecca"],
    "ae": ["dubai","abu-dhabi","sharjah"],
    "mx": ["mexico-city","guadalajara","monterrey"],
    "fr": ["paris","lyon","marseille"],
    "uk": ["london","manchester","birmingham"]
}

template = open("index.html", "r", encoding="utf-8").read()

for country, cities in city_map.items():
    for city in cities:
        path = os.path.join(country, city)
        os.makedirs(path, exist_ok=True)
        with open(f"{country}/{city}/index.html", "w", encoding="utf-8") as f:
            f.write(template.replace("{{COUNTRY}}", country.upper()).replace("{{CITY}}", city.replace("-", " ").title()))
