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

-- Game variables --

-- Real screen/canvas
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720
-- Virtual screen/canvas
VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243
-- Defines a paddle speed of 200px/s 
PADDLE_SPEED = 200
-- Defines the points for a victory
VICTORY_SCORE = 5

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

    -- Paddles initial position
    player1 = Paddle(10, VIRTUAL_HEIGHT/2 - 10, 5, 20, PADDLE_SPEED)
    player2 = Paddle(VIRTUAL_WIDTH - 10 , VIRTUAL_HEIGHT/2 - 10, 5, 20, PADDLE_SPEED)
    
    -- Sets who will serve 
    servingPlayer = 1
    
    -- who wins
    winner = 0

    -- Ball initial position
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)

    -- set up our sound effects; later, we can just index this table and
    -- call each entry's `play` method
    sounds = {
        ["paddle_hit"] = love.audio.newSource('sounds/paddle_hit.wav', 'static'),
        ["score"] = love.audio.newSource('sounds/score.wav', 'static'),
        ["wall_hit"] = love.audio.newSource('sounds/wall_hit.wav', 'static')
    }

    -- Set initial gameState
    setGameState("start")
end 


-- CORE LOVE LOOPS


-- Keyboard input
function love.keypressed(key) 
    -- Confirm choices by pressing Enter
    pressEnter(key)
    -- Quits the game
    quitGame(key)
end

-- The update function is a function that update all the variables before
-- they can be used to update the graphics based on delta time to make all
-- the calculations independent of refresh rates or faster CPUS/GPUS
function love.update(dt)
    --  Updates the player position after the input
    playerMovement(player1, "w", "s")
    playerMovement(player2, "up", "down")
   
    -- Updates the ball
    ballUpdate(dt)

    -- Update player 1 paddle
    player1:update(dt)
    -- Update player 2 paddle
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

    love.graphics.setFont(smallFont)
    if gameState == "start" then
        love.graphics.printf("Press Enter to Play",0, VIRTUAL_HEIGHT / 2 - 4, VIRTUAL_WIDTH, "center")
    elseif gameState == "serving" then
        love.graphics.printf("Player " .. tostring(servingPlayer) .. " is serving" ,0, VIRTUAL_HEIGHT / 2 + 4, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to Continue",0, VIRTUAL_HEIGHT / 2 - 4, VIRTUAL_WIDTH, "center")
    elseif gameState == "end" then
        love.graphics.printf("Player " ..tostring(winner) .. " wins",0, VIRTUAL_HEIGHT / 2 + 4, VIRTUAL_WIDTH, "center")
        love.graphics.printf("Press Enter to Continue",0, VIRTUAL_HEIGHT / 2 - 4, VIRTUAL_WIDTH, "center")
    end

    if gameState == "play" then
        ball:render()
    end

    -- Paddle 1
    player1:render()
    -- Paddle 2
    player2:render()
    
    displayFPS()

    --End the virtual screen
    push.finish()
end


-- HELPER FUNCTIONS


function setGameState(state)
    gameState = state
end

function resetGame()
    player1Score = 0
    player2Score = 0
    -- Reset ball position to prevent immediate scoring on restart
    ball:reset(servingPlayer) 
    setGameState("start")
end 

-- Comfirms action in the game
function pressEnter(key)
    if key == "enter" or key == "return" then
        if gameState == "start" then
            setGameState("serving")
        elseif gameState == "serving" then
            setGameState("play")
        elseif gameState == "end" then
            resetGame()
        end
    end
end

-- Update player paddle movement based on input
function playerMovement(player, upKey, downKey)
    -- Player movement
    if love.keyboard.isDown(upKey) then 
        player:up()
    elseif love.keyboard.isDown(downKey) then
        player:down()
    else
        player:stop()
    end
end 

-- Checks all the ball actions
function ballUpdate(dt)
     -- Ball position update
    if gameState == "play" then
       -- Checks and sets who will serve
       whoServes()
       -- Check the ball collision with a player paddle
       ballPlayerCollision()
        
       -- If theres a bounce it will account it
        if ball:bounces(VIRTUAL_HEIGHT) then
            sounds["wall_hit"]:play()
        end  
        
        ball:update(dt)
    end
end 

-- Checks who will serve the ball 
function whoServes()
    local playerWhoScored = ball:scores(VIRTUAL_WIDTH) 
    if playerWhoScored > 0 then

        sounds["score"]:play()
        if playerWhoScored == 1 then
            player1Score = player1Score + 1
            servingPlayer = 2
        else
            player2Score = player2Score + 1
            servingPlayer = 1
        end

        -- Check if the match is over
        if player1Score == VICTORY_SCORE then
            winner = 1
            setGameState("end")
        elseif player2Score == VICTORY_SCORE then
            winner = 2
            setGameState("end")
        else
            ball:reset(servingPlayer)
            setGameState("serving")
        end
    end
end

-- Checks player-ball collision
function ballPlayerCollision()
    if ball:collides(player1) then
        sounds['paddle_hit']:play()
        -- Inverts the x direction from the player 1 
        ball:changeDX(1)
        -- Randomizes the ball dy 
        ball:changeDY()
    end

    if ball:collides(player2) then
        sounds['paddle_hit']:play()
        -- Inverts the x direction from the player 2 
        ball:changeDX(2)
        -- Randomizes the ball dy 
        ball:changeDY()
    end
end

function quitGame(key)
     -- Quits the game
    if key == "escape" then
        love.event.quit()
    end
end 

-- Draws the FPS on the left corner of the screen
function displayFPS()
    love.graphics.setFont(smallFont)
    -- The RGBA color is Green
    love.graphics.setColor(0,1,0,1)
    -- .. operator for string concatenation
    love.graphics.print("FPS: " .. tostring(love.timer.getFPS()), 10, 10)
    love.graphics.setColor(1,1,1,1)
end