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
    res.header["location"] = url
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
    contents = File.read("views/#{self.class.to_s.underscore}/#{template_name}.html.erb")
    erb_template = ERB.new(contents)
    render_content(erb_template.result(binding), 'text/html')
    #NOTE (to self): At this stage, it's only rendering my_controller when you run p03... because that's all that's inside p03!
  end

  def session
    @session ||= Session.new(@req)
  end

  def flash
    @flash ||= Flash.new(@req)
  end

  def invoke_action(name)
    self.send(name)
    render(name.to_sym) unless already_built_response?
  end
end
