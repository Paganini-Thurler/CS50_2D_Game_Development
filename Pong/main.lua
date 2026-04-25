--[[
   Pong was one of the earliest popular video games and it was realeased in November
   29, 1972 by Atari. This is a remake based on the original and on the CS 50 Game Development
   class. 
]]

-- Imports
-- push is a library that allows the use of a virtual screen
push = require "push"

-- class is a library that helps with Object Oriented Programming in lua
class = require "class"


-- The OOP Classes 
require "Paddle"
require "Ball"

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

    -- Screen title 
    love.window.setTitle("Pong")

    -- Fonts 
    largeFont = love.graphics.newFont("font.ttf", 32)
    smallFont = love.graphics.newFont("font.ttf", 8)

    -- Initilizes a window 
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
        resizable = false, 
        vsync = true, 
        fullscreen = false
    })

    -- Initilizes a virtual resolution screen
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = "normal"})
   
    -- Player scores 
    player1Score = 0
    player2Score = 0

    -- Paddles initial Y position
    player1 = Paddle(10, VIRTUAL_HEIGHT/2 - 10, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10 , VIRTUAL_HEIGHT/2 - 10, 5, 20)

    -- Ball initial position
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

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
            -- Reset ball
            ball:reset()
        end
    end
end

-- The update function is a function that update all the variables before
-- they can be used to update the graphics.
function love.update(dt)
    -- Player 1 movement
    if love.keyboard.isDown("w") then 
        player1.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("s") then
        player1.dy = PADDLE_SPEED
    else
        player1.dy = 0
    end

    -- Player 2 input
     if love.keyboard.isDown("up") then 
        player2.dy = -PADDLE_SPEED
    elseif love.keyboard.isDown("down") then
        player2.dy = PADDLE_SPEED
    else 
        player2.dy = 0
    end

    -- Ball position update
    if gameState == "play" then

        if ball:collides(player1) then
            -- Adding 5 or an ammount helps the ball not to get stuck on the left
            ball.x = ball.x + 5
            ball.dx = -ball.dx * 1.1

            ball:changeDY()
        end

        if ball:collides(player2) then
            -- Subtracting 5 or an ammount helps the ball not to get stuck on the right
            ball.x = ball.x - 5
            ball.dx = -ball.dx * 1.1
            ball:changeDY()
        end

        ball:bounces(VIRTUAL_HEIGHT)

        ball:update(dt)

    end

    player1:update(dt)
    player2:update(dt)
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
    
    -- Paddle 1
    player1:render(dt)
    -- Paddle 2
    player2:render(dt)
    -- Ball
   ball:render(dt)

   displayFPS()

    --End the virtual screen
    push.finish()
end

-- Draws the FPS on the left corner of the screen
function displayFPS()
    love.graphics.setFont(smallFont)
    -- The RGBA color is Green
    love.graphics.setColor(0,1,0,1)
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end
    