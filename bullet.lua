
local Bullet = {}
function Bullet:new(game, x, y, angle)
  -- print('Bullet:new', x, y, angle)
  local o = {}
  setmetatable(o, self)
  self.__index = self

  o.game = game
  o.type = ENTITY_TYPE_BULLET
  o.color = BULLET_COLOR
  o.body = love.physics.newBody(o.game.world, x, y, 'dynamic')
  o.shape = love.physics.newCircleShape(BULLET_RADIUS)
  o.fixture = love.physics.newFixture(o.body, o.shape, 2)

  o.fixture:setRestitution(0)
  o.body:setLinearDamping(0)
  o.body:setAngularDamping(0)
  o.body:setBullet(true)
  o.fixture:setUserData(o) -- deep

  o.must_dispose = false

  o.body:applyLinearImpulse(BULLET_FIRE_IMPULSE * math.cos(angle), BULLET_FIRE_IMPULSE * math.sin(angle))
  table.insert(o.game.bullets.collection, o)

  return o
end

function Bullet:draw(dt)
  love.graphics.setColor(self.color)
  local ex, ey = self.body:getWorldPoints(self.shape:getPoint())
  love.graphics.circle('fill', ex, ey, BULLET_RADIUS, 100);
end

return Bullet
