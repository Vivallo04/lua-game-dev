ScoreState = Class{__includes = BaseState}


--[[
    When in the score state, we expect to receive the score from 
    the play state so we know what to render to the state. 
]]
function ScoreState:enter(params)
    self.score = params.score
end

function ScoreState:update(delta)
    -- go back to play if enter is pressed
    if love.keyboard.wasPressed('enter') or love.keyboard.wasPressed('return') then 
        gStateMachine:change('countdown')
    end
end

function ScoreState:render() 
    -- Render the score to the middle of the screen 
    love.graphics.setFont(flappyFont)
    love.graphics.printf('You lost :(', 0, 64, VIRTUAL_WIDTH, 'center')

    love.graphics.setFont(flappyFont)
    love.graphics.printf('Score: ' ..tostring(self.score), 0, 100, VIRTUAL_WIDTH, 'center')
    love.graphics.printf('Press Enter to play Again!', 0, 160, VIRTUAL_WIDTH, 'center')
end
