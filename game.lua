game = {}

function game.load()

    minBorder = 48
    maxBorder = 0 -- will be calculated after level loads
    gridTransform = {zoomPixels = 64, offsetX = 48, offsetY = 48}
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

    maxBorder = minBorder - levelSize.x * gridTransform.zoomPixels + width
    maxBorder = math.min(maxBorder, minBorder - levelSize.y * gridTransform.zoomPixels + height)

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

function getValidBounds(zoom)
    -- Ensure the rightmost and bottommost cells end before the screen edge
    local maxOffsetX = math.min(minBorder, width - levelSize.x * zoom)
    local maxOffsetY = math.min(minBorder, height - levelSize.y * zoom)
    return maxOffsetX - minBorder , maxOffsetY - minBorder
end

function clampOffsets(offsetX, offsetY, zoom)
    local maxOffsetX, maxOffsetY = getValidBounds(zoom)
    offsetX = math.max(offsetX, maxOffsetX)
    offsetX = math.min(offsetX, minBorder)
    offsetY = math.max(offsetY, maxOffsetY)
    offsetY = math.min(offsetY, minBorder)
    return offsetX, offsetY
end

function game.keypressed(key)
    if key == "up" then
        if selection.y - 1 > 0 then
            selection.y = selection.y - 1
            zoomTween = nil
            local targetOffsetX = minBorder - gridTransform.zoomPixels * selection.x + width / 2
            local targetOffsetY = minBorder - gridTransform.zoomPixels * selection.y + height / 2
            targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, gridTransform.zoomPixels)
            moveTween = tween.new(0.1, gridTransform, {offsetX = targetOffsetX, offsetY = targetOffsetY}, 'inSine')
        end
    end
    if key == "down" then
        if selection.y + 1 < levelSize.y + 1 then
            selection.y = selection.y + 1
            zoomTween = nil
            local targetOffsetX = minBorder - gridTransform.zoomPixels * selection.x + width / 2
            local targetOffsetY = minBorder - gridTransform.zoomPixels * selection.y + height / 2
            targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, gridTransform.zoomPixels)
            moveTween = tween.new(0.1, gridTransform, {offsetX = targetOffsetX, offsetY = targetOffsetY}, 'inSine')
        end
    end
    if key == "left" then
        if selection.x - 1 > 0 then 
            selection.x = selection.x - 1
            zoomTween = nil
            local targetOffsetX = minBorder - gridTransform.zoomPixels * selection.x + width / 2
            local targetOffsetY = minBorder - gridTransform.zoomPixels * selection.y + height / 2
            targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, gridTransform.zoomPixels)
            moveTween = tween.new(0.1, gridTransform, {offsetX = targetOffsetX, offsetY = targetOffsetY}, 'inSine')
        end
    end
    if key == "right" then
        if selection.x + 1 < levelSize.x + 1 then
            selection.x = selection.x + 1
            zoomTween = nil
            local targetOffsetX = minBorder - gridTransform.zoomPixels * selection.x + width / 2
            local targetOffsetY = minBorder - gridTransform.zoomPixels * selection.y + height / 2
            targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, gridTransform.zoomPixels)
            moveTween = tween.new(0.1, gridTransform, {offsetX = targetOffsetX, offsetY = targetOffsetY}, 'inSine')
        end  
    end
    if key == "-" then
        moveTween = nil
        local newZoom = gridTransform.zoomPixels - 16
        local targetOffsetX = minBorder - newZoom * selection.x + width / 2
        local targetOffsetY = minBorder - newZoom * selection.y + height / 2
        targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, newZoom)
        
        zoomTween = tween.new(0.1, gridTransform, {
            zoomPixels = newZoom,
            offsetX = targetOffsetX,
            offsetY = targetOffsetY
        }, 'inSine')
    end
    if key == "=" then
        moveTween = nil
        local newZoom = gridTransform.zoomPixels + 16
        local targetOffsetX = minBorder - newZoom * selection.x + width / 2
        local targetOffsetY = minBorder - newZoom * selection.y + height / 2
        targetOffsetX, targetOffsetY = clampOffsets(targetOffsetX, targetOffsetY, newZoom)
        
        zoomTween = tween.new(0.1, gridTransform, {
            zoomPixels = newZoom,
            offsetX = targetOffsetX,
            offsetY = targetOffsetY
        }, 'inSine')
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