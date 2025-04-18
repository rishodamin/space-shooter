local love = require("love")
local Player = require("objects/Player")
local Game = require("states/Game")


function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0

    local show_debug = false
    _G.player = Player(show_debug)
    _G.game = Game()
end

function love.keypressed(key)
    if game.state.running then
        if key == "up" then
            _G.player.thrusting = true
        end

        if key == "escape" then
            game:changeGameState("paused")
        end
    elseif game.state.paused then
        if key == "escape" then
            game:changeGameState("running")
        end
    end
    
end

function love.keyreleased(key)
    if key == "up" then
        _G.player.thrusting = false
    end
end

function love.update(dt)
    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()
    end
    
end
  
function love.draw()
    if game.state.running or game.state.paused then
        player:draw()
        game:draw(game.state.paused)
    end
    

    love.graphics.setColor(1, 1, 1, 1)
   -- love.graphics.print(love.timer.getFPS(), 10, 10)
end
