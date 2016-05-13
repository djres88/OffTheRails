require 'json'

class Session
  def initialize(req)
    cookies = req.cookies["_rails_lite_app"]
    #NOTE (to self): Set default if no cookies passed
    if cookies.nil?
      @cookies = {}
    else
      @cookies = JSON.parse(cookies)
    end

  end

  def [](key)
    @cookies[key]
  end

  def []=(key, val)
    @cookies[key] = val
  end

  def store_session(res)
    res.set_cookie('_rails_lite_app',
      { value: @cookies.to_json,
       path: "/" })
  end
end


#NOTE (to self): ^Provides the ability to set cookie data in the controller. This class reads in/sends out cookie data.
