-- init global variables

push = require("push")

VIRTUAL_WIDTH = 384
VIRTUAL_HEIGHT = 216

WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720


function love.load()
    currentSecond = 0
    secondTimer = 0

    love.graphics.setDefaultFilter('nearest', 'nearest')

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
                fullscreen = false,
                vsync = true,
                resizable = true
    })
end

function love.update(delta)
    secondTimer = secondTimer + delta

    if secondTimer > 1 then
        currentSecond = currentSecond + 1
        secondTimer = secondTimer % 1
    end
end



function love.draw()
    push:start()

    push:finish()

end