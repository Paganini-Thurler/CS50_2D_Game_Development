--[[
    Score state is the state the game is after the player collides with a pipe
    in the Play State.
    It shows the number of pipes that the player cleared as the score
]]

ScoreState = class{__includes = BaseState}

--Constructor
-- It requires the score from the PlayState class
function ScoreState:init(parameters)
    self.score = parameters.score
end

-- If the player presses enter/space it will trigger the PlayState
function ScoreState:update(dt)
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("space") then
        gameStateMachine:change("play")
    end
end

function ScoreState:render()
    -- Render the score in the middle of the screen
    love.graphics.setFont(flappyFont)
    love.graphics.printf("Try again! ", 0, 64, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf("Score: " .. toString(self.score), 0, 100, VIRTUAL_WIDTH, "center")

    love.graphics.printf("Press Enter to try again!", 0, 160, VIRTUAL_WIDTH, "center")
end