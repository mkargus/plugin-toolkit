return function (...)
  local newTable = {}

  for _, dict in ipairs({...}) do
    for key, value in pairs(dict) do
      newTable[key] = value
    end
  end

  return newTable
end
