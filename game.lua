game = {}

function game.load()

    minBorder = 64
    
    gridTransform = {zoomPixels = 64, offsetX = 48, offsetY = 48}
    zoomTween = nil
    moveTween = nil
    
    

    -- load sprites
    mainSprites = love.graphics.newImage("Sprites/LevelTileSet.png")

    --todo themes
    number0 = love.graphics.newQuad(16 * 9, 0, 16, 16, mainSprites)
    number1 = love.graphics.newQuad(0, 0, 16, 16, mainSprites)
    number2 = love.graphics.newQuad(16, 0, 16, 16, mainSprites)
    number3 = love.graphics.newQuad(16 * 2, 0, 16, 16, mainSprites)
    number4 = love.graphics.newQuad(16 * 3, 0, 16, 16, mainSprites)
    number5 = love.graphics.newQuad(16 * 4, 0, 16, 16, mainSprites)
    number6 = love.graphics.newQuad(16 * 5, 0, 16, 16, mainSprites)
    number7 = love.graphics.newQuad(16 * 6, 0, 16, 16, mainSprites)
    number8 = love.graphics.newQuad(16 * 7, 0, 16, 16, mainSprites)
    number9 = love.graphics.newQuad(16 * 8, 0, 16, 16, mainSprites)

    flagged = love.graphics.newQuad(16 * 10, 0, 16, 16, mainSprites)
    cell0 = love.graphics.newQuad(16 * 11, 0, 16, 16, mainSprites)
    selectionFrame1 = love.graphics.newQuad(0, 16, 16, 16, mainSprites)
    
    -- load level
    level = require("Levels/Level 1 - Simple Going")

    levelGrids = {}

    levelGrids.mines = level.mines -- 0 = safe, 1 = mine, 2 = empty 
    levelGrids.flags = level.flags -- 0 = hidden 1 = revealed 2 = flagged
    levelGrids.modifiers = level.mods -- 0 = none 1 = Up 2 = Right 3 = Down 4 = Left
    levelGrids.walls = level.walls

    levelSize = {}

    levelSize.y = #levelGrids.mines
    levelSize.x = #levelGrids.mines[1]



    selection = {y = 3,x = 4} 
end

--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Helper Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


local function getValidBounds(zoom)
    -- Ensure the rightmost and bottommost cells end before the screen edge
    local maxOffsetX = math.min(minBorder, width - levelSize.x * zoom)
    local maxOffsetY = math.min(minBorder, height - levelSize.y * zoom)
    return maxOffsetX - minBorder , maxOffsetY - minBorder
end

local function clampOffsets(offsetX, offsetY, zoom)
    local maxOffsetX, maxOffsetY = getValidBounds(zoom)
    offsetX = math.max(offsetX, maxOffsetX)
    offsetX = math.min(offsetX, minBorder)
    offsetY = math.max(offsetY, maxOffsetY)
    offsetY = math.min(offsetY, minBorder)
    return offsetX, offsetY
end

--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Logic Functions--------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

local function getNearByMinesSprite(y, x)
    local mineCount = 0
    
   if levelGrids.modifiers[y][x] == 0 then
        local function get(t, y, x)
            return t[y] and t[y][x]
        end


        -- above
        if get(levelGrids.mines, y - 1, x) == 1 then
            mineCount = mineCount + 1

            if (get(levelGrids.walls, y, x) == 2) or (get(levelGrids.walls, y, x) == 3) then mineCount = mineCount - 1 end
        end

        -- above-left 
        if get(levelGrids.mines, y - 1, x - 1) == 1 then
            mineCount = mineCount + 1

            if get(levelGrids.walls, y, x) == 3 then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y - 1, x) == 1) or (get(levelGrids.walls, y - 1, x) == 3)) and ((get(levelGrids.walls, y, x - 1) == 2) or (get(levelGrids.walls, y, x - 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y, x) == 1) or (get(levelGrids.walls, y, x) == 3)) and ((get(levelGrids.walls, y - 1, x) == 1) or (get(levelGrids.walls, y - 1, x) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y, x) == 2) or (get(levelGrids.walls, y, x) == 3)) and ((get(levelGrids.walls, y, x - 1) == 2) or (get(levelGrids.walls, y , x- 1) == 3)) then mineCount = mineCount - 1 end
        end

        -- above-right 
        if get(levelGrids.mines, y - 1, x + 1) == 1 then
            mineCount = mineCount + 1

            if ((get(levelGrids.walls, y, x) == 2) or (get(levelGrids.walls, y, x) == 3)) and ((get(levelGrids.walls, y, x + 1) == 1) or (get(levelGrids.walls, y, x + 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y, x + 1) == 2) or (get(levelGrids.walls, y, x + 1) == 3)) and ((get(levelGrids.walls, y - 1, x + 1) == 1) or (get(levelGrids.walls, y - 1, x + 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y, x + 1) == 1) or (get(levelGrids.walls, y, x + 1) == 3)) and ((get(levelGrids.walls, y - 1, x + 1) == 1) or (get(levelGrids.walls, y - 1, x + 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y, x) == 2) or (get(levelGrids.walls, y, x) == 3)) and ((get(levelGrids.walls, y, x + 1) == 2) or (get(levelGrids.walls, y , x + 1) == 3)) then mineCount = mineCount - 1 end
        end

            

        -- left
        if get(levelGrids.mines, y, x - 1) == 1 then
            mineCount = mineCount + 1

            if (get(levelGrids.walls, y, x) == 1) or (get(levelGrids.walls, y, x) == 3) then mineCount = mineCount - 1 end
        end

        -- right 
        if get(levelGrids.mines, y, x + 1) == 1 then
            mineCount = mineCount + 1

            if (get(levelGrids.walls, y, x + 1) == 1) or (get(levelGrids.walls, y, x + 1) == 3) then mineCount = mineCount - 1 end
        end

        -- down
        if get(levelGrids.mines, y + 1, x) == 1 then
            mineCount = mineCount + 1

            if (get(levelGrids.walls, y + 1, x) == 2) or (get(levelGrids.walls, y + 1, x) == 3) then mineCount = mineCount - 1 end
        end
        
       -- down-left 
        if get(levelGrids.mines, y + 1, x - 1) == 1 then
            mineCount = mineCount + 1

            if ((get(levelGrids.walls, y + 1, x) == 2) or (get(levelGrids.walls, y + 1, x) == 3)) and (get(levelGrids.walls, y, x) == 1) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y + 1, x) == 1) or (get(levelGrids.walls, y + 1, x) == 3)) and ((get(levelGrids.walls, y + 1, x - 1) == 2) or (get(levelGrids.walls, y + 1, x - 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y + 1, x) == 1) or (get(levelGrids.walls, y + 1, x) == 3)) and ((get(levelGrids.walls, y, x) == 1) or (get(levelGrids.walls, y, x) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y + 1, x) == 2) or (get(levelGrids.walls, y + 1, x) == 3)) and ((get(levelGrids.walls, y + 1, x - 1) == 2) or (get(levelGrids.walls, y + 1, x - 1) == 3)) then mineCount = mineCount - 1 end
        end

        
        -- down-right
        if get(levelGrids.mines, y + 1, x + 1) == 1 then
            mineCount = mineCount + 1

            if ((get(levelGrids.walls, y + 1, x) == 2) or (get(levelGrids.walls, y + 1, x) == 3)) and (get(levelGrids.walls, y, x + 1) == 1) then mineCount = mineCount - 1 
            elseif get(levelGrids.walls, y + 1, x + 1) == 3 then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y + 1, x + 1) == 1) or (get(levelGrids.walls, y + 1, x + 1) == 3)) and ((get(levelGrids.walls, y, x + 1) == 1) or (get(levelGrids.walls, y, x + 1) == 3)) then mineCount = mineCount - 1 
            elseif ((get(levelGrids.walls, y + 1, x) == 2) or (get(levelGrids.walls, y + 1, x) == 3)) and ((get(levelGrids.walls, y + 1, x + 1) == 2) or (get(levelGrids.walls, y + 1, x + 1) == 3)) then mineCount = mineCount - 1 end
        end

    end


    if levelGrids.modifiers[y][x] == 1 then -- Up arrow
        for upY = y - 1, 1, -1 do
            if levelGrids.mines[upY] and levelGrids.mines[upY][x] == 1 then
                mineCount = mineCount + 1
            end
            if levelGrids.walls[upY][x] == 2 then
                break
            end
            if levelGrids.walls[upY][x] == 3 then
                break
            end
        end
    end

    if levelGrids.modifiers[y][x] == 2 then -- Right arrow
        for rightX = x + 1, #levelGrids.mines[y] do
            if levelGrids.walls[y][rightX] == 1 then
                break
            end
            if levelGrids.walls[y][rightX] == 3 then
                break
            end
            if levelGrids.mines[y] and levelGrids.mines[y][rightX] == 1 then
                mineCount = mineCount + 1
            end
        end
    end

    if levelGrids.modifiers[y][x] == 3 then -- Down arrow
        for downY = y + 1, #levelGrids.mines do
            if levelGrids.walls[downY][x] == 2 then
                break
            end
            if levelGrids.walls[downY][x] == 3 then
                break
            end
            if levelGrids.mines[downY] and levelGrids.mines[downY][x] == 1 then
                mineCount = mineCount + 1
            end
        end
    end

    if levelGrids.modifiers[y][x] == 4 then -- Left arow
        for leftX = x - 1, 1, -1 do
            if levelGrids.mines[y] and levelGrids.mines[y][leftX] == 1 then
                mineCount = mineCount + 1
            end
            if levelGrids.walls[y][leftX] == 1 then
                break
            end
            if levelGrids.walls[y][leftX] == 3 then
                break
            end
        end
    end
    
    if mineCount == 0 then
        return number0
    elseif mineCount == 1 then
        return number1
    elseif mineCount == 2 then
        return number2
    elseif mineCount == 3 then
        return number3
    elseif mineCount == 4 then
        return number4
    elseif mineCount == 5 then
        return number5
    elseif mineCount == 6 then
        return number6
    elseif mineCount == 7 then
        return number7
    elseif mineCount == 8 then
        return number8
    elseif mineCount == 9 then
        return number9
    end

end


--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Drawing Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


local function drawGrid(gridX, gridY, size) -- sizex and y are the pixel size not a scale factor 



    for y, row in ipairs(levelGrids.mines) do
        for x, cell in ipairs(row) do
            
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 0 then
                love.graphics.draw(mainSprites, cell0, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 1 then
                love.graphics.draw(mainSprites, getNearByMinesSprite(y, x), size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 2 then
                love.graphics.draw(mainSprites, flagged, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end

            if selection.y == y and selection.x == x then
                --todo animate
                love.graphics.draw(mainSprites, selectionFrame1, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end

        end
    end

end

--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Export Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


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
    if key == "z" then
        if levelGrids.mines[selection.y][selection.x] == 0 then
            levelGrids.flags[selection.y][selection.x] = 1
        end
    end 
    if key == "x" then
        if levelGrids.flags[selection.y][selection.x] ~= 1 then
            if levelGrids.flags[selection.y][selection.x] == 2 then
                levelGrids.flags[selection.y][selection.x] = 0
            else 
                levelGrids.flags[selection.y][selection.x] = 2
            end
        end
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