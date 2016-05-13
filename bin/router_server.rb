require 'rack'
require_relative '../lib/controller_base'
require_relative '../lib/router'


$dogs = [
  { id: 1, name: "Coco" },
  { id: 2, name: "Max" }
]

$dog_statuses = [
  { id: 1, dog_id: 1, text: "Coco wants to go out." },
  { id: 2, dog_id: 2, text: "Max stole a pizza off the table." },
  { id: 3, dog_id: 1, text: "Coco barks at the mailman." }
]

class StatusesController < ControllerBase
  def index
    statuses = $dog_statuses.select do |s|
      s[:dog_id] == Integer(params['dog_id'])
    end

    render_content(statuses.to_json, "application/json")
  end
end

class DogsController < ControllerBase
  def index
    render_content($dogs.to_json, "application/json")
  end
end

router = Router.new
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/(?<dog_id>\\d+)/statuses$"), StatusesController, :index
end

app = Proc.new do |env|
  req = Rack::Request.new(env)
  res = Rack::Response.new
  router.run(req, res)
  res.finish
end

Rack::Server.start(
 app: app,
 Port: 3000
)
