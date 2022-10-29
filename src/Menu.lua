local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local TableMerge = require(script.Parent.Util.TableMerge)

local Menu = Roact.Component:extend('Menu')

Menu.defaultProps = {
  Enabled = false
}

function Menu:init()
  local props = self.props
  local menu = props.plugin:CreatePluginMenu(props.Id)

  function self.openMenu()
    self.isOpen = true
    task.spawn(function()
      local result = menu:ShowAsync()
      self.isOpen = false

      if props.OnClose then
        props.OnClose(result)
      end
    end)

  end

  self.menu = menu
end

function Menu:render()
  if not (self.props.Enabled or self.isOpen) then
    return nil
  end

  return Roact.createElement(Context.Menu.Provider, {
    value = self.menu
  }, self.props[Roact.Children])
end

function Menu:didMount()
  if self.props.Enabled then
    self.openMenu()
  end
end

function Menu:didUpdate()
  if self.props.Enabled then
    self.openMenu()
  end
end

function Menu:willUnmount()
  self.menu:Destroy()
end

return function(props)
  return Context.use(Context.Plugin, function(plugin)
    return Roact.createElement(Menu, TableMerge(props, {
      plugin = plugin
    }))
  end)
end
