PipePair = Class{}

-- size of the gap between pipes
local GAP_HEIGHT = 90 


function PipePair:init(y)
    -- flag to hold whether this pair has been scored
    self.score = false

    -- initialize pipes past the end of the screen 
    self.x = VIRTUAL_WIDTH + 32

    -- y value is for the topmost pipe
    -- gap is a vertical shift of the second lower pipe
    self.y = y

    -- instantiate 2 pipes that belong to this pair
    self.pipes = {
        ['upper'] = Pipe('top', self.y), 
        ['lower'] = Pipe('bottom', self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- wheteher this pipe pair is ready to be removed from the scene
    self.remove = false
end


--[[
    remove the pipe from the scene if it's beyond the 
    left edge of the screen, else move it from right 
    to left
]]
function PipePair:update(delta)
    if self.x > -PIPE_WIDTH then 
        self.x = self.x - PIPE_SPEED * delta
        self.pipes['lower'].x = self.x 
        self.pipes['upper'].x = self.x
    else 
        self.remove = true
    end
end


function PipePair:render()
    for l, pipe in pairs(self.pipes) do 
        pipe:render()
    end
end