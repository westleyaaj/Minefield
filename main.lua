tween = require 'tween'

scenes = {}
scenes.level = require ('game')
--scenes.editer = require ('Editer')

state = scenes.level

width = 0
height = 0

function love.load()
    love.graphics.setDefaultFilter('nearest', 'nearest')
    width = love.graphics.getWidth()
    height = love.graphics.getHeight()
    if state and type(state.load) == "function" then
        state.load()
    end
end

function switchScene(newScene)
    state = newScene
    state.load()
end

function love.update(dt)
    if state and type(state.update) == "function" then
        state.update(dt)
    end
end

function love.draw()
    if state and type(state.draw) == "function" then
        state.draw()
    end
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