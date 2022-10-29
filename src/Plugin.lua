local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)

return function(props)
  return Roact.createElement(Context.Plugin.Provider, {
    value = props.plugin
  }, props[Roact.Children])
end
