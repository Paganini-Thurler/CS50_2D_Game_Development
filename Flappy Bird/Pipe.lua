--[[
   The Pipe is the object that the bird controlled by the player must avoid.
]]

Pipe = class{}

-- Pipe image
local PIPE_SPRITE = love.graphics.newImage("images/pipes.png")
-- Pipe scroll speed
local PIPE_SCROLL = -60


function Pipe:init()
    -- Creates the pipe at the edge of the screen
    self.x = VIRTUAL_WIDTH
    -- Sets the y to a random value halfway bellow the screen
    self.y = math.random(VIRTUAL_HEIGHT / 2, VIRTUAL_HEIGHT - 10)
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
    self.x = self.x + PIPE_SCROLL * dt
end

-- Draws the sprites each frame by its new x coordinate
function Pipe:render()
    love.graphics.draw(PIPE_SPRITE, self.pipeSprites[1], self.x, self.y)
end