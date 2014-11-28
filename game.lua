
local Game = {}
function Game:new()
  camera:setBounds(-WINDOW_SIZE.x, -WINDOW_SIZE.y, WINDOW_SIZE.x, WINDOW_SIZE.y)
  print('Game:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.status = 'new'

  love.physics.setMeter(WORLD_METER)
  o.world = love.physics.newWorld(0, 0, true)
  o.world:setCallbacks(beginContact, endContact, preSolve, postSolve)

  o.mouse = require('mouse'):new()
  o.walls = require('walls'):new(o)
  o.player = require('player'):new(o)
  o.spiders = require('spiders'):new(o)
  o.energies = require('energies'):new(o)
  o.bullets = require('bullets'):new(o)

  o.survival_time = 0

  return o
end

function Game:update(dt)
  if love.keyboard.isDown('escape') then love.event.quit() end
  self.survival_time = self.survival_time + dt

  self.player:update(dt)
  self.spiders:update(dt)
  self.energies:update(dt)
  self.bullets:update(dt)

  self.world:update(dt)

  -- Center the camera on the player.
  camera:setPosition(self.player:getX() - WINDOW_SIZE.x / 2, self.player:getY() - WINDOW_SIZE.y / 2)
  -- @TODO: Rotate for player's north
  -- camera:setRotation(math.rad(5))
end

function Game:draw()
  camera:set()
  self.walls:draw()
  self.player:draw()
  self.spiders:draw()
  self.energies:draw()
  self.bullets:draw()
  camera:unset()

  --[[
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Juan Rhoum has survived for " .. math.ceil(self.survival_time) .. " seconds", 10, 10)
  love.graphics.print("Energy: " .. self.player.energy, 10, 25)
  love.graphics.print("mouse:    " .. self.mouse.getX() .. ':' .. self.mouse.getY(), 10, 10)
  love.graphics.print("position: " .. self.player:getX() .. ':' .. self.player:getY(), 10, 25)
  --]]
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
