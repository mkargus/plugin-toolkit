local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local TableMerge = require(script.Parent.Util.TableMerge)
local EventProp = require(script.Parent.Util.EventProp)

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

  for eventName, callback in EventProp.GetEvents(props) do
    action[eventName]:Connect(function(...)
      callback(action, ...)
    end)
  end

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
  return Context.use(Context.Plugin, function(plugin)
    return Roact.createElement(PluginAction, TableMerge(props, {
      plugin = plugin
    }))
  end)
end
