local Roact = require(script.Parent.Parent.Roact)

local function use(context, render)
  return Roact.createElement(context.Consumer, {
    render = function(value)
      return render(value)
    end
  })
end

return {
  Plugin = Roact.createContext(nil),
  Toolbar = Roact.createContext(nil),
  Widget = Roact.createContext(nil),

  use = use
}
