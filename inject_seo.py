import glob

def inject(html, city, country, product, intent):
    title = f"{city} {product} {intent} | Factory Direct | YISHEN"
    h1 = f"{product} {intent} in {city}, {country}"
    faq = f"""
    <script type="application/ld+json">
    {{
      "@context":"https://schema.org",
      "@type":"FAQPage",
      "mainEntity":[
        {{"@type":"Question","name":"What is MOQ?","acceptedAnswer":{{"@type":"Answer","text":"Low MOQ factory direct supply."}}}},
        {{"@type":"Question","name":"Delivery time?","acceptedAnswer":{{"@type":"Answer","text":"Fast lead time with stable capacity."}}}},
        {{"@type":"Question","name":"OEM available?","acceptedAnswer":{{"@type":"Answer","text":"OEM/ODM private label supported."}}}}
      ]
    }}
    </script>
    """
    html = html.replace("</head>", f"<title>{title}</title></head>")
    html = html.replace("<body>", f"<body><h1>{h1}</h1>{faq}")
    return html

for f in glob.glob("**/index.html", recursive=True):
    parts = f.split("\\")
    if len(parts) >= 3:
        country = parts[0].upper()
        city = parts[1].replace("-"," ").title()
        product = parts[2].replace("-"," ").title()
        intent = "Supplier"
        html = open(f,encoding="utf-8").read()
        new = inject(html, city, country, product, intent)
        open(f,"w",encoding="utf-8").write(new)
