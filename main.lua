
require('util')
require('camera')

WINDOW_SIZE = {
  x = 800,
  y = 800,
}

WORLD_SIZE = 800
WORLD_METER = 64

MOUSE_SENSITIVITY = 1

ENTITY_TYPE_PLAYER = 'PLAYER'
ENTITY_TYPE_WALL = 'WALL'
ENTITY_TYPE_ENERGY = 'ENERGY'
ENTITY_TYPE_SPIDER = 'SPIDER'
ENTITY_TYPE_BULLET = 'BULLET'

PLAYER_COLOR = { 52, 152, 219 }
PLAYER_COLOR_GUN = { 255, 255, 255 }
PLAYER_RADIUS = 15
PLAYER_MOVE_FORCE = 60000
PLAYER_DASH_IMPULSE = 100
PLAYER_DASH_WAIT = 0.25
PLAYER_FIRE_WAIT = 0.5

ENERGY_COLOR = { 46, 204, 113 }
ENERGY_RADIUS = 5;
ENERGY_COST = 2;
ENERGY_BONUS = 50;
ENERGY_SPAWN_DELAY = 8;

SPIDER_COLOR = { 192, 57, 43 }
SPIDER_RADIUS = 10;
SPIDER_MOVE_FORCE = 4000
SPIDER_SPAWN_DELAY = 2;

BULLET_COLOR = { 241, 196, 15 }
BULLET_RADIUS = 2;
BULLET_FIRE_IMPULSE = 8

WALL_COLOR = { 46, 204, 113 }
WALL_THICKNESS = 5

ROOM_COLOR = { 44, 62, 80 }

local game
function love.load()
  print('love.load')
  math.randomseed(os.time())
  game = require('game'):new()

  love.mouse.setGrabbed(true)
  love.mouse.setVisible(false)
end

function love.mousepressed(x, y, button)
  if button == 'l' then
    game.player.must_fire = true
  end

  if button == 'r' then
    game.player.must_dash = true
  end
end

function love.update(dt)
  if love.keyboard.isDown('escape') then love.event.quit() end
  game:update(dt)
end

function love.draw()
  game:draw()
end
