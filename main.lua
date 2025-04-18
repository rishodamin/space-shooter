local love = require("love")
local Player = require("objects/Player")
local Game = require("states/Game")
require("globals")

math.randomseed(os.time())
love.graphics.setBackgroundColor(0.08, 0.09, 0.07)

function love.load()
    love.mouse.setVisible(false)
    _G.mouse_x, _G.mouse_y = 0, 0
    _G.counter = 0

    _G.player = Player()
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
    if counter>1 then
        _G.counter = 0
        game:addAsteroid()
    end

    _G.mouse_x, _G.mouse_y = love.mouse.getPosition()

    if game.state.running then
        player:movePlayer()

        for ast_index, asteroid in pairs(asteroids) do
            if not player.exploading then
                    if CalculateDistance(player.x, player.y, asteroid.x, asteroid.y) < asteroid.radius then
                        player:expload()
                        DestroyAst = true
                    end
            else
                player.expload_time = player.expload_time - 1
            end

            for _, lsr in pairs(player.lasers) do
                if CalculateDistance(lsr.x, lsr.y, asteroid.x, asteroid.y) < asteroid.radius then
                    lsr:expload()
                    asteroid:destroy(asteroids, ast_index, game)
                end
            end

            if DestroyAst then
                DestroyAst = false
                asteroid:destroy(asteroids, ast_index, game)
            end
            asteroid:move(dt)
        end
    end
    
    _G.counter = counter+0.003
    
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
