local Roact = require(script.Parent.Parent.Roact)
local Context = require(script.Parent.Context)
local TableMerge = require(script.Parent.Util.TableMerge)
local EventProp = require(script.Parent.Util.EventProp)

local MenuItem = Roact.Component:extend('MenuItem')

MenuItem.defaultProps = {
  Separator = false
}

function MenuItem:createItem()
  local props = self.props
  local events = EventProp.GetEvents(props)
  local menu = props.menu
  local item

  if props.Separator then
    item = menu:AddSeparator()
  else
    item = menu:AddNewAction(props.Id, props.Label or props.Id, props.Icon)
    item.Triggered:Connect(function()
      if events.Triggered then
        events.Triggered(item)
      end
    end)
  end

  self.item = item
end

function MenuItem:init()
  self:createItem()
end

function MenuItem:render()
  return nil
end

function MenuItem:willUnmount()
  if self.item then
    self.item:Destroy()
  end
end

return function(props)
  return Context.use(Context.Menu, function(menu)
    return Roact.createElement(MenuItem, TableMerge(props, {
      menu = menu
    }))
  end)
end
