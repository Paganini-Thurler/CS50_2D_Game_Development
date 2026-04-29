Bird = class{}

function Bird:init()
    -- Load the bird sprite
    self.sprite = love.graphics.newImage("images/bird.png")
    
    -- Since there are 4 sprites in one line, divide the total width by 4
    self.width = self.sprite:getWidth() / 4
    self.height = self.sprite:getHeight()

    -- Position it at the center
    self.x = VIRTUAL_WIDTH / 2 - (self.width / 2)
    self.y = VIRTUAL_HEIGHT / 2 - (self.height / 2)

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

function Bird:render()
    -- draw(texture, quad, x, y)
    love.graphics.draw(self.sprite, self.frames[self.currentFrame], self.x, self.y)
end