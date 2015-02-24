require "rack"
require "rack/contrib/try_static"
require "rack/contrib/not_found"

use Rack::TryStatic, urls: ["/"], root: "gh-pages", try: ["index.html", "/index.html"]
run Rack::NotFound.new("gh-pages/404.html")
