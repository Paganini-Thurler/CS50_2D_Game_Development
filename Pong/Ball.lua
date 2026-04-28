--[[
    The Ball class

    Represents a ball as a rectangle, it will bounce back and forth between the 
    paddles  until it hits one the backfields awarding a point to the other player.

]]

Ball = class{}

-- Ball constructor
function Ball:init(x, y, width, height)
    -- Fields, this reminds me of how JS do the same
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    
    -- Sets the ball x 

    self.dx = 100
   -- Generates a randon y direction from a range
    self.dy = math.random(-60,60)
end

-- Axis Aligned Bouding Box Collision (AABB)
-- This algorithm checks if there are gaps in the x and y edges 
-- to determine if there is an object collision

function Ball:collides(paddle)
    -- Lets break down all the conditions the AABB algorithm
    -- The ball has a x postion if its greater than the paddle x position plus its width
    -- it means that there is a gap between the ball and the paddle.
    -- The paddle has a x postion if its greater or equal to the ball x position plus its width
    -- it means that there is a gap between the paddle and the ball.
    -- If any of those conditions are true, there is no collition.
    if self.x >= paddle.x + paddle.width or paddle.x >= self.x + self.width then
        return false
    end

    -- The same logic for the x axis applies here.
    if self.y >= paddle.y + paddle.height or paddle.y >= self.y + self.height then
        return false
    end 

    return true
end

function Ball:scores(screenWidth)
    if self.x > screenWidth - 4 then
        return 1
    elseif self.x < 4 then
        return 2
    end
    return 0
end

-- This bounces the ball on the top and bottom edges of the field
function Ball:bounces(screenHeight)
    if self.y <= self.height then
        -- Sets y position to prevent a bug that "glues" the ball on the edge
        self.y = self.height
        -- Inverts the y direction creating a bounce
        self.dy = -self.dy
        return true
    elseif self.y >= screenHeight - self.height then
        -- Sets y position to prevent a bug that "glues" the ball on the edge
        self.y = screenHeight - self.height  
        -- Inverts the y direction creating a bounce
        self.dy = -self.dy
        return true
    end
    return false
end

-- This method is called when a paddle hits a ball, it randomizes the ball angle
-- In more sophisticated Pong implementations is possible to imprint inertia in the 
-- ball. This implementation creates variarity by changing the paddle response
function Ball:changeDY()
    if ball.dy < 0 then 
        ball.dy = -math.random(10,150)
    else
        ball.dy = math.random(10,150)
    end
end

function Ball:changeDX(playerNumber)
    if playerNumber == 1 then
        -- Adding 5 or an ammount helps the ball not to get stuck on the left
        ball.x = ball.x + 5
    else
        ball.x = ball.x - 5
    end
    -- Increments the ball velocity in pixels per second by 10%
    ball.dx = -ball.dx * 1.1
end 

-- Reset ball position to the default place
function Ball:reset(servingPlayer)
    self.x = VIRTUAL_WIDTH / 2 - 2 
    self.y = VIRTUAL_HEIGHT / 2 -2 
    
    if servingPlayer == 1 then
        self.dx = 100
    else 
        self.dx = -100
    end

    self.dy = math.random(-60,60) 
end

-- Updates the ball based on the delta time to make all the calculations independent 
-- of refresh rates or faster CPUS/GPUS
function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt
end

-- Draws the ball representation on the screem
function Ball:render()
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

return Ball