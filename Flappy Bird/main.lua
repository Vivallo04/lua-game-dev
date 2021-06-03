-- Import all the required libraries
push = require("libraries/push")
Class = require("libraries/class")
require("Bird")
require("Pipe")
require("PipePair")
require("StateMachine")

-- states
require("states/BaseState")
require("states/CountdownState")
require("states/PlayState")
require("states/ScoreState")
require("states/TitleScreenState")


-- Set the screen resolution 
WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720 

VIRTUAL_WIDTH = 512
VIRTUAL_HEIGHT = 288


local background = love.graphics.newImage("assets/sprites/background.png")
local ground = love.graphics.newImage("assets/sprites/ground.png")

local background_scroll = 0 
local ground_scroll = 0

local BACKGROUND_SCROLL_SPEED = 30 
local GROUND_SCROLL_SPEED = 60 

local BACKGROUND_LOOPING_POINT = 413


-- global varuable we use to scroll the map 
scrolling = true


function love.load() 
    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle('Flappy Bird')

    -- seed the RNG
    math.randomseed(os.time())

    -- initialize the fonts
    smallFont = love.graphics.newFont('assets/fonts/font.ttf', 8)
    mediumFont = love.graphics.newFont('assets/fonts/flappy.ttf', 14)
    flappyFont = love.graphics.newFont('assets/fonts/flappy.ttf', 28)
    hugeFont = love.graphics.newFont('assets/fonts/flappy.ttf', 56)

    love.graphics.setFont(flappyFont)

    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 
                    WINDOW_WIDTH, WINDOW_HEIGHT, {
            fullscreen = false, 
            resiazable = true, 
            vsync = true
    })

    sounds = {
        ['jump'] = love.audio.newSource('assets/audio/jump.wav', 'static'), 
        ['explosion'] = love.audio.newSource('assets/audio/explosion.wav', 'static'), 
        ['hurt'] = love.audio.newSource('assets/audio/hurt.wav', 'static'), 
        ['score'] = love.audio.newSource('assets/audio/score.wav', 'static'), 
        ['music'] = love.audio.newSource('assets/audio/marios_way.mp3', 'static')
    }

    --kick off music
    sounds['music']:setLooping(true)
    sounds['music']:play()

    gStateMachine = StateMachine {
        ['title'] = function() return TitleScreenState() end, 
        ['countdown'] = function() return CountdownState() end,
        ['play'] = function() return PlayState() end, 
        ['score'] = function() return ScoreState() end 
    }

    gStateMachine:change('title')

    -- initialize the keyboard input table
    love.keyboard.keysPressed = {}

    -- initialize the mouse input table
    love.keyboard.buttonsPressed = {}
end


function love.resize(width, height)
    push:resize(width, height)
end


function love.keypressed(key)
    -- add the keys pressed to the table of keys pressed this frame
    love.keyboard.keysPressed[key] = true
    if key == 'escape' then 
        love.event.quit()
    end
end


function love.keyboard.wasPressed(key)
    return love.keyboard.keysPressed[key]
end


--[[
    LÖVE2D callback fired each time a mouse button is pressed. 
    Give the x and y of the mouse, as well as the button in question 
]]
function love.mousepressed(x, y, button)
    love.mouse.buttonsPressed[button] = true
end


--[[
    Equivalent to the keyboard function, 
        but for the mouse buttons
]]
function love.mouse.wasPressed(button)
    return love.mouse.buttonsPressed[button]
end


function love.update(delta)
    if scrolling then 
        background_scroll = (background_scroll + BACKGROUND_SCROLL_SPEED * delta) % BACKGROUND_LOOPING_POINT
        ground_scroll = (ground_scroll + GROUND_SCROLL_SPEED * delta) % VIRTUAL_WIDTH
    end

    gStateMachine:update(delta)

    love.keyboard.keysPressed = {}
    love.mouse.buttonsPressed = {}
end

function love.draw()
    push:start() 

    -- parameters: (image, xpos, ypos)
    love.graphics.draw(background, -background_scroll, 0)

    gStateMachine:render()

    -- parameters(image, x, height - image size)
    love.graphics.draw(ground, -ground_scroll, VIRTUAL_HEIGHT - 16)

    push:finish()
end


