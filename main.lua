local love = require("love")
local Player = require("Player")


function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0

    local show_debug = false
    _G.player = Player(show_debug)
end

function love.keypressed(key)
    if key == "up" then
        _G.player.thrusting = true
    end
end

function love.keyreleased(key)
    if key == "up" then
        _G.player.thrusting = false
    end
end

function love.update(dt)
    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()

    player:movePlayer()
end

function love.draw()
    player:draw()

    love.graphics.setColor(1, 1, 1, 1)
   -- love.graphics.print(love.timer.getFPS(), 10, 10)
end
