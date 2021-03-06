
Camera = require 'camera'

local Game = {}
function Game:new()
  print('Game:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.status = 'new'

  love.physics.setMeter(WORLD_METER)
  o.world = love.physics.newWorld(0, 0, true)
  o.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  o.map = require('map'):new(o, 'map250x250')
  o.player = require('player'):new(o)
  o.spiders = require('spiders'):new(o)
  o.energies = require('energies'):new(o)
  o.bullets = require('bullets'):new(o)

  o.cam = Camera()

  o.last_mouse_x = 0

  return o
end

function Game:update(dt)
  if love.keyboard.isDown('escape') then love.event.quit() end
  local mid = love.graphics.getWidth() / 2
  local mouse_distance = love.mouse.getX() - mid
  love.mouse.setPosition(mid, mid)

  self.player:update(dt, mouse_distance)
  self.spiders:update(dt)
  self.energies:update(dt)
  self.bullets:update(dt)

  self.world:update(dt)

  local diff = self.player:getAngle() + self.cam.rot
  if (diff ~= 0) then
    self.cam:rotate(RAD_NEG_90 - diff)
  end

  self.cam:lookAt(self.player:getX() + math.cos(self.player:getAngle()) * 200, self.player:getY() + math.sin(self.player:getAngle()) * 200)
end

function Game:draw()
  self.cam:attach()
  self.map:draw()
  self.player:draw()
  self.spiders:draw()
  self.energies:draw()
  self.bullets:draw()
  self.cam:detach()
end

-- Contact callbacks
function beginContact(a, b, coll)
  if a:getUserData().type and b:getUserData().type then
    -- print('collide ' .. a:getUserData().type .. ' - ' ..  b:getUserData().type)
  end

  if a:getUserData().type == ENTITY_TYPE_PLAYER and b:getUserData().type == ENTITY_TYPE_ENERGY then
    b:getUserData().must_collect = true -- mark this energy for collection
  end

  if a:getUserData().type == ENTITY_TYPE_WALL and b:getUserData().type == ENTITY_TYPE_SPIDER then
    -- b:getUserData().must_die = true
  end

  if a:getUserData().type == ENTITY_TYPE_SPIDER and b:getUserData().type == ENTITY_TYPE_BULLET then
    a:getUserData().must_die = true
    b:getUserData().must_dispose = true
  end

  -- Same as above but opp
  if a:getUserData().type == ENTITY_TYPE_BULLET and b:getUserData().type == ENTITY_TYPE_SPIDER then
    b:getUserData().must_die = true
    a:getUserData().must_dispose = true
  end

  if a:getUserData().type == ENTITY_TYPE_WALL and b:getUserData().type == ENTITY_TYPE_BULLET then
    b:getUserData().must_dispose = true
  end
end

return Game
