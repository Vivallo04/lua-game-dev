push = require("libraries/push") -- Load the push library
Class = require("libraries/class")

require 'Paddle'
require 'Ball'


WINDOW_WIDTH = 1280
WINDOW_HEIGHT = 720

VIRTUAL_WIDTH = 432
VIRTUAL_HEIGHT = 243

-- Speed at chich we will move our paddle
PADDLE_SPEED = 210

--[[
    Runs when the game first starts up, only once; 
    used to initialize the game.
]]
function love.load() -- Set a virtual resolution when it renders
    
    -- "seed" the RNG so that calls to random are always random
    -- use the current time, since that will alaways vary on startup. 
    math.randomseed(os.time())
    

    love.graphics.setDefaultFilter('nearest', 'nearest')
    love.window.setTitle("Pong!")


    smallfont = love.graphics.newFont('font.ttf', 8)
    love.graphics.setFont(smallfont)

    largeFont = love.graphics.newFont('font.ttf', 16)
    scoreFont = love.graphics.newFont('font.ttf', 32)

    -- Initialize window with a virtual resolution
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, 
                        WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false, 
        resizable = false, 
        vsync = true, 
        canvas = false
    })

    sounds = { 
        ['paddle_hit']  = love.audio.newSource('sounds/paddle_hit.wav', 'static'), 
        ['score']       = love.audio.newSource('sounds/score.wav'     , 'static'), 
        ['wall_hit']    = love.audio.newSource('sounds/wall_hit.wav'  , 'static')
    }

    player1_score = 0
    player2_score = 0

    
    -- this variables will be either 1 or 2, starting from 1
    -- whoever is scored on gets to serve the following trun 
    serving_player = 1
    
    -- player who won the game, the value is going to be null 
    -- until we reach that state in the game
    winning_player = 0


    -- Game Variables
    -- Initialize the player paddles and make the global
    player1 = Paddle(10, 30, 5, 20)
    player2 = Paddle(VIRTUAL_WIDTH - 10, VIRTUAL_HEIGHT - 30, 5, 20)

    -- Place the ball
    ball = Ball(VIRTUAL_WIDTH / 2 - 2, VIRTUAL_HEIGHT / 2 - 2, 4, 4)


    -- The game state variables are used to transition between 
    -- different parts of the game(such as beggining, menus, main game, 
    -- high scores, etc).
    game_state = 'start'
end


function love.keypressed(key)
    -- Keys can be accesed by their name as a string
    if key == 'escape' then
        love.event.quit()

    elseif key == 'enter' or key == 'return' then 
        if game_state == 'start' then 
            game_state = 'serve'

        elseif game_state == 'serve' then 
            game_state = 'play'
        
        elseif game_state == 'done' then 
            game_state = 'serve'
            ball:reset()

            -- reset the scores to 0 
            player1_score = 0
            player2_score = 0 


            -- decide the new serving player as the opposite of who won
            if winning_player == 1 then 
                serving_player = 2
            else 
                serving_player = 1
            end

        end
    end

end




--[[

]]
function love.resize(width, height)
    push:resize(width, height)

end    

function displayScore()
    love.graphics.setFont(scoreFont)
    love.graphics.print(tostring(player1_score), VIRTUAL_WIDTH / 2 - 50, VIRTUAL_HEIGHT / 3)
    love.graphics.print(tostring(player2_score), VIRTUAL_WIDTH / 2 + 30, VIRTUAL_HEIGHT / 3)
end


function love.update(delta)

    if game_state == 'serve' then 
        ball.dy = math.random(-50, 50)

        if serving_player == 1 then 
            ball.dx = math.random(140, 200)
        else 
            ball.dx = -math.random( 140, 200)
        end


    elseif game_state == 'play' then 

        if ball:collides(player1) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player1.x + 5

            -- keep velocity going in the same direction 
            -- but randomize it
            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else 
                ball.dy =  math.random(10, 150)
            end

            sounds['paddle_hit']:play()
        end


        if ball:collides(player2) then 
            ball.dx = -ball.dx * 1.03
            ball.x = player2.x - 4

            -- keep the velocity on the same direction
            -- but randomize it
            if ball.dy < 0 then 
                ball.dy = -math.random(10, 150)
            else
                ball.dy = -math.random(10, 150)
            end
        
            sounds['paddle_hit']:play()
        end


        -- detect upper and lower screen boundary collision and 
        -- reverse if collided
        if ball.y <= 0 then 
            ball.y = 0 
            ball.dy = -ball.dy
            sounds['wall_hit']:play()
        end 


        -- -4 account for the ball size
        if ball.y >= VIRTUAL_HEIGHT - 4 then 
            ball.y = VIRTUAL_HEIGHT - 4
            ball.dy = -ball.dy
        end
    
        if ball.x < 0 then 
            serving_player = 1
            player2_score = player2_score + 1
            sounds['score']:play()

            if player2_score == 10 then
                winning_player = 2
                game_state = 'done'
            else 
                game_state = 'serve'
                ball:reset()
            end
        end

        if ball.x > VIRTUAL_WIDTH then 
            serving_player = 2
            player1_score = player1_score + 1
            sounds['score']:play()

            if player1_score == 10 then 
                winning_player = 1
                game_state = 'done'

            else 
                game_state = 'serve'
                ball:reset()
            end
        end

    end


    -- ------------------------------------------------------- --
    -- Player1 Movement
    if love.keyboard.isDown('w') then
        player1.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('s') then 
        player1.dy = PADDLE_SPEED
    else 
        player1.dy = 0
    end 


    -- Player2 Movement
    if love.keyboard.isDown('up') then 
        player2.dy = -PADDLE_SPEED

    elseif love.keyboard.isDown('down') then 
        player2.dy = PADDLE_SPEED    
    else 
        player2.dy = 0
    end


    if game_state == 'play' then
        ball:update(delta)
    end

    player1:update(delta)
    player2:update(delta)

end


function displayFPS()
    love.graphics.setFont(smallfont)
    love.graphics.setColor(0, 255, 0, 255)
    love.graphics.print('FPS: ' ..tostring(love.timer.getFPS()), 10, 10)

end


--[[
    Called after update by LÖVE2D, used to draw anything 
    to the screen, updated or otherwise.
]]
function love.draw()
    -- begin drawing with push, in the virtual resolution 
    push:start()

    love.graphics.clear(40/255, 45/255, 52/255, 255/255)

    if game_state == 'start' then 
        love.graphics.setFont(smallfont)
        love.graphics.printf('Welcome to Pong!', 0, 10, VIRTUAL_WIDTH, 'center')
        love.graphics.printf('Press enter to begin!', 0, 20, VIRTUAL_WIDTH, 'center')

    elseif game_state == 'serve' then 
        love.graphics.setFont(smallfont)
        love.graphics.printf('Player ' ..tostring(serving_player) .. "'s serve", 
                            0, 10, VIRTUAL_WIDTH, 'center')

        love.graphics.printf('Press Enter to serve!', 0, 20, VIRTUAL_WIDTH, 'center')
    
    elseif game_state == 'play' then 
        -- no UI message to display while in play 
    
    elseif game_state == 'done' then 
        love.graphics.setFont(largeFont)
        love.graphics.printf('Player ' ..tostring(winning_player) .. 'wins! ;)', 
                            0, 10 , VIRTUAL_WIDTH, 'center')

        love.graphics.setFont(smallfont)
        love.graphics.printf('Press enter to restart', 0, 30, VIRTUAL_WIDTH, 'center')
    end

    
    -- display the score befor the ball is rendered so it can move over the text 
    displayScore()

    player1:render()
    player2:render()
    ball:render()


    -- Render the current FPS on the screen
    -- displayFPS()

    -- End rendereing at the vritual resolution    
    push:finish()

end