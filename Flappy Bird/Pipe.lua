--[[
   The Pipe is the object that the bird controlled by the player must avoid.
]]

Pipe = class{}
-- Pipe dimension in pixels
PIPE_HEIGHT = 160
PIPE_WIDTH = 32

-- Pipe image
local PIPE_SPRITE = love.graphics.newImage("images/pipes.png")
-- Pipe scroll speed
PIPE_SPEED = 60

--Constructor
function Pipe:init(orientation,pipeYPosition)
    -- Sets the pipe orientation
    self.orientation = orientation
    -- Creates the pipe at the edge of the screen
    self.x = VIRTUAL_WIDTH
    -- Sets the y to a random value halfway bellow the screen
    self.y = pipeYPosition
    -- There are four pipes in the image hence the division by 4
    self.width = PIPE_SPRITE:getWidth()/4
    self.height = PIPE_SPRITE:getHeight()

    -- Separate the different pipes by creating a quad
    -- Pipe sprites table
    self.pipeSprites = {}

    for i = 0, 3 do
        -- love.graphics.newQuad(x, y, width, height, texture(image))
        table.insert(self.pipeSprites, love.graphics.newQuad(
            i * self.width, 0, self.width, self.height, PIPE_SPRITE:getDimensions()
        ))
    end


end

-- Updates the pipe x position by the delta time
function Pipe:update(dt)
    self.x = self.x + PIPE_SPEED * dt
end

-- Draws the sprites each frame by its new x coordinate
function Pipe:render()
    -- In the course they use a hack to create a ternary expression
    -- I'm not a fan of ternaries when calling a method because its 
    -- easy to lost track of whats happening. 
    -- (self.orientation == 'top' and self.y + PIPE_HEIGHT or self.y)
    -- The objective is to rotate the image depending on the orietation

    -- If flipY is 1 it will not be flipped on the y axis
    local renderY = self.y
    local flipY = 1

    if self.orientation == "top" then
        renderY = self.y + PIPE_HEIGHT
        -- Inverts the sprite 
        flipY = -1
    end

    -- love.graphics.draw( drawable, x, y, r, sx, sy, ox, oy, kx, ky )
    love.graphics.draw(PIPE_SPRITE, self.pipeSprites[1], self.x, renderY, 0, 1, flipY)
end