local Roact = require(script.Parent.Packages.Roact)
local PluginToolkit = require(script.Parent.Packages.PluginToolkit)

local App = Roact.PureComponent:extend('App')

function App:init()
  self.state = {
    Enabled = false
  }
end

function App:render()
  local props = self.props
  local state = self.state

  return Roact.createElement(PluginToolkit.Plugin, {
    plugin = props.plugin
  }, {

    Toolbar = Roact.createElement(PluginToolkit.Toolbar, {
      Name = 'Example',
    }, {
      WidgetToggle = Roact.createElement(PluginToolkit.ToolbarButton, {
        Id = 'Toggle Widget',
        ClickableWhenViewportHidden = true,
        Active = state.Enabled,
        OnClick = function()
          self:setState({ Enabled = not state.Enabled })
        end
      })
    }),

    Widget = Roact.createElement(PluginToolkit.Widget, {
      Id = 'ExampleWidget',
      FloatingSize = Vector2.new(100, 100),
      MinimumSize = Vector2.new(200, 200),

      Enabled = state.Enabled,

      OnClose = function()
        self:setState({ Enabled = false })
      end
    })

  })
end

return App
