
local Mouse = {}
function Mouse:new()
  -- print('Mouse:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self
  return o
end

function Mouse:getX()
  return camera:getMousePositionX()
end

function Mouse:getY()
  return camera:getMousePositionY()
end

return Mouse
