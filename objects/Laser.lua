local love = require("love")

function Laser(x, y, angle)
    local LASER_SPEED = 500 -- laser speed in pixel/second
    local EXPLOAD_DUR = 0.2
   
    return {
        x = x,
        y = y,
        x_vel = LASER_SPEED * math.cos(angle) / love.timer.getFPS(),
        y_vel = -LASER_SPEED * math.sin(angle) / love.timer.getFPS(),
        distance = 0, -- distance traveled
        exploading = 0,
        expload_time = 0,

        draw = function (self, faded)
            local opacity = 1
            
            if faded then
                opacity = 0.2
            end

            if self.exploading < 1 then
                love.graphics.setColor(1, 1, 1, opacity)
                -- set size of points in px (or dpi, idk)
                love.graphics.setPointSize(3)
                -- put point on screen
                love.graphics.points(self.x, self.y)
            else
                love.graphics.setColor(1, 104/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7*1.5)

                love.graphics.setColor(1, 234/255, 0, opacity)
                love.graphics.circle("fill", self.x, self.y, 7)
            end

           
        end,

        move = function (self)
            self.x = self.x + self.x_vel
            self.y = self.y + self.y_vel

            if self.expload_time > 0 then
                self.exploading = 1
            end

            -- if the lasers go off screen, bring them back
            if self.x < 0 then
                self.x = love.graphics.getWidth()
            elseif self.x > love.graphics.getWidth() then
                self.x = 0
            end

            if self.y < 0 then
                self.y = love.graphics.getHeight()
            elseif self.y > love.graphics.getHeight() then
                self.y = 0
            end

            -- increase the distance traveled
            self.distance = self.distance + math.sqrt((self.x_vel ^ 2) + (self.y_vel ^ 2))            
        end,

        expload = function (self)
            self.expload_time = math.ceil(EXPLOAD_DUR*(love.timer.getFPS()/100))
         if self.expload_time> EXPLOAD_DUR then
                self.exploading = 2
            end
        end
    }
end

return Laser