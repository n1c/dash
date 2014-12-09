
local Block = require('block')
local Map = {}
function Map:new(game, name)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game
  o.name = name
  o.image = love.graphics.newImage('maps/' .. name .. '.bmp')
  o.imageData = o.image:getData()

  local w, h = o.image:getWidth(), o.image:getHeight()

  o.collection = {}
  o.spawns = {}
  for y = 0, h - 1 do
    for x = 0, w - 1 do
      local r, g, b, a = o.imageData:getPixel(x, y)
      if r == 0 and g == 255 and b == 0 and a == 255 then
        table.insert(o.collection, Block:new(o.game, x * 10, y * 10, 10, 10))
      elseif r == 255 and g == 0 and b == b and a == 255 then
        table.insert(o.spawns, { x = x * 10, y = y * 10 })
      else
        -- print(x, y, r, g, b, a)
      end
    end
  end

  return o
end

function Map:getSpawn()
  return self.spawns[ math.random(#self.spawns) ]
end

function Map:draw(dt)
  for i, b in pairs(self.collection) do
    b:draw()
  end
end

return Map
