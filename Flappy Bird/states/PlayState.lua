--[[
    Play State class this is the state that plays the game after the title screen state
]]

-- Inherits the BaseState
PlayState = class{__includes = BaseState}

-- Constants relevant to PlayState
PIPE_SPEED = 60
PIPE_HEIGHT = 160
PIPE_WIDTH = 32

BIRD_WIDTH = 16
BIRD_HEIGHT = 16


function PlayState:init()
    -- Initalizes all the classes for the game play, this logic was 
    -- previously on the main.lua now its encapsulated on its own state
    -- Bird object
    self.bird = Bird()
    -- Pipe pair table
    self.pipePairs = {}
    self.spawnTimer = 0
    self.lastPipeYPosition = -PIPE_HEIGHT + math.random(80) + 20
    self.score = 0 

end

function PlayState:update(dt)
    -- self. (dot) is for variables (properties, data, tables).
    -- self: (colon) is for functions 
    -- Updates the spawnTimer
    self:updateTimer(dt)
    -- Updates pipe pair position
    self:updatePipes(dt)
    -- Checks collisions on the pipe pair
    self:checkCollisions()
    self:updateScore()
    -- Updates the bird object
    self.bird:update(dt)
end

function PlayState:render()
    self:drawPipes()
    self:drawScore()
    self.bird:render()
end

-- Implements the logic to spawn pipes after a time
function PlayState:updateTimer(dt)
    -- Adds a delta time to the spawn timer 
    self.spawnTimer = self.spawnTimer + dt

    if self.spawnTimer > 2 then
        -- Calls the spawnPipe method
        self:spawnPipes()
        -- Resets the timer
        self.spawnTimer = 0
    end
end 

function PlayState:spawnPipes()
    -- The code bellow is just to spawn a pipe with some rules.
    -- No pipe higher than 10 pixels bellow the top edge of the screen
    -- No pipe lower than a gap length of 90 pixels  from the bottom
    local yPosition = math.max(-PIPE_HEIGHT + 10, math.min(self.lastPipeYPosition + math.random(-20,20),
    VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
    self.lastPipeYPosition = yPosition
    table.insert(self.pipePairs, Pair(yPosition))
end

function PlayState:updatePipes(dt)
    -- Updates every pipe in the scene  
    for key, pair in pairs(self.pipePairs) do
        pair:update(dt)
    end

    -- Removes the flagged pipes
    for key, pair in pairs(self.pipePairs) do 
        -- Removes pipes that are not visible on the screen
        if pair.remove then
            table.remove(self.pipePairs, key)
        end
    end
end

function PlayState:drawPipes()
    for key, pair in pairs(self.pipePairs) do
        pair:render()
    end
end

function PlayState:drawScore()
    love.graphics.setFont(flappyFont)
    love.graphics.print("Score: " .. tostring(self.score), 8,8)
end

function PlayState:checkCollisions()
    -- Checks for collision with the pipes
    -- Nestested loop 
    -- Loop each pipe pair
    for i, pair in pairs(self.pipePairs) do
        -- For each pair loop its pipes
        for j, pipe in pairs(pair.pipes) do
            -- Checks the collision for each pipe up and down
            if self.bird:isColliding(pipe) then
                gameStateMachine:change("score", {score = self.score})
            end
        end
    end
    --Checks collision with the ground
    if self.bird.y > VIRTUAL_HEIGHT - 8 then
        gameStateMachine:change("score", {score = self.score})
    end
end

function PlayState:updateScore()
    for key, pair in pairs(self.pipePairs) do
        if not pair.scored then
            if pair.x + PIPE_WIDTH < self.bird.x then
                self.score = self.score + 1
                pair.scored = true
            end
        end
    end
end
