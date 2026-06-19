--[[
    The Pair class represents a pair of pipes that are aligned with a fixed gap between
]]

Pair = class{}

-- The gap size in pixels changes the dificult of the game
local GAP_HEIGHT = 90

-- Constructor
function Pair:init(y)
    -- Initializes the pair past the visible screen by 32 pixels
    self.x = VIRTUAL_WIDTH + 32

    -- The value of y is deffined to the pipe on the top
    self.y = y

    -- Instantiates the pipe pair
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("bottom", self.y + PIPE_HEIGHT + GAP_HEIGHT)
    }

    -- Removoval flag
    self.remove = false
    -- This flag will be used and update on play state 
    self.scored = false
end

-- Updates the Pair
function Pair:update(dt)
    self:removePair(dt)
end

--Removes the pair when it goes offscreen
function Pair:removePair(dt)
    -- If the position x is less than the - pipe width (offscreen)
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes["lower"].x = self.x
        self.pipes["upper"].x = self.x
    else
        -- Sets the removal flag to true
        self.remove = true
    end
end

-- Renders each pipe by calling their render() method
function Pair:render()
    for key, pipe in pairs(self.pipes) do
        pipe:render()
    end
end