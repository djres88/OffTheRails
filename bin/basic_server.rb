require 'rack'

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  res['Content-Type'] = 'text/html'
  #NOTE to self: write a custom response -- want to respond with path
  #see http://www.rubydoc.info/gems/rack/Rack/Response, http://www.rubydoc.info/gems/rack/Rack/Request
  res.write(req.path)
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
