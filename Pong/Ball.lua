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
        self.dx = 100
    else 
        self.dx = -100
    end

   
    self.dy = math.random(-60,60)
end

-- AABB collision
function Ball:collides(paddle)
    -- Check f the left edge of either is farther to the right
    -- than the the right edge of the other
    if self.x >= paddle.x + paddle.width or paddle.x >= self.x + self.width then
        return false
    end

    if self.y >= paddle.y + paddle.height or paddle.y >= self.y + self.height then
        return false
    end 

    return true
end

function Ball:bounces(screenHeight)
    if self.y <= self.height then
        self.y = self.height
        self.dy = -self.dy
    elseif self.y >= screenHeight - self.height then
        self.y = screenHeight - self.height  
        self.dy = -self.dy

    end

end

function Ball:changeDY()
    if ball.dy < 0 then 
        ball.dy = -math.random(10,150)
    else
        ball.dy = math.random(10,150)
    end
end



-- Reset ball position to the default place
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2 
    self.y = VIRTUAL_HEIGHT / 2 -2 
    
    if math.random(2) == 1 then
        self.dx = 100
    else 
        self.dx = -100
    end
    
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

