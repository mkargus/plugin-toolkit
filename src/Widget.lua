local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local TableMerge = require(script.Parent.Util.TableMerge)
local EventProp = require(script.Parent.Util.EventProp)

local CUSTOM_EVENTS = {
  'OnInit'
}

local StudioWidget = Roact.Component:extend('StudioWidget')

StudioWidget.defaultProps = {
  InitialDockState = Enum.InitialDockState.Float,
  Enabled = false,
  OverridePreviousState = false,
  FloatingSize = Vector2.new(0, 0),
  MinimumSize = Vector2.new(0, 0),
  ZIndexBehavior = Enum.ZIndexBehavior.Sibling
}

function StudioWidget:init()
  local props = self.props

  local WidgetInfo = DockWidgetPluginGuiInfo.new(
    props.InitialDockState,
    props.Enabled,
    props.OverridePreviousState,
    props.FloatingSize.X, props.FloatingSize.Y,
    props.MinimumSize.X, props.MinimumSize.Y
  )

  local widget = props.plugin:CreateDockWidgetPluginGui(props.Id, WidgetInfo) :: DockWidgetPluginGui

  widget.Name = props.Id
  widget.Title = props.Title or props.Id
  widget.ZIndexBehavior = props.ZIndexBehavior

  for eventName, callback in EventProp.GetEvents(props) do
    if not table.find(CUSTOM_EVENTS, eventName) then
      widget[eventName]:Connect(function(...)
        callback(widget, ...)
      end)
    end
  end

  widget:BindToClose(function()
    if props.OnClose then
      props.OnClose()
    end
  end)

  self.widget = widget
end

function StudioWidget:render()
  return Roact.createElement(Context.Widget.Provider, {
    value = self.widget
  }, {
    Roact.createElement(Roact.Portal, {
      target = self.widget
    }, self.props[Roact.Children])
  })
end

function StudioWidget:didMount()
  if self.props[Roact.Event.OnInit] then
    self.props[Roact.Event.OnInit](self.widget)
  end
end

function StudioWidget:didUpdate(lastProps)
  if lastProps.Enabled ~= self.props.Enabled then
    self.widget.Enabled = self.props.Enabled
  end

  if lastProps.Title ~= self.props.Title then
    self.widget.Title = self.props.Title or self.props.Id
  end
end

function StudioWidget:willUnmount()
  self.widget:Destroy()
end

return function(props)
  return Context.use(Context.Plugin, function(plugin)
    return Roact.createElement(StudioWidget, TableMerge(props, {
      plugin = plugin
    }))
  end)
end
