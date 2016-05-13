require 'active_support'
require 'active_support/core_ext'
require 'active_support/inflector'
require 'erb'
require_relative './session'
require_relative './flash'

class ControllerBase
  attr_reader :req, :res, :params
  def initialize(req, res, params = {})
    @req = req
    @res = res
    @params = params
    @already_built_response = false
  end

  def already_built_response?
    @already_built_response
  end

  def redirect_to(url)
    res.header["Location"] = url
    res.status = 302

    if @already_built_response
      raise "Rendered more than once!"
    end

    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def render_content(content, content_type)
    @res.write(content)
    @res['Content-Type'] = content_type

    if @already_built_response
      raise "Rendered more than once!"
    end
    @already_built_response = true
    session.store_session(@res)
    flash.store_flash(@res)
  end

  def render(template_name)
    dir_path = File.dirname(__FILE__)
    template_name = File.join(
      dir_path,
      "..",
      "views",
      self.class.name.to_s.underscore,
      "#{template_name}.html.erb"
    )

    template = File.read(template_name)

    render_content(
      ERB.new(template).result(binding), "text/html"
    )
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name) unless already_built_response?
  end
end
