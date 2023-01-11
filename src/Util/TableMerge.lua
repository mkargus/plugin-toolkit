return function (org, add)
  local newTable = table.clone(org)

  for key, value in pairs(add) do
    newTable[key] = value
  end

  return newTable
end
