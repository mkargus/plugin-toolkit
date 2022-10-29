local Roact = require(script.Packages.Roact)
local App = require(script.App)

local tree = Roact.createElement(App)

local handler = Roact.mount(tree)

plugin.Unloading:Connect(function()
  Roact.unmount(handler)
end)
