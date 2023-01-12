local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local TableMerge = require(script.Parent.Util.TableMerge)
local EventProp = require(script.Parent.Util.EventProp)

local ToolbarButton = Roact.Component:extend('ToolbarButton')

ToolbarButton.defaultProps = {
  ClickableWhenViewportHidden = false,
  Tooltip = '',
  Icon = '',
  Enabled = true,
  Active = false
}

function ToolbarButton:init()
  local props = self.props

  local button = (props.toolbar :: PluginToolbar):CreateButton(
    props.Id,
    props.Tooltip,
    props.Icon
  )

  button.ClickableWhenViewportHidden = props.ClickableWhenViewportHidden
  button.Enabled = props.Enabled
  button:SetActive(props.Active)

  for eventName, callback in EventProp.GetEvents(props) do
    button[eventName]:Connect(function(...)
      callback(button, ...)
    end)
  end

  button.Click:Connect(function()
    if props.OnClick then
      warn('OnClick is deprecated and will be removed. Replace OnClick with [Roact.Event.Click]')
      props.OnClick()
    end
  end)

  self.button = button
end

function ToolbarButton:render()
  return nil
end

function ToolbarButton:didUpdate(lastProps)
  if lastProps.Active ~= self.props.Active then
    self.button:SetActive(self.props.Active)
  end

  if lastProps.Enabled ~= self.props.Enabled then
    self.button.Enabled = self.props.Enabled
  end
end

function ToolbarButton:willUnmount()
  self.button:Destroy()
end

return function(props)
  return Context.use(Context.Toolbar, function(toolbar)
    return Roact.createElement(ToolbarButton, TableMerge(props, {
      toolbar = toolbar
    }))
  end)
end
