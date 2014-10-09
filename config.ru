require "rack-livereload"

use Rack::LiveReload

map "/" do
  use Rack::Static, urls: [""], root: "home", index: "index.html"
  run lambda {|env|}
end
