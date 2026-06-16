--[[
    The Pair class represents a pair of pipes that are aligned with a fixed gap between
]]

Pair = class{}

-- The gap size changes the dificult of the game
local GAP_HEIGHT = 90

function Pair:init(y)
    -- Initializes the pair past the visible screen by 32 pixels
    self.x = VIRTUAL_WIDTH + 32

    -- The value of y is deffined to the pipe on the top
    self.y = y

    -- Instantiates the pipe pair
    self.pipes = {
        ["upper"] = Pipe("top", self.y),
        ["lower"] = Pipe("bottom", self.y + PIPE_HEIGHT + GAPHEIGHT)
    }

    -- Removoval flag
    self.remove = false
end

function Pair:update(dt)
    removePair()
end

function removePair()
    if self.x > -PIPE_WIDTH then
        self.x = self.x - PIPE_SPEED * dt
        self.pipes["lower"].x = self.x
        self.pipes["upper"].x = self.x
    else
        self.remove = true
    end
end

function Pair:render()
    for key, pipe in pairs(self.pipes) do
        pipe:render()
    end
end