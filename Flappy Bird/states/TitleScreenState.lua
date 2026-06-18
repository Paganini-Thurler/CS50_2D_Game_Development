--[[
    Title Screen State class
]]

-- Inherits the BaseState
TitleScreenState = class{__includes = BaseState}

function TitleScreenState:update(dt)
    -- The trigger to play is enter or space
    if love.keyboard.wasPressed("enter") or love.keyboard.wasPressed("space") then
        isScrolling = true
        gameStateMachine:change("play")
    end
end 

function TitleScreenState:render()
    -- Defines the font name not the file.tff
    love.graphics.setFont(flappyFont)
    -- Defines 
    love.graphics.printf("Flappy Bird", 0, 64, VIRTUAL_WIDTH, "center")

    love.graphics.setFont(mediumFont)
    love.graphics.printf("Press ENTER", 0, 100, VIRTUAL_WIDTH, "center")
end 