--[[
    The Ball class

    Represents a ball as a rectangle, it will bounce back and forth between the 
    paddles  until it hits one the backfields awarding a point to the other player.

]]

Ball = class{}

-- Ball constructor
function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- Sets the ball x and y directions based on random number generator
    if math.random(2) == 1 then
        dx = 100
    else 
        dx = -100
    end

    self.dx = dx 
    self.dy = math.random(-60,60)
end

-- Reset ball position to the default place
function Ball:reset()
    self.x = VIRTUAL_WIDHT / 2 - 2 
    self.y = VIRTUAL_HEIGHT / 2 -2 
    
    if math.random(2) == 1 then
        dx = 100
    else 
        dx = -100
    end

    self.dx = dx 
    self.dy = math.random(-60,60) 
end

-- Updates the ball based on the delta time
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Draws the ball representation on the screem
function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Ball

