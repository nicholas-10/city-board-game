StartState = Class{__includes = BaseState}

function StartState:init()
    -- to index and call later
    self.options = {
        [1] = function () love.event.quit() end
    }

end
function StartState:enter(enterParams)
end
function StartState:update(dt)

end
function StartState:render()
end
