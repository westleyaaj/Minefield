tween = require 'tween'
timer = require 'timer'
animater = require 'animater'
uiHelper = require 'uiHelper'
uiPanels = require 'uiPanels'

scenes = {}
scenes.level = require ('game')
--scenes.editer = require ('Editer')

state = scenes.level

local gameWidth = 1200   -- Your target internal width
local gameHeight = 800  -- Your target internal height
local canvas
local scale = 1
local scaleMode = "fit" -- use "fit" to preserve all content, "fill" to maximize visible area and crop edges if needed

local function updateScale(w, h)
    if scaleMode == "fill" then
        scale = math.max(w / gameWidth, h / gameHeight)
    else
        scale = math.min(w / gameWidth, h / gameHeight)
    end
end

function love.load()
    -- Create the virtual canvas
    canvas = love.graphics.newCanvas(gameWidth, gameHeight)
    
    -- If you want crisp pixel art, set the filter to 'nearest'
    canvas:setFilter("nearest", "nearest")
    
    -- Calculate initial scale based on current window size
    local windowWidth = love.graphics.getWidth()
    local windowHeight = love.graphics.getHeight()
    updateScale(windowWidth, windowHeight)

    love.keyboard.setKeyRepeat(true)
    love.graphics.setDefaultFilter('nearest', 'nearest')


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
--    if width ~= love.graphics.getWidth() or height ~= love.graphics.getHeight() then -- i do it this way becous the resize func doesnt work with maxaiming
--        scale = math.min(width / gameWidth, height / gameHeight)
--    end

    widthReal, heightReal = love.graphics.getDimensions()

    updateScale(widthReal, heightReal)


-- 1. Redirect all drawing to the canvas
    love.graphics.setCanvas(canvas)
    love.graphics.clear() -- Clear the canvas
    
    if state and type(state.draw) == "function" then
        state.draw()
    end
    uiPanels.draw()

    -- 2. Stop drawing to the canvas, switch back to the main screen
    love.graphics.setCanvas()
    
    -- 3. Draw the canvas to the screen, centered with letterboxing
    local offsetX = (love.graphics.getWidth() - (gameWidth * scale)) / 2
    local offsetY = (love.graphics.getHeight() - (gameHeight * scale)) / 2
    
    love.graphics.draw(canvas, offsetX, offsetY, 0, scale, scale)
end

function love.mousemoved(x, y, dx, dy, istouch)
    -- Convert screen coordinates to canvas coordinates
    local offsetX = (love.graphics.getWidth() - (gameWidth * scale)) / 2
    local offsetY = (love.graphics.getHeight() - (gameHeight * scale)) / 2
    
    local canvasX = (x - offsetX) / scale
    local canvasY = (y - offsetY) / scale
    
    if state and type(state.mousemoved) == "function" then
        state.mousemoved(canvasX, canvasY, dx / scale, dy / scale, istouch)
    end
end

function love.mousepressed(x, y, button, istouch, presses)
    -- Convert screen coordinates to canvas coordinates
    local offsetX = (love.graphics.getWidth() - (gameWidth * scale)) / 2
    local offsetY = (love.graphics.getHeight() - (gameHeight * scale)) / 2
    
    local canvasX = (x - offsetX) / scale
    local canvasY = (y - offsetY) / scale
    
    print("main.mousepressed", canvasX, canvasY, button)
    if state and type(state.mousepressed) == "function" then
        state.mousepressed(canvasX, canvasY, button, istouch, presses)
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

