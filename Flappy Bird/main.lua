--[[
    Flappy Bird is mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.

]]

-- self. (dot) is for variables (properties, data, tables).
-- self: (colon) is for functions 

-- Libraries 
-- Virtual resolution library
push = require "push"

-- class is a library that helps with Object Oriented Programming in lua
class = require "class"

-- Classes
require "Bird"
require "Pipe"
require "Pair"

-- StateMachines
require "StateMachine"
require "states.BaseState"
require "states.PlayState"
require "states.ScoreState"
require "states.TitleScreenState"

-- Screen resolution
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

-- Virtual resolution
-- 512x288 is 16:9 aspect ratio for pixel art games
VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288

-- Images x loop coordinates
local backgroundScroll = 0
local groundScroll = 0

-- The x coordinate from the background that it will return to 0
local BACKGROUND_LOOPING_POINT = 256

-- Images scroll speeds in pixels per second, must be scalled by dt
-- The background will move 4 times slower than the ground creating
-- a parallax effect
local BACKGROUND_SCROLL_SPEED = 15
local GROUND_SCROLL_SPEED = 60

-- Scrolling flag
isScrolling = true

score = 0

-- Setup function initializes all the game variables and modes
function love.load()
    -- nearest-neighbor mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Background and ground
    background = love.graphics.newImage("images/background.png")
    ground = love.graphics.newImage("images/ground.png")

    -- Randon Number Generator seed based on OS time
    math.randomseed(os.time())

    --Window
    -- Window title
    love.window.setTitle("Flappy bird")

    --Fonts 
    smallFont = love.graphics.newFont("fonts/font.ttf", 8)
    mediumFont = love.graphics.newFont("fonts/flappy.ttf", 14)
    flappyFont = love.graphics.newFont("fonts/flappy.ttf", 28)
    hugeFont = love.graphics.newFont("fonts/flappy.ttf", 56)
    love.graphics.setFont(flappyFont)

    --Sounds
    gameSounds = {
        ["flap"] = love.audio.newSource("sounds/wing.mp3", "static"),
        ["hit"] = love.audio.newSource("sounds/hit.mp3", "static"),
        ["score"] = love.audio.newSource("sounds/point.mp3", "static"),
        ["theme"] = love.audio.newSource("sounds/theme(Instrumental).mp3", "static")
    }

    -- Start the theme loop
    gameSounds["theme"]:setLooping(true)
    gameSounds["theme"]:play()

    -- Initialize the window with options
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Virtual screen
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = "normal"})

    -- State machine 
    gameStateMachine = StateMachine{
        ["title"] = function() return TitleScreenState() end,
        ["play"] = function() return PlayState() end,
        ["score"] = function() return ScoreState() end
    }

    gameStateMachine:change("title")

    -- Input table
    love.keyboard.keysPressed = {}
end 

function love.resize(w, h)
    push.resize(w, h)
end


function love.keypressed(key)
    -- Adds the keypressed on the input table
    love.keyboard.keysPressed[key] = true

    if key == "escape" then
        love.event.quit()
    end
end

-- Checks the input table for keys that were pressed 
function love.keyboard.wasPressed(key)
    if love.keyboard.keysPressed[key] then
        return true
    else 
        return false
    end 
end

-- Update loop
function love.update(dt)
    -- The flag isScrolling controlls the update loop
    if isScrolling then
        -- Updates the background scrolling
        updateBackground(dt) 
    end

    gameStateMachine:update(dt)
   
    -- Resets the input table
    love.keyboard.keysPressed = {}
end 

-- Drawing loop or graphics update
function love.draw()
    --Initializes virtual screen
    push.start()

    --Game graphics 
    -- Background image
    love.graphics.draw(background, -backgroundScroll, 0)
    -- The second copy to fill the first 256px gap
    love.graphics.draw(background, -backgroundScroll + BACKGROUND_LOOPING_POINT, 0)
    -- The third copy to fill the remaining screen width during the scroll
    love.graphics.draw(background, -backgroundScroll + (BACKGROUND_LOOPING_POINT * 2), 0)

    gameStateMachine:render()

    -- Draws the ground at the bottom of the screen minus its height of 16px
    love.graphics.draw(ground,-groundScroll,VIRTUAL_HEIGHT - 16)

    --Ends virtual screen
    push.finish()
end 

-- Updates the background scrolling based on the falg isScrolling
function updateBackground(dt)
    if isScrolling then
        -- Scrolls background by preset speed * dt, looping back to 0 after the looping point
        backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
        -- Scrolls the ground by preset speed * dt, lopping back to 0 after the screen width ends
        groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt ) % VIRTUAL_WIDTH
    end
end

