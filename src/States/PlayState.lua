PlayState = Class{__includes = BaseState}

local Game = require 'src.Gameplay.Game'

function PlayState:init()
    self.game = nil
end

function PlayState:enter(params)
    -- create a new game instance
    self.game = Game()
end

function PlayState:update(dt)
    if self.game then self.game:update(dt) end
end

function PlayState:render()
    if self.game then self.game:render() end
end

function PlayState:exit()
    -- optionally cleanup
    self.game = nil
end

return PlayState
