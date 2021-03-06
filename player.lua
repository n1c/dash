
local Bullet = require('bullet')

local Player = {}
function Player:new(game)
  -- print('Player:new')
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game

  local spawn = o.game.map:getSpawn()

  o.type = ENTITY_TYPE_PLAYER
  o.color = PLAYER_COLOR
  o.body = love.physics.newBody(o.game.world, spawn.x, spawn.y, 'dynamic')
  o.shape = love.physics.newCircleShape(PLAYER_RADIUS)
  o.fixture = love.physics.newFixture(o.body, o.shape, 1)

  o.fixture:setUserData(o)
  o.fixture:setRestitution(0.8)
  o.body:setLinearDamping(12)
  o.body:setAngularDamping(8)

  o.angle = RAD_NEG_90
  o.energy = 100
  o.must_dash = false
  o.must_fire = false
  o.last_dash_time = 0
  o.last_fire_time = 0

  return o
end

function Player:getX()
  return self.body:getX()
end

function Player:getY()
  return self.body:getY()
end

function Player:getAngle()
  return self.angle
end

function Player:getNoseX()
  return self:getX() + math.cos(self.angle) * PLAYER_RADIUS
end

function Player:getNoseY()
  return self:getY() + math.sin(self.angle) * PLAYER_RADIUS
end

function Player:update(dt, input_turn_force)
  self.last_dash_time = self.last_dash_time + dt
  self.last_fire_time = self.last_fire_time + dt

  -- Don't worry about changing the angle unless there's mouse input
  if input_turn_force ~= 0 then
    self.angle = self.angle + ((input_turn_force / 1000) * MOUSE_SENSITIVITY)
    self.body:setAngle(self.angle)
  end

  local force_angle = self.angle
  local forcedt = PLAYER_MOVE_FORCE * dt

  if love.keyboard.isDown('w') then
    self.body:applyForce(
      forcedt * math.cos(force_angle),
      forcedt * math.sin(force_angle)
    )
  end

  if love.keyboard.isDown('a') then
    self.body:applyForce(
      forcedt * math.cos(force_angle - math.rad(90)),
      forcedt * math.sin(force_angle - math.rad(90))
    )
  end

  if love.keyboard.isDown('d') then
    self.body:applyForce(
      forcedt * math.cos(force_angle + math.rad(90)),
      forcedt * math.sin(force_angle + math.rad(90))
    )
  end

  if love.keyboard.isDown('s') then
    self.body:applyForce(
      forcedt * math.cos(force_angle + math.rad(180)),
      forcedt * math.sin(force_angle + math.rad(180))
    )
  end

  self.must_fire = love.mouse.isDown('l');
  self.must_dash = love.mouse.isDown('r');

  if self.must_dash and self.last_dash_time > PLAYER_DASH_WAIT then
    self.last_dash_time = 0
    self.must_dash = false
    self.body:applyLinearImpulse(PLAYER_DASH_IMPULSE * math.cos(force_angle), PLAYER_DASH_IMPULSE * math.sin(force_angle))
  end

  if self.must_fire and self.last_fire_time > PLAYER_FIRE_WAIT then
    self.last_fire_time = 0
    self.must_fire = false
    Bullet:new(self.game, self:getNoseX(), self:getNoseY(), self:getAngle())
  end
end

function Player:draw(dt)
  love.graphics.setColor(self.color);
  love.graphics.circle('fill', self:getX(), self:getY(), PLAYER_RADIUS, 100);

  -- Player 'gun'
  love.graphics.setColor(PLAYER_COLOR_GUN)
  love.graphics.line(self:getX(), self:getY(), self:getNoseX(), self:getNoseY())
end

return Player
