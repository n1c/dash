
local Spider = require('spider')

local Spiders = {}
function Spiders:new(game)
  -- print('Spiders:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game

  o.collection = {}
  o.last_spawn = 0;
  o.next_spawn = 3;

  return o
end

function Spiders:update(dt)
  self.last_spawn = self.last_spawn + dt;

  -- Spiders
  for i, s in pairs(self.collection) do
    if s.must_die then
      s.body:destroy()
      table.remove(self.collection, i)
    else
      -- move towards the player
      local angle_to_player = math.atan2(
        self.game.player:getY() - s.body:getY(),
        self.game.player:getX() - s.body:getX()
      )

      s.body:applyForce(
        SPIDER_MOVE_FORCE * dt * math.cos(angle_to_player),
        SPIDER_MOVE_FORCE * dt * math.sin(angle_to_player)
      )
    end
  end

  -- Chance to spawn a new spider
  if self.last_spawn > self.next_spawn then
    self.last_spawn = 0
    self.next_spawn = math.random(1, SPIDER_SPAWN_DELAY)
    table.insert(self.collection, Spider:new(self.game))
  end
end

function Spiders:draw(dt)
  for i, s in pairs(self.collection) do
    s:draw()
  end
end

return Spiders
