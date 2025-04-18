local love = require("love")
local laser = require("objects.Laser")

function Player(isDebug)
    local SHIP_SIZE = 30
    local VIEW_SNGLE = math.rad(90)
    local LASER_DISTANCE = 0.55
    local MAX_LASERS = 6

    debug = debug or false
    return {
        x = love.graphics.getWidth() / 2,
        y = love.graphics.getHeight() / 2,
        radius = SHIP_SIZE / 2,
        angle = VIEW_SNGLE,
        rotation = 0,
        lasers = {},
        thrusting = false,
        thrust = {
            x = 0,
            y = 0,
            speed = 5,
            big_flame = false,
            flame = 2.0
        },

        drawFlameThrust = function (self, fillType, color)
            love.graphics.setColor(color)
            love.graphics.polygon(
                fillType,
                self.x - self.radius*(2/3*math.cos(self.angle)+0.5*math.sin(self.angle)),
                self.y + self.radius*(2/3*math.sin(self.angle)-0.5*math.cos(self.angle)),
                self.x - self.radius*self.thrust.flame*math.cos(self.angle),
                self.y + self.radius*self.thrust.flame*math.sin(self.angle),
                self.x - self.radius*(2/3*math.cos(self.angle)-0.5*math.sin(self.angle)),
                self.y + self.radius*(2/3*math.sin(self.angle)+0.5*math.cos(self.angle))
            )
        end,

        shootLaser = function (self)
            if #self.lasers < MAX_LASERS then
                table.insert(self.lasers, Laser(
                    self.x,
                    self.y,
                    self.angle
                ))
            end
           
        end,

        destroyLaser = function (self, index)
            table.remove(self.lasers, index)
        end,

        resetFlame = function (self)
            self.thrust.flame = 2
            self.thrust.big_flame = false
        end,

         

        draw = function (self, faded)
            local opacity = (MAX_LASERS-#self.lasers+1)/(#self.lasers)

            if faded then
                opacity = 0.2
            end

            if self.thrust.flame<1 then
                self.resetFlame(self)
            end
            
            if not self.thrust.big_flame then
                
                if self.thrusting then
                    self.thrust.flame = self.thrust.flame -1/love.timer.getFPS()
                    if self.thrust.flame < 1.5 then
                        self.thrust.big_flame = true
                    end
                else
                    self.thrust.flame = self.thrust.flame -0.005
                    --print(self.thrust.flame)
                    if self.thrust.flame < 0.1 then
                        self.thrust.big_flame = true
                    end
                end

                
            else
                
                if self.thrusting then
                    self.thrust.flame = self.thrust.flame +1/love.timer.getFPS()
                    if self.thrust.flame > 2.5 then
                        self.thrust.big_flame = false
                    end
                else
                    self.thrust.flame = self.thrust.flame +0.005
                 --   print(self.thrust.flame)
                    if self.thrust.flame > 0.2 then
                        self.thrust.big_flame = false
                    end
                end

               
            end

            if not faded then
                self:drawFlameThrust("fill", {1, 102/255, 25/255})
                self:drawFlameThrust("line", {1, 0.16, 0})
            end
           


            love.graphics.setColor(0.1, 0.6, 0.65, opacity)

            -- player
            love.graphics.polygon(
                "fill",
                self.x + ((4/3)*self.radius) * math.cos(self.angle),
                self.y - ((4/3)*self.radius) * math.sin(self.angle),
                self.x - self.radius * (2/3*math.cos(self.angle)+math.sin(self.angle)),
                self.y + self.radius * (2/3*math.sin(self.angle)-math.cos(self.angle)),
                self.x - self.radius * (2/3*math.cos(self.angle)-math.sin(self.angle)),
                self.y + self.radius * (2/3*math.sin(self.angle)+math.cos(self.angle))
            )
            if isDebug then
                love.graphics.setColor(1, 0, 0)
                love.graphics.rectangle("fill", self.x-4, self.y-4, 8, 8)
                love.graphics.circle("line", self.x, self.y, self.radius)
            end

            for _, lsr in pairs(self.lasers) do
                lsr:draw(faded)
            end


        end,
        movePlayer = function (self)
            local FPS = love.timer.getFPS()
            local friction = 0.7

            self.rotation = 360/180*math.pi/FPS

            if love.keyboard.isDown("left") then
                self.angle = self.angle + self.rotation
            end

            if love.keyboard.isDown("right") then
                self.angle = self.angle -  self.rotation
            end
            if self.thrusting then
                self.thrust.x = self.thrust.x + self.thrust.speed * math.cos(self.angle)/FPS
                self.thrust.y = self.thrust.y - self.thrust.speed * math.sin(self.angle)/FPS
            elseif self.thrust.x~=0 or self.thrust.y~=0 then
                self.thrust.x = self.thrust.x - friction*self.thrust.x/FPS
                self.thrust.y = self.thrust.y - friction*self.thrust.y/FPS
            end

            if self.x+self.thrust.x-self.radius<=0 then
                self.x = self.radius
            elseif self.x+self.thrust.x+self.radius>=love.graphics.getWidth() then
                self.x = love.graphics.getWidth()- self.radius
            else
                self.x = self.x+self.thrust.x
            end

            if self.y+self.thrust.y-self.radius<=0 then
                self.y = self.radius
            elseif self.y+self.thrust.y+self.radius>=love.graphics.getHeight() then
                self.y = love.graphics.getHeight()- self.radius
            else
                self.y = self.y+self.thrust.y
            end

            for idx, lsr in pairs(self.lasers) do
                lsr:move()

                if (lsr.distance > LASER_DISTANCE*love.graphics.getWidth()) then
                    self.destroyLaser(self, idx)
                end
            end

            
        end
    }
end

return Player