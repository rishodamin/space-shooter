local love = require("love")
local Player = require("objects/Player")
local Game = require("states/Game")

math.randomseed(os.time())
love.graphics.setBackgroundColor(0.08, 0.09, 0.07)

function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0

    local show_debug = false
    _G.player = Player(show_debug)
    _G.game = Game()
    game:startNewGame(player)
end

function love.keypressed(key)
    if game.state.running then
        if key == "lshift" or key == "rshift" then
            _G.player.thrusting = true
            player:resetFlame()
        end

        if key == "space" then
            player:shootLaser()
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
    if key == "lshift" or key == "rshift" then
        _G.player.thrusting = false
        player:resetFlame()
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    if button == 1 then
        if game.state.running then
            player:shootLaser()
        end
    end
    
end

function love.update(dt)
    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()

        for ast_index, asteroid in pairs(asteroids) do
            asteroid:move(dt)
        end
    end
    
end
  
function love.draw()
    if game.state.running or game.state.paused then
        player:draw(game.state.paused)

        for _, asteroid in pairs(asteroids) do
            asteroid:draw(game.state.paused)
        end

        game:draw(game.state.paused)
    end
    

    love.graphics.setColor(1, 1, 1, 1)
   -- love.graphics.print(love.timer.getFPS(), 10, 10)
end
