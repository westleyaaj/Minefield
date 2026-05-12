uiHelper = {}

local function formatTime(timerValue)
    -- Assuming timerValue is 1.0 per second (incrementing by 0.1 every 0.1s)
    local minutes = math.floor(timerValue / 600)
    local seconds = math.floor((timerValue / 10) % 60)
    local tenths  = math.floor(timerValue % 10)

    -- %02d pads integers to 2 digits with a leading zero
    -- %d is a standard intege 
    return string.format("%02d:%02d.%d", minutes, seconds, tenths)
end

function uiHelper.drawPanel(panel, uisize)
    -- find width
    if uisize == 1 then
        textSize = panel.text1Width
    elseif uisize == 2 then
        textSize = panel.text2Width
    elseif uisize == 3 then
        textSize = panel.text3Width
    end

    quadSize = 16 * uisize
    panelWidthTiles = math.ceil(textSize / quadSize)
    truePanelWidthTiles = panelWidthTiles + 2
    panelWidth = quadSize * truePanelWidthTiles
   
    differice = panelWidth - textSize
    panelWidthOffset = math.floor(differice / 2)
    -- draw panel

    currentX = panel.x
    currentY = panel.y


    if panel.rightToLeft == true then
        
        love.graphics.setColor(panel.color)

        -- top
        currentX = currentX - quadSize
        love.graphics.draw(mainSprites, panel.quads[3], currentX, currentY, 0, uisize, uisize)
        
        currentX = currentX - quadSize
        for i = 1, panelWidthTiles do
            love.graphics.draw(mainSprites, panel.quads[2], currentX, currentY, 0, uisize, uisize)
            currentX = currentX - quadSize
            
        end

        love.graphics.draw(mainSprites, panel.quads[1], currentX, currentY, 0, uisize, uisize)
        currentY = currentY + quadSize
        
        currentX = panel.x

        -- bottom
        currentX = currentX - quadSize
        love.graphics.draw(mainSprites, panel.quads[9], currentX, currentY, 0, uisize, uisize)

        currentX = currentX - quadSize
        for i = 1, panelWidthTiles do
            love.graphics.draw(mainSprites, panel.quads[8], currentX, currentY, 0, uisize, uisize)
            currentX = currentX - quadSize        
        end

        love.graphics.draw(mainSprites, panel.quads[7], currentX, currentY, 0, uisize, uisize)
        love.graphics.setColor(1, 1, 1)

        -- draw text
        if uisize == 1 then
            love.graphics.draw(panel.text1, currentX + panelWidthOffset, panel.y)
        elseif uisize == 2 then
            love.graphics.draw(panel.text2, currentX + panelWidthOffset, panel.y)
        elseif uisize == 3 then
            love.graphics.draw(panel.text3, currentX + panelWidthOffset, panel.y)
        end

    else

        love.graphics.setColor(panel.color)

        -- top
        love.graphics.draw(mainSprites, panel.quads[1], currentX, currentY, 0, uisize, uisize)
        currentX = currentX + quadSize 
        
        for i = 1, panelWidthTiles do
            love.graphics.draw(mainSprites, panel.quads[2], currentX, currentY, 0, uisize, uisize)
            currentX = currentX + quadSize 
        end

        love.graphics.draw(mainSprites, panel.quads[3], currentX, currentY, 0, uisize, uisize)
        currentY = currentY + quadSize
        
        currentX = panel.x

        -- bottom
        love.graphics.draw(mainSprites, panel.quads[7], currentX, currentY, 0, uisize, uisize)
        currentX = currentX + quadSize 

        for i = 1, panelWidthTiles do
            love.graphics.draw(mainSprites, panel.quads[8], currentX, currentY, 0, uisize, uisize)
            currentX = currentX + quadSize        
        end

        love.graphics.draw(mainSprites, panel.quads[9], currentX, currentY, 0, uisize, uisize)
        love.graphics.setColor(1, 1, 1)

        -- draw text
        if uisize == 1 then
            love.graphics.draw(panel.text1, panel.x + panelWidthOffset, panel.y)
        elseif uisize == 2 then
            love.graphics.draw(panel.text2, panel.x + panelWidthOffset, panel.y)
        elseif uisize == 3 then
            love.graphics.draw(panel.text3, panel.x + panelWidthOffset, panel.y)
        end
    end

end 

function uiHelper.drawbutton(panel, uisize, state)
    -- find width
    if uisize == 1 then
        textSize = panel.text1Width
    elseif uisize == 2 then
        textSize = panel.text2Width
    elseif uisize == 3 then
        textSize = panel.text3Width
    end

    quadSize = 16 * uisize
    panelWidthTiles = math.ceil(textSize / quadSize)
    truePanelWidthTiles = panelWidthTiles + 2
    panelWidth = quadSize * truePanelWidthTiles
   
    differice = panelWidth - textSize
    panelWidthOffset = math.floor(differice / 2)
    -- draw panel

    currentX = panel.x
    currentY = panel.y




    love.graphics.setColor(panel.color)

        -- top
    love.graphics.draw(mainSprites, panel.quads[1], currentX, currentY, 0, uisize, uisize)
    currentX = currentX + quadSize 
        
    for i = 1, panelWidthTiles do
        love.graphics.draw(mainSprites, panel.quads[2], currentX, currentY, 0, uisize, uisize)
        currentX = currentX + quadSize 
    end

    love.graphics.draw(mainSprites, panel.quads[3], currentX, currentY, 0, uisize, uisize)
    currentY = currentY + quadSize
        
    currentX = panel.x

    -- bottom
    love.graphics.draw(mainSprites, panel.quads[7], currentX, currentY, 0, uisize, uisize)
    currentX = currentX + quadSize 

    for i = 1, panelWidthTiles do
        love.graphics.draw(mainSprites, panel.quads[8], currentX, currentY, 0, uisize, uisize)
        currentX = currentX + quadSize        
    end

    love.graphics.draw(mainSprites, panel.quads[9], currentX, currentY, 0, uisize, uisize)
    love.graphics.setColor(1, 1, 1)

    -- draw text
    if uisize == 1 then
        love.graphics.draw(panel.text1, panel.x + panelWidthOffset, panel.y)
    elseif uisize == 2 then
        love.graphics.draw(panel.text2, panel.x + panelWidthOffset, panel.y)
    elseif uisize == 3 then
        love.graphics.draw(panel.text3, panel.x + panelWidthOffset, panel.y)
    end
    

end 

function uiHelper.editPanelText(panel, text, textColor)
    panel.text1Width = fontSize1:getWidth(text)
    panel.text2Width = fontSize2:getWidth(text)
    panel.text3Width = fontSize3:getWidth(text)
    

    panel.text1 = love.graphics.newText( fontSize1, {textColor, text} )
    panel.text2 = love.graphics.newText( fontSize2, {textColor, text} )
    panel.text3 = love.graphics.newText( fontSize3, {textColor, text} )

    return panel
end

function uiHelper.makePanel(quads, x, y, text, icon, color, textColor, rightToLeft ) 
    local newPanel = {}

    newPanel.quads = quads
    newPanel.x = x
    newPanel.y = y
    newPanel.icon = icon
    newPanel.color = color
    newPanel.rightToLeft = rightToLeft
    
    
    newPanel.text1Width = fontSize1:getWidth(text)
    newPanel.text2Width = fontSize2:getWidth(text)
    newPanel.text3Width = fontSize3:getWidth(text)

    newPanel.text1 = love.graphics.newText( fontSize1, {textColor, text} )
    newPanel.text2 = love.graphics.newText( fontSize2, {textColor, text} )
    newPanel.text3 = love.graphics.newText( fontSize3, {textColor, text} )

    


    return newPanel
end

function uiHelper.makeButton(quadsInactive, quadsActive, quadsClicked, text, color ) 
    local newPanel = {}

    newPanel.quadsInactive = quadsInactive
    newPanel.quadsActive = quadsActive
    newPanel.quadsClicked = quadsClicked

    newPanel.x = x
    newPanel.y = y
    newPanel.color = color
    
    newPanel.text1Width = fontSize1:getWidth(text)
    newPanel.text2Width = fontSize2:getWidth(text)
    newPanel.text3Width = fontSize3:getWidth(text)

    newPanel.text1 = love.graphics.newText( fontSize1, {colorIndex.text, text} )
    newPanel.text2 = love.graphics.newText( fontSize2, {colorIndex.text, text} )
    newPanel.text3 = love.graphics.newText( fontSize3, {colorIndex.text, text} )

    return newPanel
end




------------------------------------------------------------------------------------------------------------
--------------------------------------------Built in panels-------------------------------------------------
------------------------------------------------------------------------------------------------------------

function uiHelper.drawEndBanner(offsetAnimation, time, goal)
    love.graphics.setColor(colorIndex.timer)
    love.graphics.rectangle("fill", 0, height - 100 + offsetAnimation, width, 100 )

    love.graphics.setColor(1,1,1)

    local title = love.graphics.newText( fontSize2, {colorIndex.text, "Area Compleate"} )
    love.graphics.draw(title, 40, height - 60 + offsetAnimation - title:getHeight() / 2)

    if goal > time then
        local subTitle = love.graphics.newText( fontSize1, {colorIndex.text, "Goal Reached   " .. "Goal Time:" .. formatTime(goal) .. " Your Time:" .. formatTime(time) } )
        love.graphics.draw(subTitle, 40, height - 15 + offsetAnimation - title:getHeight() / 2)
    else
        local subTitle = love.graphics.newText( fontSize1, {colorIndex.text, "Goal Failed   " .. "Goal Time:" .. formatTime(goal) .. " Your Time:" .. formatTime(time) } )
        love.graphics.draw(subTitle, 40, height - 15 + offsetAnimation - title:getHeight() / 2)
    end

    
    

end

--------------------------------------------------------------------------------------------------

function uiHelper.load ()
    endPanelUiState = 0

    buttonQuadsInactive = {
        love.graphics.newQuad(16 * 3, 16 * 2, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 2, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 2, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 3, 16 * 3, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 3, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 3, 16, 16, mainSprites)
    }
    buttonQuadsActive = {
        love.graphics.newQuad(16 * 3, 16 * 4, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 4, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 4, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 3, 16 * 5, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 5, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 5, 16, 16, mainSprites)
    }
    buttonQuadsClicked = {
        love.graphics.newQuad(16 * 3, 16 * 6, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 6, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 6, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 3, 16 * 7, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 4, 16 * 7, 16, 16, mainSprites),
        love.graphics.newQuad(16 * 5, 16 * 7, 16, 16, mainSprites)
    }

    endPanelExitButton = uiHelper.makeButton(buttonQuadsInactive, buttonQuadsActive, buttonQuadsClicked, "Next", colorIndex.name)
    
end



return uiHelper