PlayState = Class{__includes = BaseState}

PIPE_SPEED = 60
PIPE_WIDTH = 70
PIPE_HEIGHT = 288

BIRD_WIDTH = 38 
BIRD_HEIGHT = 24

function PlayState:init() 
    self.bird = Bird()
    self.pipePairs = {}
    self.timer = 0 
    self.score = 0 

    -- Initialize the last recorded Y value for a gap placement 
    -- to base other gaps off of
    self.lastY = -PIPE_HEIGHT + math.random(80) + 20 
end

function PlayState:update(delta) 

    -- Update the timer for the pipe spawning
    self.timer = self.timer + delta

    -- Spawn a new pipe pair every second and a half 
    if self.timer > 2 then 
        local y = math.max(-PIPE_HEIGHT + 10, math.min(self.lastY + math.random(-20, 20), VIRTUAL_HEIGHT - 90 - PIPE_HEIGHT))
        self.lastY = y 

        -- add a new pipe pair at the end of the screen at the new Y
        table.insert(self.pipePairs, PipePair(y))

        -- reset the timer
        self.timer = 0 
    end


    -- For each pair of pipes
    for k, pair in pairs(self.pipePairs) do 

        -- score a point if the pipe has fone past the bird to the left
        -- all the way, be sure to ignore if it's already been scored
        if not pair.scored then 
            if pair.x + PIPE_WIDTH < self.bird.x then 
                self.score = self.score + 1
                pair.scored = true
                sounds['scored']:play()
            end
        end

        -- update position of pair
        pair:update(delta)
    end


    --[[

    ]]
    for k, pair in pairs(self.pipePairs) do 
        for l, pipe in pairs(pair.pipes) do 
            if self.bird:collides(pipe) then 
                sounds['explosion']:play()
                sounds['hurt']:play()

                gStateMachine:change('score', {
                    score = self.score
                })
            end
        end
    end

    -- update the bird based on gravity input
    self.bird:update(delta)

    -- reset if we get to the ground 
    if self.bird.y > VIRTUAL_HEIGHT - 15 then 
        sounds['explosion']:play()
        sounds['hurt']:play()

        gStateMachine:change('score', {
            score = self.score
        })
    end
end


function PlayState:render() 
    for k, pair in pairs(self.pipePairs) do 
        pair:render()
    end

    love.graphics.setFont(flappyFont)
    love.graphics.print('Score: ' ..tostring(self.score), 8, 8)

    self.bird:render()
end


--[[
    Called when this state is transitioned from another state
]]
function PlayState:enter()
    -- if we're coming from death, restart scrolling
    scrolling = true
end


--[[
    Called when this state changes to another state
]]
function PlayState:exit()
    -- stop scrolling for either the death or score screen  
    scrolling = false
end