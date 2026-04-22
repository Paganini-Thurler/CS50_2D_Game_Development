-- Global variables --

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

function love.load() 
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT,{
        resizable = false, vsync = true, fullscreen = false
    })

end 

function love.draw()
    -- The -6 is to account for the font height
    love.graphics.printf("Hello!", 0, WINDOW_HEIGHT / 2 - 6, WINDOW_WIDTH, "center")
end