CountdownState = Class{__includes = BaseState}


-- takes 1 second to count down each time
COUNTDOWN_TIME = 0.75

function CountdownState:init() 
    self.count = 3
    self.timer = 0
end


--[[ 
    Keep track of how much time has passed and decrease the count
    if the timer has exceeded the countdown timer. If we have gone 
    done to 0, make a transition to the PlayState.
]]
function CountdownState:update(delta) 
    self.timer = self.timer + delta

    if self.timer > COUNTDOWN_TIME then 
        self.timer = self.timer % COUNTDOWN_TIME
        self.count = self.count - 1

        if self.count == 0 then 
            gStateMachine:change('play')
        end
    end
end


function CountdownState:render() 
    love.graphics.setFont(hugeFont)
    love.graphics.printf(tostring(self.count), 0, 120, VIRTUAL_WIDTH, 'center')
end
