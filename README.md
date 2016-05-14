#Rails Lite

##What It Is
A working version of Rails' core functionality. You can route and render simple text content locally with help from the `Rack` gem.

##How to Run
The `lib` folder contains the actual Rails content. There are classes for `controller_base` along with its core components (`route`/`router`, `flash`, and `session`).

To see Rails Lite in action, first run `bundle install` to get the `Rack` gem.

Now, run one of the `bin` files (`ruby bin/[filename]`) from the terminal and navigate to the relevant path on `localhost:3000`. Here's a quick guide:

file/command    | path                | description
----------------|---------------------|-------------
session_server  | localhost:3000      | counts up sessions
router_server   | localhost:3000/dogs | a little site with contents and links

###Making Your Own Routes/Content
You can create new content/routes/views by following the examples in `router_server.rb`.

1. Add new actions to a controller (e.g. `show` for dogs) *OR* add a new controller with its own action. You can do this in the `router_server.rb` file, between lines 17-33.
2. Draw the route for that action with REGEX. See lines 35-37 for example.
3. Create the `view` for that controller/action combination. Be sure to name the view folder using the syntax `[controller name]_controller`!
4. Run `ruby bin/router_server.rb` and navigate to the path indicated by your regex. You should see the content!

##Techs/Language Details
All ruby, with some neat regex stuff. Also used the `binding` kernel in a pinch.

##Technical Implementation
The core functionality is all in the `lib` folder. Classes are separated into the main pieces of Rails, including `controller base`, which manages rendering content:
```ruby
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
```

`session.rb` stores/tracks cookies for the duration of the session, while `flash.rb` sets temporary cookies (e.g. for error messages).

The `Router` and its `draw` method can construct new routes paths (and direct those to views) with a regular expression:

```ruby
router = Router.new
router.draw do
  get Regexp.new("^/dogs$"), DogsController, :index
  get Regexp.new("^/dogs/(?<dog_id>\\d+)/statuses$"), StatusesController, :index
  # NOTE: You can add new routes here.
end
```
