
# This rack file has 2 middleware filters and an empty app
# 1) Rack-rewrite to append "/index.html" to URLs without "."
# 2) Rack::Static to serve static files

gem 'rack-rewrite', '~> 1.0.0'
require 'rack/rewrite'
use Rack::Rewrite do
  r301 %r{^([^\.]*[^\/])$}, '$1/' 
  r301 %r{^(.*\/)$}, '$1index.html'
end

use Rack::Static, :urls => ["/"], :root => Dir.pwd + '/output'

# Empty app, should never be reached:
class Euruko2009
  def call(env)
    [200, {"Content-Type" => "text/html"}, ["Ouch, broken link! Please report to http://srug.org/"] ]
  end  
end
run Euruko2009.new
