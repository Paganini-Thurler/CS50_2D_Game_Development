--[[
    The Paddle class

    Represents a paddle as a rectangle, it can move up and down on the y axis
    and when it collides with a ball it sends it back in the oposite direction

]]

Paddle = class{}

-- Paddle constructor
function Paddle:init(x, y, width, height, paddleSpeed)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.paddleSpeed = paddleSpeed
    self.dy = 0
end

-- Updates the paddle based on delta time to make all the calculations independent 
-- of refresh rates or faster CPUS/GPUS
function Paddle:update(dt)
    -- Clamps the paddle's y postion to the screen
    if self.dy < 0 then
        self.y = math.max(0, self.y + self.dy * dt)
    else
        self.y = math.min(VIRTUAL_HEIGHT - self.height, self.y + self.dy * dt)
    end
end

-- Draws the paddle to the screen based on delta time to make all the calculations independent 
-- of refresh rates or faster CPUS/GPUS
function Paddle:render(dt)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

-- Paddle movement
function Paddle:up()
    self.dy = -self.paddleSpeed
end

function Paddle:down()
    self.dy = self.paddleSpeed
end

function Paddle:stop()
    self.dy = 0
end

   
return Paddle