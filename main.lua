--[[ 
    This is how you do a multiline comment
        in LUA      
]]
WINDOW_WIDTH = 1366
WINDOW_HEIGHT = 768

--[[

]]
function love.load()
    love.window.setMode(WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, 
        resizable = false, 
        vsync = true
    })
end


--[[

]]
function love.draw()
    love.graphics.prinft(
        "Hello Pong!", 
        0, 
        WINDOW_HEIGHT / 2 - 6, 
        WINDOW_WIDTH, 
        "center"
    )
end
