class Flash
  def initialize(req)
    cookies = req.cookies["_rails_lite_flash"]
    @persist = {}

    if cookies.nil?
      @now = {}
    else
      @now = JSON.parse(cookies)
    end

  end

  def now
    @now
  end

  def [](key)
    @persist[key]
  end

  def []=(key, val)
    @persist[key] = val
  end

  def store_flash(res)
    res.set_cookie('_rails_lite_flash',
      { value: @persist.to_json,
       path: "/" })
  end
end
