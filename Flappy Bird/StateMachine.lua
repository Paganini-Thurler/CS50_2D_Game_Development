-- The state machine is an abstraction that allows the modeling and control.
-- Each state has its  own trigger and interactions with other statates.

-- Defines the state machine class
StateMachine = class{}

-- Constructor 
-- It receives a state as a parameter
function:StateMachine:init(state)
    -- A table that has the states and its anonymous functions
    self.empty = {
        render = function() end,
        update = function() end,
        processAI = function() end,
        enter = function() end,
        exit = function() end
    }
    self.states = states or {}
    self.current = self.empty
end

-- Changes the state machine
function StateMachine:change(stateName, parameters)
    -- verifies the existance of a state
    assert(self.states[stateName]) 
    self.current:exit()
    self.current = self.states[stateName]()
    self.current:enter(parameters)
end

function StateMachine:update(dt)
    self.current:update(dt)
end

function StateMachine:render()
    self.current:render()
end

-- States controlled by an AI
function StateMachine:processAI(parameters, dt)
    self.current:processAI(parameters, dt)
end