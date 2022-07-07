local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local Merge = require(script.Parent.Parent.Util.Merge)

local PluginToolbar = Roact.Component:extend('PluginToolbar')

function PluginToolbar:init()
  self.toolbar = self.props.plugin:CreateToolbar(self.props.Name)
end

function PluginToolbar:render()
  return Roact.createElement(Context.Toolbar.Provider, {
    value = self.toolbar
  }, self.props[Roact.Children])
end

function PluginToolbar:willUnmount()
  self.toolbar:Destroy()
end

return function(props)
  return Context.use(Context.Plugin)(function(plugin)
    return Roact.createElement(PluginToolbar, Merge(props, {
      plugin = plugin
    }))
  end)
end
