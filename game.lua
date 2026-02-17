game = {}

function game.load()

    gridTransform = {zoomPixels = 64, offsetX = 32, offsetY = 32}
    zoomTween = nil
    moveTween = nil
    
    

    -- load sprites
    mainSprites = love.graphics.newImage("Sprites/LevelTileSet.png")

    --todo themes
    number0 = love.graphics.newQuad(0, 0, 16, 16, mainSprites)
    flagged = love.graphics.newQuad(16 * 10, 0, 16, 16, mainSprites)
    cell0 = love.graphics.newQuad(16 * 11, 0, 16, 16, mainSprites)
    selectionFrame1 = love.graphics.newQuad(0, 16, 16, 16, mainSprites)
    
    -- load level
    level = require("Levels/Level 1 - Simple Going")

    levelGrids = {}

    levelGrids.mines = level.mines -- 0 = safe, 1 = mine, 2 = empty 
    levelGrids.flags = level.flags -- 0 = hidden 1 = revealed 2 = flagged

    levelSize = {}

    levelSize.y = #levelGrids.mines
    levelSize.x = #levelGrids.mines[1]

    selection = {y = 3,x = 4} 
end

function drawGrid(gridX, gridY, size) -- sizex and y are the pixel size not a scale factor 



    for y, row in ipairs(levelGrids.mines) do
        for x, cell in ipairs(row) do
            
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 0 then
                love.graphics.draw(mainSprites, cell0, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end

            if selection.y == y and selection.x == x then
                --todo animate
                love.graphics.draw(mainSprites, selectionFrame1, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end

        end
    end

end

function game.keypressed(key)
    if key == "up" then
        if selection.y - 1 > 0 then
            selection.y = selection.y - 1
        end
    end
    if key == "down" then
        if selection.y + 1 < levelSize.y + 1 then
            selection.y = selection.y + 1
            
            if girdTransform.offsetY + gridTransform.zoomPixels * selection.y > height then
                moveTween = tween.new(0.1, gridTransform, {offsetY = gridTransform.offsetY - gridTransform.zoomPixels}, 'inSine')
            end
        end
    end
    if key == "left" then
        if selection.x - 1 > 0 then 
            selection.x = selection.x - 1
            
            if girdTransform.offsetX < 0 and girdTransform.offsetX + gridTransform.zoomPixels * selection.x < 0 then
                moveTween = tween.new(0.1, gridTransform, {offsetX = math.clamp(gridTransform.offsetX + gridTransform.zoomPixels, -10000, 32)}, 'inSine')
        end
    end
    if key == "right" then
        if selection.x + 1 < levelSize.x + 1 then
            selection.x = selection.x + 1
            
            if girdTransform.offsetX + gridTransform.zoomPixels * selection.x > width then
                 moveTween = tween.new(0.1, gridTransform, {offsetX = gridTransform.offsetX - gridTransform.zoomPixels}, 'inSine')
            end
        end  
    end
    if key == "-" then
        zoomTween = tween.new(0.1, gridTransform, {zoomPixels = gridTransform.zoomPixels - 16}, 'inSine')
    end
    if key == "=" then
        zoomTween = tween.new(0.1, gridTransform, {zoomPixels = gridTransform.zoomPixels + 16}, 'inSine')
    end
end

function game.update(dt)
    if zoomTween then
        zoomTween:update(dt)
    end
    if moveTween then
        moveTween:update(dt)
    end    
end

function game.draw()
    drawGrid(gridTransform.offsetX, gridTransform.offsetY, gridTransform.zoomPixels)
end

return game