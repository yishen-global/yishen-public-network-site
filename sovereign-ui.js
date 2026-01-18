{
  "version": 2,
  "builds": [
    { "src": "**/*.html", "use": "@vercel/static" },
    { "src": "**/*.xml", "use": "@vercel/static" },
    { "src": "**/*.txt", "use": "@vercel/static" }
  ],
  "routes": [
    { "src": "^/$", "dest": "/index.html" },
    { "src": "^/(us|mx|sa|br|de|ae|jp|kr)/?$", "dest": "/$1.html" },
    { "src": "^/robots.txt$", "dest": "/robots.txt" },
    { "src": "^/sitemap-world.xml$", "dest": "/sitemap-world.xml" }
  ]
}
