class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern = pattern
    @http_method = http_method
    @controller_class = controller_class
    @action_name = action_name
  end

  def matches?(req)
    path_match = (req.path =~ @pattern ? true : false)
    #NOTE (to self): ^^ Matches to regex, returns 0
    path_match && req.request_method == @http_method.to_s.upcase
  end

  def run(req, res)
    params = @pattern.match(req.path)
    route_params = Hash[params.names.zip(params.captures)]
    controller = @controller_class.new(req, res, route_params)
    controller.invoke_action(@action_name)
  end
end
