--[[
    Flappy Bird is mobile game by Dong Nguyen that went viral in 2013, utilizing a very simple
    but effective gameplay mechanic of avoiding pipes indefinitely by just tapping
    the screen, making the player's bird avatar flap its wings and move upwards slightly.

]]

-- Virtual resolution library
push = require "push"

-- class is a library that helps with Object Oriented Programming in lua
class = require "class"

-- Classes
require "Bird"

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


-- Setup function initializes all the game variables and modes
function love.load()
    -- nearest-neighbor mode
    love.graphics.setDefaultFilter("nearest", "nearest")

    -- Background and ground
    background = love.graphics.newImage("images/background.png")
    ground = love.graphics.newImage("images/ground.png")

    --Window
    -- Window title
    love.window.setTitle("Flappy bird")
    -- Initialize the window with options
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        vsync = true,
        fullscreen = false,
        resizable = true
    })

    -- Virtual screen
    push.setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, {upscale = "normal"})

    -- Variables
    bird = Bird()
end 

function love.resize(w, h)
    push.resize(w, h)
end

function love.keypressed(key)
    if key == "escape" then
        love.event.quit()
    end
end

-- Update loop
function love.update(dt)
    -- scroll background by preset speed * dt, looping back to 0 after the looping point
    backgroundScroll = (backgroundScroll + BACKGROUND_SCROLL_SPEED * dt) % BACKGROUND_LOOPING_POINT
    
    -- Scroll the ground by preset speed * dt, lopping back to 0 after the screen width ends
    groundScroll = (groundScroll + GROUND_SCROLL_SPEED * dt ) % VIRTUAL_WIDTH


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

    
    -- Draw the ground at the bottom of the screen minus its height of 16px
    love.graphics.draw(ground,-groundScroll,VIRTUAL_HEIGHT - 16)

    bird:render()

    --Ends virtual screen
    push.finish()
end 