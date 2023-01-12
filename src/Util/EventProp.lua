local module = {}

function module.GetEvents(props)
  local events = {}

  for prop, value in props do
    if type(prop) == 'table' and string.match(tostring(prop), 'RoactHostEvent(.*)') and prop.name then
      events[prop.name] = value
    end
  end

  return events
end

return module
