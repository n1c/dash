
local Bullet = require('bullet')

local Bullets = {}
function Bullets:new(game)
  -- print('Bullets:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self
  o.game = game
  o.collection = {}
  return o
end

function Bullets:update(dt)
  -- Bullets
  for i, e in pairs(self.collection) do
    if e.must_dispose then
      e.body:destroy()
      table.remove(self.collection, i)
    end
  end
end

function Bullets:draw(dt)
  for i, e in pairs(self.collection) do
    e:draw()
  end
end

return Bullets
