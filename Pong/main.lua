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

-- Notes:
-- In Lua code blocks, such as conditionals ends with end


-- Setup function
function love.load() 
    -- Graphical mode
    love.graphics.setDefaultFilter("nearest", "nearest")

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

-- The drawing function
function love.draw()
    -- Starts the virtual screen
    push.start()
    -- Draws text in the window, the -6 is to account for the font height
    love.graphics.printf("Hello!", 0, VIRTUAL_HEIGHT / 2 - 6, VIRTUAL_WIDTH, "center")
    --End the virtual screen
    push.finish()
end