local Roact = require(script.Parent.Parent.Roact)

local function use(context)
  return function(render)
    return Roact.createElement(context.Consumer, {
      render = function(value)
        return render(value)
      end
    })
  end
end

return {
  Plugin = Roact.createContext(nil),
  Toolbar = Roact.createContext(nil),
  ToolbarButton  = Roact.createContext(nil),

  use = use
}
