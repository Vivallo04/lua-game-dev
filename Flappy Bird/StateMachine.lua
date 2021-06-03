StateMachine =  Class{}

function StateMachine:init(states)
    self.states = states or {}     
    self.empty = {
        render = function() end, 
        update = function() end, 
        enter = function() end, 
        exit = function() end
    }
    self.current = self.empty
end

function StateMachine:change(stateName, enterParams)
    assert(self.states[stateName]) -- a state must exist
    self.current:exit() 
    self.current = self.states[stateName]()
    self.current:enter(enterParams)
end

function StateMachine:update(delta)
    self.current:update(delta)
end


function StateMachine:render()
    self.current:render()
end    