Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    self.dx = 0
    self.dy = 0
end


--[[
    Apply velocity to position.
]]
function Ball:update(delta)
    self.x = self.x + self.dx * delta
    self.y = self.y + self.dy * delta
end

--[[
    Expects a paddle as an argument and returns a boolean value, 
    depending on wheter their rectangles overlap.
]]
function Ball:collides(paddle)
    if self.x > paddle.x + paddle.width or paddle.x > self.x + self.width then 
        return false
    end
    
    if self.y > paddle.y + paddle.height or paddle.y > self.y + self.height then 
        return false
    end

    return true
end



--[[ 
    Place the ball where it initially started and add
    a random velocity on both axes. 
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dy = 0
    self.dx = 0
end


function Ball:render()
    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
end