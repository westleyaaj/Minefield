tween = require 'tween'
timer = require 'timer'
animater = require 'animater'
uiHelper = require 'uiHelper'
uiPanels = require 'uiPanels'

scenes = {}
scenes.level = require ('game')
--scenes.editer = require ('Editer')

state = scenes.level


function love.load()
    love.keyboard.setKeyRepeat(true)
    love.graphics.setDefaultFilter('nearest', 'nearest')
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()


    mainSprites = love.graphics.newImage("Sprites/LevelTileSet.png")

    setUiSize = 1
    fontSize1 = love.graphics.newFont("Font/Born2bSportyFS.otf", 24)
    fontSize2 = love.graphics.newFont("Font/Born2bSportyFS.otf", 48)
    fontSize3 = love.graphics.newFont("Font/Born2bSportyFS.otf", 72)

    colorIndex = {
        text = {1, 1, 1},
        progress = {0.27, 0.0, 0.82},    
        timer    = {0.13, 0.69, 0.0},    
        name     = {0.96, 0.35, 0.24}
    }


    uiPanels.init()

    if state and type(state.load) == "function" then
        state.load()
    end
end

function switchScene(newScene)
    state = newScene
    state.load()
end

function formatTime(timerValue)
    -- Assuming timerValue is 1.0 per second (incrementing by 0.1 every 0.1s)
    local minutes = math.floor(timerValue / 600)
    local seconds = math.floor((timerValue / 10) % 60)
    local tenths  = math.floor(timerValue % 10)

    -- %02d pads integers to 2 digits with a leading zero
    -- %d is a standard intege 
    return string.format("%02d:%02d.%d", minutes, seconds, tenths)
end

function love.update(dt)
    if state and type(state.update) == "function" then
        state.update(dt)
    end
    uiPanels.update(dt)
end

function love.draw()
    
    if state and type(state.draw) == "function" then
        state.draw()
    end
    uiPanels.draw()
end

function love.mousemoved(x, y, dx, dy, istouch)
    if state and type(state.mousemoved) == "function" then
        state.mousemoved(x, y, dx, dy, istouch)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    print("main.mousepressed", x, y, button)
    if state and type(state.mousepressed) == "function" then
        state.mousepressed(x, y, button, istouch, presses)
    end
end

function love.keyreleased(key) 
    uiPanels.keypressed(key)
    print(key)                                                                                                                                                                                                                                                                                               
    if key == 'f12' then                                                                                                                                              
      love.event.quit('restart')                                                                                                                                    
    end 
    if state and type(state.keyreleased) == "function" then
        state.keyreleased(key)
    end                                                                                                                                                            
end

function love.keypressed(key) 
    print(key)                                                                                                                                                                                                                                                                                               
    if key == 'f12' then                                                                                                                                              
      love.event.quit('restart')                                                                                                                                    
    end 
    if state and type(state.keypressed) == "function" then
        state.keypressed(key)
    end                                                                                                                                                            
end

