local Roact = require(script.Parent.Packages.Roact)
local PluginToolkit = require(script.Parent.Packages.PluginToolkit)

local App = Roact.PureComponent:extend('App')

function App:init()
  self.state = {
    Enabled = false
  }
end

function App:render()
  local state = self.state

  return Roact.createFragment({
    Toolbar = Roact.createElement(PluginToolkit.Toolbar, {
      Name = 'Example',
    }, {
      WidgetToggle = Roact.createElement(PluginToolkit.ToolbarButton, {
        Id = 'Toggle Widget',
        ClickableWhenViewportHidden = true,
        Active = state.Enabled,
        OnClick = function()
          self:setState({ Enabled = not self.state.Enabled })
        end
      })
    }),

    Widget = Roact.createElement(PluginToolkit.Widget, {
      Id = 'ExampleWidget',
      FloatingSize = Vector2.new(100, 100),
      MinimumSize = Vector2.new(200, 200),
      OverridePreviousState = true,

      Enabled = state.Enabled,

      OnClose = function()
        self:setState({ Enabled = false })
      end,
      [Roact.Event.WindowFocused] = function()
        print("I'm in focus :D")
      end,
      [Roact.Event.WindowFocusReleased] = function()
        print("I'm not in focus :(")
      end
    }),

    Action = Roact.createElement(PluginToolkit.PluginAction, {
      Id = 'Example Action',
      Text = 'Example Action',

      OnTriggered = function()
        print('PluginAction Triggered.')
      end
    }),

    Menu = Roact.createElement(PluginToolkit.Menu, {
      Id = 'TestMenu',
      Enabled = state.Enabled,
      OnClose = function(result)
        if result then
          print('Selected Action: ' ..result.ActionId)
        end
      end
    }, {
      Roact.createElement(PluginToolkit.MenuItem, {
        Id = 'Test1',
        Label = 'Test Label A',
        OnTriggered = function()
          print('Triggered')
        end
      }),
      Roact.createElement(PluginToolkit.MenuItem, {
        Separator = true
      }),
      Roact.createElement(PluginToolkit.MenuItem, {
        Id = 'Test2',
        Label = 'Test Label B',
        Icon = 'rbxassetid://11257981829',
        OnTriggered = function()
          print('Triggered2')
        end
      }),
    })

  })
end

return App
