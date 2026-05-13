game = {}



--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Helper Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------



local function get(t, y, x)
    return t[y] and t[y][x]
end

-- clampOffsets ensures the grid remains at least a border's width
-- inside the window. The offsets provided are the position of the top-left
-- cell (x=1,y=1) in pixel coordinates.
local function clampOffsets(offsetX, offsetY, zoom)
    local gridWidth = levelSize.x * zoom
    local gridHeight = levelSize.y * zoom

    -- off bounds relative to the screen edges
    local boundX1 = width - gridWidth - minBorder
    local boundX2 = minBorder
    local boundY1 = height - gridHeight - minBorder
    local boundY2 = minBorder

    -- ensure low/high ordering so clamping works even if grid fits with
    -- room on both sides (bound1 may be greater than bound2).
    local lowX, highX = math.min(boundX1, boundX2), math.max(boundX1, boundX2)
    local lowY, highY = math.min(boundY1, boundY2), math.max(boundY1, boundY2)

    offsetX = math.max(math.min(offsetX, highX), lowX)
    offsetY = math.max(math.min(offsetY, highY), lowY)

    return offsetX, offsetY
end

-- ensure the currently selected cell is within the visible window. Returns
-- new offsets (possibly unchanged) which should then be applied (tweened).
local function ensureSelectionVisible()
    local zoom = gridTransform.zoomPixels
    local selX = gridTransform.offsetX + (selection.x - 1) * zoom
    local selY = gridTransform.offsetY + (selection.y - 1) * zoom

    local newOffX = gridTransform.offsetX
    local newOffY = gridTransform.offsetY

    if selX < 0 then
        newOffX = newOffX - selX
    elseif selX + zoom > width then
        newOffX = newOffX - (selX + zoom - width)
    end

    if selY < 0 then
        newOffY = newOffY - selY
    elseif selY + zoom > height then
        newOffY = newOffY - (selY + zoom - height)
    end

    newOffX, newOffY = clampOffsets(newOffX, newOffY, zoom)
    return newOffX, newOffY
end

--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Logic Functions--------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

local function checkMineState()
    local count = 0
    for y, row in ipairs(levelGrids.flags) do
        for x, cell in ipairs(row) do
            if levelGrids.flags[y][x] == 2 then
                count = count + 1
            end
        end
    end
    uiHelper.editPanelText(percentPanel, count .. "/" .. totalMines .. " " .. math.floor(count / totalMines * 100) .. "% Done", colorIndex.text)
    if count == totalMines then
        endGame()
    end
end

local function getNearByMinesSprite(y, x)
    local mineCount = 0
    
   if get(levelGrids.modifiers, y, x) == 0 then

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


    if get(levelGrids.modifiers, y, x) == 1 then -- Up arrow
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

    if get(levelGrids.modifiers, y, x) == 2 then -- Right arrow
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

    if get(levelGrids.modifiers, y, x) == 3 then -- Down arrow
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

    if get(levelGrids.modifiers, y, x) == 4 then -- Left arow
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

function fail(step, x, y)
    if step == 1 then
        love.audio.play(boom)
        flashTween = tween.new(0.1, flashEffect, {1, 1, 1, 1}, 'inSine')
        timer.after(1, function() fail(2, x, y) end)
    elseif step == 2 then
        for y, row in ipairs(levelGrids.flags) do
            for x, cell in ipairs(row) do
                levelGrids.flags[y][x] = 0
            end 
        end 

        print("aaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaaa")

        levelGrids.flags[y][x] = 2

        flashTween = tween.new(1, flashEffect, {1, 1, 1, 0}, 'inSine')
        checkMineState()
    end

end

function drawCountdown(state)
    part1 = love.graphics.newText( fontSize2, {state.part1Color, "1"} ) --slow
    love.graphics.draw(part1, width / 2, state.part1position)
    part2 = love.graphics.newText( fontSize2, {state.part2Color, "2"} ) --slow
    love.graphics.draw(part2, width / 2, state.part2position)
    part3 = love.graphics.newText( fontSize2, {state.part3Color, "3"} ) --slow
    love.graphics.draw(part3, width / 2, state.part3position)
    part4 = love.graphics.newText( fontSize2, {state.part4Color, "Start"} ) --slow
    love.graphics.draw(part4, width / 2, state.part4position)
end

function startGame(step)
    if step == 1 then
        countdownTween = tween.new(0.3, countdownState, {
            part1position = height / 2,
            part1Color = {1,0,0,1},
            part2position = -20,
            part2Color = {0,1,0,1},
            part3position = -20,
            part3Color = {0,0,1,1},
            part4position = -20,
            part4Color = {1,1,1,1}
        }, 'inSine')
        timer.after(0.3, function() startGame(2) print("aaaaaaaaaaaaa") end)
    end
    if step == 2 then
        countdownTween = tween.new(0.3, countdownState, {
            part1position = height / 2,
            part1Color = {1,0,0,0},
            part2position = height / 2,
            part2Color = {0,1,0,1},
            part3position = -20,
            part3Color = {0,0,1,1},
            part4position = -20,
            part4Color = {1,1,1,1}
        }, 'inSine')
        timer.after(0.3, function() startGame(3) end)
        love.audio.play(blip1)
    end
    if step == 3 then
        print("3")
        countdownTween = tween.new(0.3, countdownState, {
            part1position = height / 2,
            part1Color = {1,0,0,0},
            part2position = height / 2,
            part2Color = {0,1,0,0},
            part3position = height / 2,
            part3Color = {0,0,1,1},
            part4position = -20,
            part4Color = {1,1,1,1}
        }, 'inSine')
        timer.after(0.3, function() startGame(4) end)
        love.audio.play(blip1)
    end
    if step == 4 then
        countdownTween = tween.new(0.3, countdownState, {
            part1position = height / 2,
            part1Color = {1,0,0,0},
            part2position = height / 2,
            part2Color = {0,1,0,0},
            part3position = height / 2,
            part3Color = {0,0,1,0},
            part4position = height / 2,
            part4Color = {1,1,1,1}
        }, 'inSine')
        timer.after(0.3, function() startGame(5) end)
        love.audio.play(blip1)
    end
    if step == 5 then
        countdownTween = tween.new(0.3, countdownState, {
            part1position = height / 2,
            part1Color = {1,0,0,0},
            part2position = height / 2,
            part2Color = {0,1,0,0},
            part3position = height / 2,
            part3Color = {0,0,1,0},
            part4position = height / 2,
            part4Color = {1,1,1,0}
        }, 'inSine')
        timer.after(0.3, function() startGame(6) end)
        love.audio.play(blip2)
    end
    if step == 6 then
        gamePaused = false
    end
    
end

function endGame()
    game.keypressed("-")
    gamePaused = true
    gameEnded = true
    uiPanels.openEndBanner(time, goalTime)
end

--------------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------Drawing Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------

local function drawBackground(size)
    local ySize = 0
    local xSize = 0

    while ySize < height do
        while xSize < width do
            love.graphics.draw(mainSprites, animations.water.currentFrame, xSize, ySize, 0, size / 16, size / 16)
            xSize = xSize + size
        end
        ySize = ySize + size
        xSize = 0
    end

end

local function drawGrid(gridX, gridY, size) -- size are the pixel size not a scale factor 

    for y, row in ipairs(levelGrids.mines) do
        for x, cell in ipairs(row) do
            
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 0 then
                love.graphics.draw(mainSprites, cell0, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)

            end
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 1 then
                love.graphics.draw(mainSprites, getNearByMinesSprite(y, x), size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
                -- modifiers 0 = none 1 = Up 2 = Right 3 = Down 4 = Left
                if get(levelGrids.modifiers, y, x) == 1 then
                    love.graphics.draw(mainSprites, topMod, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
                end
                if get(levelGrids.modifiers, y, x) == 2 then
                    love.graphics.draw(mainSprites, rightMod, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
                end
                if get(levelGrids.modifiers, y, x) == 3 then
                    love.graphics.draw(mainSprites, downMod, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
                end
                if get(levelGrids.modifiers, y, x) == 4 then
                    love.graphics.draw(mainSprites, leftMod, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
                end

            end
            if levelGrids.mines[y][x] ~= 2 and levelGrids.flags[y][x] == 2 then
                love.graphics.draw(mainSprites, flagged, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)

            end

            -- walls
            if levelGrids.walls[y][x] == 1 then
                love.graphics.draw(mainSprites, leftWall, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end
            if levelGrids.walls[y][x] == 2 then
                love.graphics.draw(mainSprites, topWall, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end
            if levelGrids.walls[y][x] == 3 then
                love.graphics.draw(mainSprites, leftTopWall, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end
            
            -- Borders

            if levelGrids.mines[y][x] == 2 then
                if get(levelGrids.mines, y, x - 1) ~= 2 and get(levelGrids.mines, y - 1, x ) ~= 2 and y - 1 ~= 0 then 
                    love.graphics.draw(mainSprites, InteriorCornerBorder, size * x + gridX - size, size * y + gridY - size , 0, size / 16, size / 16)
                elseif get(levelGrids.mines, y, x - 1) ~= 2 then
                    love.graphics.draw(mainSprites, sideBorder, size * x + gridX - size, size * y + gridY - size , 0, size / 16, size / 16)
                    if y == levelSize.y then
                        love.graphics.draw(mainSprites, cornerBorder, size * x + gridX - size, size * y + gridY , 0, size / 16, size / 16)
                    end
                elseif get(levelGrids.mines, y - 1, x ) ~= 2 then
                    love.graphics.draw(mainSprites, bottomBorder, size * x + gridX - size, size * y + gridY - size , 0, size / 16, size / 16)
                end

            end


            if levelGrids.mines[y][x] ~= 2 and y == levelSize.y then
                love.graphics.draw(mainSprites, bottomBorder, size * x + gridX - size, size * y + gridY , 0, size / 16, size / 16)
            end
            if levelGrids.mines[y][x] ~= 2 and x == levelSize.x then
                love.graphics.draw(mainSprites, sideBorder, size * x + gridX, size * y + gridY - size , 0, size / 16, size / 16)
            end
            if levelGrids.mines[y][x] ~= 2 and x == levelSize.x and y == levelSize.y then
                love.graphics.draw(mainSprites, cornerBorder, size * x + gridX, size * y + gridY , 0, size / 16, size / 16)
            end

            if selection.y == y and selection.x == x then
                love.graphics.draw(mainSprites, animations.selectionSprite.currentFrame, size * x + gridX - size, size * y + gridY - size, 0, size / 16, size / 16)
            end

        end

    end

end

function resize()
    width, height = love.graphics.getDimensions()
    
    -- Recenter the grid
    local gridWidth = levelSize.x * gridTransform.zoomPixels
    local gridHeight = levelSize.y * gridTransform.zoomPixels
    gridTransform.offsetX = (width - gridWidth) / 2
    gridTransform.offsetY = (height - gridHeight) / 2
    
    -- Clamp the offsets to respect borders
    gridTransform.offsetX, gridTransform.offsetY = clampOffsets(gridTransform.offsetX, gridTransform.offsetY, gridTransform.zoomPixels)
    
    -- Cancel any ongoing move tween to prevent it from overriding the recentering
    moveTween = nil
end
--------------------------------------------------------------------------------------------------------------------------------
---------------------------------------------------Export Functions-------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------------


function game.keypressed(key)
    if not gamePaused then   
        if key == "up" then
            if selection.y - 1 > 0 then
                selection.y = selection.y - 1
                zoomTween = nil
                -- pan if necessary
                local tx, ty = ensureSelectionVisible()

                

                if tx ~= gridTransform.offsetX or ty ~= gridTransform.offsetY then
                    ty = ty - scrolloffset
                    moveTween = tween.new(0.1, gridTransform, {offsetX = tx, offsetY = ty}, 'inSine')
                end
            end
        end
        if key == "down" then
            if selection.y + 1 < levelSize.y + 1 then
                selection.y = selection.y + 1
                zoomTween = nil
                local tx, ty = ensureSelectionVisible()

                

                if tx ~= gridTransform.offsetX or ty ~= gridTransform.offsetY then
                    ty = ty + scrolloffset
                    moveTween = tween.new(0.1, gridTransform, {offsetX = tx, offsetY = ty}, 'inSine')
                end
            end
        end
        if key == "left" then
            if selection.x - 1 > 0 then 
                selection.x = selection.x - 1
                zoomTween = nil
                local tx, ty = ensureSelectionVisible()

                


                if tx ~= gridTransform.offsetX or ty ~= gridTransform.offsetY then
                    tx = tx + scrolloffset
                    moveTween = tween.new(0.1, gridTransform, {offsetX = tx, offsetY = ty}, 'inSine')
                end
            end
        end
        if key == "right" then
            if selection.x + 1 < levelSize.x + 1 then
                selection.x = selection.x + 1
                zoomTween = nil
                local tx, ty = ensureSelectionVisible()

                

                if tx ~= gridTransform.offsetX or ty ~= gridTransform.offsetY then
                    tx = tx - scrolloffset
                    moveTween = tween.new(0.1, gridTransform, {offsetX = tx, offsetY = ty}, 'inSine')
                end
            end  
        end
        if key == "-" then
            moveTween = nil
            local newZoom = gridTransform.zoomPixels - 16
            local gridW = levelSize.x * newZoom
            local gridH = levelSize.y * newZoom
            local newOffsetX = (width - gridW) / 2
            local newOffsetY = (height - gridH) / 2
            newOffsetX, newOffsetY = clampOffsets(newOffsetX, newOffsetY, newZoom)
            -- ensure selection still visible after zoom using the new offsets
            do
                local selPixelX = newOffsetX + (selection.x - 1) * newZoom
                local selPixelY = newOffsetY + (selection.y - 1) * newZoom
                if selPixelX < 0 then
                    newOffsetX = newOffsetX - selPixelX
                elseif selPixelX + newZoom > width then
                    newOffsetX = newOffsetX - (selPixelX + newZoom - width)
                end
                if selPixelY < 0 then
                    newOffsetY = newOffsetY - selPixelY
                elseif selPixelY + newZoom > height then
                    newOffsetY = newOffsetY - (selPixelY + newZoom - height)
                end
                newOffsetX, newOffsetY = clampOffsets(newOffsetX, newOffsetY, newZoom)
            end
            zoomTween = tween.new(0.1, gridTransform, {
                zoomPixels = newZoom,
                offsetX = newOffsetX,
                offsetY = newOffsetY
            }, 'inSine')
        end
        if key == "=" then
            moveTween = nil
            local newZoom = gridTransform.zoomPixels + 16
            local gridW = levelSize.x * newZoom
            local gridH = levelSize.y * newZoom
            local newOffsetX = (width - gridW) / 2
            local newOffsetY = (height - gridH) / 2
            newOffsetX, newOffsetY = clampOffsets(newOffsetX, newOffsetY, newZoom)
            -- check selection relative to the new offsets
            do
                local selPixelX = newOffsetX + (selection.x - 1) * newZoom
                local selPixelY = newOffsetY + (selection.y - 1) * newZoom
                if selPixelX < 0 then
                    newOffsetX = newOffsetX - selPixelX
                elseif selPixelX + newZoom > width then
                    newOffsetX = newOffsetX - (selPixelX + newZoom - width)
                end
                if selPixelY < 0 then
                    newOffsetY = newOffsetY - selPixelY
                elseif selPixelY + newZoom > height then
                    newOffsetY = newOffsetY - (selPixelY + newZoom - height)
                end
                newOffsetX, newOffsetY = clampOffsets(newOffsetX, newOffsetY, newZoom)
            end
            zoomTween = tween.new(0.1, gridTransform, {
                zoomPixels = newZoom,
                offsetX = newOffsetX,
                offsetY = newOffsetY
            }, 'inSine')
        end
        if key == "z" then
            if levelGrids.mines[selection.y][selection.x] == 0 then
                levelGrids.flags[selection.y][selection.x] = 1
            elseif levelGrids.mines[selection.y][selection.x] == 1 then
                fail(1, selection.x, selection.y)
            end
            checkMineState()

        end 
        if key == "x" then
            if levelGrids.flags[selection.y][selection.x] ~= 1 then
                if levelGrids.flags[selection.y][selection.x] == 2 then
                    levelGrids.flags[selection.y][selection.x] = 0
                else 
                    levelGrids.flags[selection.y][selection.x] = 2
                end
            end
            checkMineState()
        end  
    else

    end
    if key == "r" then 
        resize()
        width, height = love.graphics.getDimensions()
    end
end

function game.update(dt)
    
    timer.update(dt)
    
    
    animater.update(animations, dt)
    if zoomTween then
        zoomTween:update(dt)
    end
    if moveTween then
        moveTween:update(dt)
    end    
    if flashTween then
        flashTween:update(dt)
    end    
    if countdownTween then
        countdownTween:update(dt)
    end   
    if countdownTween2 then
        countdownTween2:update(dt)
    end   

end

function game.load()
    width, height = love.graphics.getDimensions()

    minBorder = 64
    
    gridTransform = {zoomPixels = 64, offsetX = 48, offsetY = 48}
    zoomTween = nil
    moveTween = nil
    flashTween = nil

    countdownTween = nil
    countdownTween2 = nil

    bannerTween = nil
    bannerOffset = {100}

    gameEnded = false
    gamePaused = true

    scrolloffset = 60 --used to offset the output of ensureSelectionVisible() so that the water and border can be seen 


    -- load level
    level = require("Levels/Test1")

    levelGrids = {}

    levelGrids.mines = level.mines -- 0 = safe, 1 = mine, 2 = empty 
    levelGrids.flags = level.flags -- 0 = hidden 1 = revealed 2 = flagged
    levelGrids.modifiers = level.mods -- 0 = none 1 = Up 2 = Right 3 = Down 4 = Left
    levelGrids.walls = level.walls -- 1 = left 2 = top 3 = both 

    totalMines = 0
    for y, row in ipairs(levelGrids.mines) do
        for x, cell in ipairs(row) do
            if cell == 1 then
                totalMines = totalMines + 1
            end
        end
    end

    goalTime = 5000

    levelSize = {}

    levelSize.y = #levelGrids.mines
    levelSize.x = #levelGrids.mines[1]

    --load sound
    boom = love.audio.newSource("Sounds/boomAndFlash.wav", "stream")
    blip1 = love.audio.newSource("Sounds/startingBlip.wav", "stream")
    blip2 = love.audio.newSource("Sounds/startingBlip2.wav", "stream")

    -- load sprites
    

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
    cell1 = love.graphics.newQuad(16 * 12, 0, 16, 16, mainSprites)
    cell2 = love.graphics.newQuad(16 * 13, 0, 16, 16, mainSprites)
    cell3 = love.graphics.newQuad(16 * 14, 0, 16, 16, mainSprites)

    leftTopWall = love.graphics.newQuad(16 * 8, 16, 16, 16, mainSprites)
    leftWall = love.graphics.newQuad(16 * 9, 16, 16, 16, mainSprites)
    topWall = love.graphics.newQuad(16 * 10, 16, 16, 16, mainSprites)

    rightMod = love.graphics.newQuad(16 * 4, 16, 16, 16, mainSprites)
    downMod = love.graphics.newQuad(16 * 5, 16, 16, 16, mainSprites)
    leftMod = love.graphics.newQuad(16 * 6, 16, 16, 16, mainSprites)
    topMod = love.graphics.newQuad(16 * 7, 16, 16, 16, mainSprites)

    bottomBorder = love.graphics.newQuad(16 * 11, 16, 16, 16, mainSprites)
    sideBorder = love.graphics.newQuad(16 * 13, 16, 16, 16, mainSprites)
    cornerBorder = love.graphics.newQuad(16 * 12, 16, 16, 16, mainSprites)
    InteriorCornerBorder = love.graphics.newQuad(16 * 11, 32, 16, 16, mainSprites)
    
    selectionFrame1 = love.graphics.newQuad(0, 16, 16, 16, mainSprites)
    selectionFrame2 = love.graphics.newQuad(16, 16, 16, 16, mainSprites)
    selectionFrame3 = love.graphics.newQuad(16 * 2, 16, 16, 16, mainSprites)
    selectionFrame4 = love.graphics.newQuad(16 * 3, 16, 16, 16, mainSprites)

    waterFrame1 = love.graphics.newQuad(16 * 14, 16, 16, 16, mainSprites)
    waterFrame2 = love.graphics.newQuad(16 * 15, 16, 16, 16, mainSprites)
    waterFrame3 = love.graphics.newQuad(16 * 16, 16, 16, 16, mainSprites)
    waterFrame4 = love.graphics.newQuad(16 * 17, 16, 16, 16, mainSprites)

    animations = {}

    animations.selectionSprite = animater.new({selectionFrame1, selectionFrame2, selectionFrame3, selectionFrame4}, 0.2)
    animations.water = animater.new({waterFrame1, waterFrame2, waterFrame3, waterFrame4}, 0.3)


    -- Ui

    
    flashEffect = {0,0,0,0}
    

    uiPanel1 = love.graphics.newQuad(16 * 7, 16 * 2, 16, 16, mainSprites)
    uiPanel2 = love.graphics.newQuad(16 * 8, 16 * 2, 16, 16, mainSprites)
    uiPanel3 = love.graphics.newQuad(16 * 9, 16 * 2, 16, 16, mainSprites)
    uiPanel4 = love.graphics.newQuad(16 * 7, 16 * 3, 16, 16, mainSprites)
    uiPanel5 = love.graphics.newQuad(16 * 8, 16 * 3, 16, 16, mainSprites)
    uiPanel6 = love.graphics.newQuad(16 * 9, 16 * 3, 16, 16, mainSprites)
    uiPanel7 = love.graphics.newQuad(16 * 7, 16 * 4, 16, 16, mainSprites)
    uiPanel8 = love.graphics.newQuad(16 * 8, 16 * 4, 16, 16, mainSprites)
    uiPanel9 = love.graphics.newQuad(16 * 9, 16 * 4, 16, 16, mainSprites)
    
    local titlePanelOffset = 32 * setUiSize
    titlePanel = uiHelper.makePanel({uiPanel1,uiPanel2,uiPanel3,uiPanel4,uiPanel5,uiPanel6,uiPanel7,uiPanel8,uiPanel9}, 10, height - titlePanelOffset - 10 , level.name, nil, colorIndex.name, colorIndex.text, false )
    
    time = 0
    timer.every(0.1, function() time = time + 1 timePanel = uiHelper.editPanelText(timePanel, formatTime(time) .. " Goal: " .. formatTime(goalTime), colorIndex.text ) end)
    timePanel = uiHelper.makePanel({uiPanel1,uiPanel2,uiPanel3,uiPanel4,uiPanel5,uiPanel6,uiPanel7,uiPanel8,uiPanel9}, width - 10, 10, formatTime(time) .. " Goal: " .. formatTime(goalTime), nil, colorIndex.timer, colorIndex.text, true )


    percentPanel = uiHelper.makePanel({uiPanel1,uiPanel2,uiPanel3,uiPanel4,uiPanel5,uiPanel6,uiPanel7,uiPanel8,uiPanel9}, 10, 10, "0/" .. totalMines .. " 0% Done", nil, colorIndex.progress, colorIndex.text, false )

    selection = {y = 3,x = 4}
    
    resize()

    local tx, ty = ensureSelectionVisible()

    
    gridTransform.offsetX = tx
    gridTransform.offsetY = ty


    countdownState = {
        active = true,
        part1position = -20,
        part1Color = {1,0,0,1},
        part2position = -20,
        part2Color = {0,1,0,1},
        part3position = -20,
        part3Color = {0,0,1,1},
        part4position = -20,
        part4Color = {1,1,1,1}
    }
    
    startGame(1)

    --endGame()
    

end

function game.draw()
    if width ~= love.graphics.getWidth() or height ~= love.graphics.getHeight() then -- i do it this way becous the resize func doesnt work with maxaiming
        resize()
        print("resize")
    end

    width, height = love.graphics.getDimensions()

    

    drawBackground(gridTransform.zoomPixels)
    drawGrid(gridTransform.offsetX, gridTransform.offsetY, gridTransform.zoomPixels)

    uiHelper.drawPanel(titlePanel, setUiSize)
    uiHelper.drawPanel(timePanel, setUiSize)
    uiHelper.drawPanel(percentPanel, setUiSize)

    if countdownState.active then
        drawCountdown(countdownState)
    end


    if flashEffect ~= {0, 0, 0, 0} then
        love.graphics.setColor(flashEffect)
        love.graphics.rectangle("fill", 0,0, width,height)
        love.graphics.setColor(1,1,1)
    end


end

return game