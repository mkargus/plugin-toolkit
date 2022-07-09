local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local Merge = require(script.Parent.Parent.Util.Merge)

local PluginAction = Roact.Component:extend('PluginAction')

PluginAction.defaultProps = {
  Text = '',
  Tooltip = '',
  Icon = '',
  AllowBinding = true
}

function PluginAction:init()
  local props = self.props

  local action = (props.plugin :: Plugin):CreatePluginAction(
    props.Id,
    props.Text,
    props.Tooltip,
    props.Icon,
    props.AllowBinding
  )

  action.Triggered:Connect(function()
    if props.OnTriggered then
      props.OnTriggered()
    end
  end)

  self.action = action
end

function PluginAction:render()
  return nil
end

function PluginAction:willUnmount()
  self.action:Destroy()
end

return function(props)
  return Context.use(Context.Plugin)(function(plugin)
    return Roact.createElement(PluginAction, Merge(props, {
      plugin = plugin
    }))
  end)
end
