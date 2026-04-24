--[[
   Pong was one of the earliest popular video games and it was realeased in November
   29, 1972. This is a remake based on the original and on the CS 50 Game Development
   class. 
]]


-- Imports

-- push is a library that allows the use of a virtual screen
push = require "push"

-- Global variables --

-- Real screen/canvas
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual screen/canvas
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Defines a paddle speed of 200px/s 
PADDLE_SPEED = 200

-- Notes:
-- In Lua code blocks, such as conditionals ends with end


-- A Setup function is a function that prepares the environment.
function love.load() 

    -- Seed for the random number generator
    -- Created a unique seed based on UNIX time
    math.randomseed(os.time())

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
   
    -- Player scores 
    player1Score = 0
    player2Score = 0

    -- Paddles initial Y position
    paddle1Y = VIRTUAL_HEIGHT/2 - 10
    paddle2Y = VIRTUAL_HEIGHT/2 - 10

    -- Ball initial position
    ballX = VIRTUAL_WIDTH / 2 - 2
    ballY = VIRTUAL_HEIGHT / 2 -2 

    -- Ball goes left or right
    if math.random(2) == 1 then
        ballDX = 100
    else 
        ballDX = -100
    end

    -- Ball y position ranging from -60 - 60
    ballDY = math.random(-60, 60)

    -- Initialize the game state
    gameState = "start"

end 

-- Keyboard input
function love.keypressed(key)

    -- Quits the game
    if key == "escape" then
        love.event.quit()
    end

    if key == "enter" or key == "return" then
        if gameState == "start" then
            gameState = "play"
        else 
            gameState = "start"

            -- Ball initial position
            ballX = VIRTUAL_WIDTH / 2 - 2
            ballY = VIRTUAL_HEIGHT / 2 -2 

        -- Ball goes left or right
            if math.random(2) == 1 then
                ballDX = 100
            else 
                ballDX = -100
            end

            -- Ball y position ranging from -60 - 60
            ballDY = math.random(-60, 60)
        end

    end

end

-- The update function is a function that update all the variables before
-- they can be used to update the graphics.
function love.update(dt)

    -- Player 1 input
    if love.keyboard.isDown("w") then 
        paddle1Y = math.max(0, paddle1Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("s") then
        paddle1Y = math.min(VIRTUAL_HEIGHT - 20,  paddle1Y + PADDLE_SPEED * dt)
    end

    -- Player 2 input
     if love.keyboard.isDown("up") then 
        paddle2Y = math.max(0, paddle2Y - PADDLE_SPEED * dt)
    elseif love.keyboard.isDown("down") then
        paddle2Y = math.min(VIRTUAL_HEIGHT - 20 ,paddle2Y + PADDLE_SPEED * dt)
    end

    -- Ball position update
    if gameState == "play" then
        ballX = ballX + ballDX * dt
        ballY = ballY + ballDY * dt
    end
end

-- After the variables are updated by the user input, they are used to
-- update the drawing on the screen. 
function love.draw()

    -- Starts the virtual screen
    push.start()
    -- Draws a solid color, values are normalized because GPUs use floats
    love.graphics.clear(40/255, 45/255, 52/255, 1)
    
    -- Texts
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
    love.graphics.rectangle("fill", ballX, ballY, 4, 4)

    --End the virtual screen
    push.finish()
end