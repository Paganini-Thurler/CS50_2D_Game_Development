--[[
    BaseState works like an interface in a language like C++ or Java
    It contains all the methods signatures that will be implemented 
    on the other states.
]]

BaseState = class{}

function BaseState:init() end
function BaseState:enter() end
function BaseState:exit() end
function BaseState:update(dt) end
function BaseState:render() end