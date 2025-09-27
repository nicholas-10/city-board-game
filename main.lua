math.randomseed(os.time())

require 'src/dependencies'
require 'src/constants'

function love.load()
    love.window.setTitle('City')
    push:setupScreen(VIRTUAL_WIDTH, VIRTUAL_HEIGHT, WINDOW_WIDTH, WINDOW_HEIGHT, {
        fullscreen = false,
        resizable = true
    })
    x, y, w, h = 20, 20, 60, 20

    -- statemachine implementation
    gStateMachine = StateMachine{
        ['start'] = function () return StartState() end,
        ['play'] = function () return PlayState() end,
        ['end'] = function () return EndState() end,
    }
    gStateMachine:change('play')

    love.keyboard.keypressed = {}
end

function love.update(dt)
    if love.keyboard.wasPressed('escape') then
        love.event.quit()
    end

    Timer.update(dt)
    w = w + 1
    h = h + 1
    gStateMachine:update(dt)
    love.keyboard.keypressed = {}
end

function love.resize(w, h)
    return push:resize(w, h)
  end

function love.keypressed(key)
    love.keyboard.keypressed[key] = true
end

function love.keyboard.wasPressed(key)
    return love.keyboard.keypressed[key]
end

function love.draw()
    push:start()
    
    --draw here

    gStateMachine:render()
    push:finish()
end