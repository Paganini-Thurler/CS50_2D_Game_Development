--[[
    The Bird has all the attributes, sprites, methods that model its behaviour
]]


Bird = class{}

-- Sets the gravity that will pull the bird
local GRAVITY = 800

-- Constructor
function Bird:init()
    -- Load the bird sprite
    self.sprite = love.graphics.newImage("images/bird.png")
    
    -- Since there are 4 sprites in one line, divide the total width by 4
    self.width = self.sprite:getWidth() / 4
    self.height = self.sprite:getHeight()

    -- Position it at the center
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

    -- Sets the dy
    self.dy = 0 

    -- Create "Quads" for each frame
    self.frames = {}
    for i = 0, 3 do
        -- love.graphics.newQuad(x, y, width, height, reference_dimensions)
        table.insert(self.frames, love.graphics.newQuad(
            i * self.width, 0, self.width, self.height, self.sprite:getDimensions()
        ))
    end

    -- Which frame to show (1 to 4)
    self.currentFrame = 1
end 

function Bird:isColliding(pipe)
    if self.x + 2 >= pipe.x + PIPE_WIDTH or pipe.x >= self.x + self.width - 2 then
        return false
    end

    -- Gets the real y values because the top pipe on the pair is shifted

    local pipeTopY = pipe.y
    if pipe.orientation == "top" then
        -- Unshifts the y coordinates of the inverted pipe
        pipeTopY = pipe.y - PIPE_HEIGHT
    end

    -- The values +-4 and +- is a way to shrink the player collision box
    -- This helps the game balance because it will not trigger collisions 
    -- when the player barelly collides with an object
    if self.y + 4 >= pipe.y + PIPE_HEIGHT or pipeTopY >= self.y + self.height - 4 then
        return false
    end

    return true
end

-- Updates the bird y position according to the gravity and input
function Bird:update(dt)
    -- Applies gravity to velocity based on dt
    self.dy = self.dy + GRAVITY * dt

    -- Jumps if the spacebar was pressed
    if love.keyboard.wasPressed("space") then
        self.dy = -300
    end

    -- Applies the current dy to the y position
    self.y = self.y + self.dy * dt
end 

-- Renders the bird sprite
function Bird:render()
    -- draw(texture, quad, x, y)
    love.graphics.draw(self.sprite, self.frames[self.currentFrame], self.x, self.y)
end