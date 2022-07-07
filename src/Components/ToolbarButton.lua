local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local Merge = require(script.Parent.Parent.Util.Merge)

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

  button.Click:Connect(function()
    if props.OnClick then
      props.OnClick()
    end
  end)

  self.button = button
end

function ToolbarButton:render()
  return Roact.createElement(Context.ToolbarButton.Provider, {
    value = self.button
  })
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
  return Context.use(Context.Toolbar)(function(toolbar)
    return Roact.createElement(ToolbarButton, Merge(props, {
      toolbar = toolbar
    }))
  end)
end
