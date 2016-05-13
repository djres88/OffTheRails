require 'rack'
require_relative '../lib/controller_base'

class SessionController < ControllerBase
  def go
    session["count"] ||= 0
    session["count"] += 1
    render :count
  end
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  SessionController.new(req, res).go
  res.finish
end

Rack::Server.start(
  app: app,
  Port: 3000
)
