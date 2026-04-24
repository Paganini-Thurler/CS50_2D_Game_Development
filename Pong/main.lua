-- Imports

--[[
    push is a library that allows us to draw our game at a virtual
    resolution, used to provide a more retro aesthetic
]]

push = require "push"

-- Global variables --

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

PADDLE_SPEED = 200

-- Notes:
-- In Lua code blocks, such as conditionals ends with end


-- A Setup function is a function that prepares the environment  
function love.load() 
    -- Start variables
    player1Score = 0
    player2Score = 0

    paddle1Y = VIRTUAL_HEIGHT/2
    paddle2Y = VIRTUAL_HEIGHT/2

   
    -- Graphical mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Fonts 
    largeFont = love.graphics.newFont("font.ttf", 32)
    smallFont = love.graphics.newFont("font.ttf", 8)


    -- Creates a window 
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
        resizable = false, vsync = true, fullscreen = false
    })

    -- Creates a virtual resolution screen
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = "normal"})

end 

-- Keyboard input
function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

function love.update(dt)
    -- Player 1 input
    if love.keyboard.isDown("w") then 
        paddle1Y = paddle1Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("s") then
        paddle1Y = paddle1Y + PADDLE_SPEED * dt
    end

    -- Player 2 input
     if love.keyboard.isDown("up") then 
        paddle2Y = paddle2Y - PADDLE_SPEED * dt
    elseif love.keyboard.isDown("down") then
        paddle2Y = paddle2Y + PADDLE_SPEED * dt
    end

end

-- The drawing function
function love.draw()
    -- Starts the virtual screen
    push.start()
    -- Draws a solid color, values are normalized because GPUs use floats
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    
    -- Text
    -- Sets the font
    love.graphics.setFont(largeFont)
    -- Draws text in the window, the -6 is to account for the font height
    --love.graphics.printf("Hello!", 0, VIRTUAL_HEIGHT / 2 - 16, VIRTUAL_WIDTH, "center")
    
    -- Graphics

    -- Score
    love.graphics.print(tostring(player1Score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 2 - 80)
    love.graphics.print(tostring(player2Score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 2 - 80)
    
    -- Paddle
    love.graphics.rectangle("fill", 20, paddle1Y, 5, 20)
    -- Paddle 2
    love.graphics.rectangle("fill", VIRTUAL_WIDTH - 20, paddle2Y,  5, 20)
    -- Ball
    love.graphics.rectangle("fill", VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    --End the virtual screen
    push.finish()
end