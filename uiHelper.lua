uiHelper = {}


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

function uiHelper.drawbutton(panel, uisize, x, y, state)
    -- find width
    if uisize == 1 then
        textSize = panel.text1Width
    elseif uisize == 2 then
        textSize = panel.text2Width
    elseif uisize == 3 then
        textSize = panel.text3Width
    end

    local quadSize = 16 * uisize
    local panelWidthTiles = math.ceil(textSize / quadSize)
    local truePanelWidthTiles = panelWidthTiles + 2
    local panelWidth = quadSize * truePanelWidthTiles
   
    local differice = panelWidth - textSize
    local panelWidthOffset = math.floor(differice / 2)
    -- draw panel

    local currentX = x
    local currentY = y

    love.graphics.setColor(panel.color)

    -- top
    if state == 1 then
        love.graphics.draw(mainSprites, panel.quadsInactive[1], currentX, currentY, 0, uisize, uisize)
    elseif state == 2 then
        love.graphics.draw(mainSprites, panel.quadsActive[1], currentX, currentY, 0, uisize, uisize)
    elseif state == 3 then
        love.graphics.draw(mainSprites, panel.quadsClicked[1], currentX, currentY, 0, uisize, uisize)
    end
    
    currentX = currentX + quadSize 
        
    for i = 1, panelWidthTiles do
        if state == 1 then
            love.graphics.draw(mainSprites, panel.quadsInactive[2], currentX, currentY, 0, uisize, uisize)
        elseif state == 2 then
            love.graphics.draw(mainSprites, panel.quadsActive[2], currentX, currentY, 0, uisize, uisize)
        elseif state == 3 then
            love.graphics.draw(mainSprites, panel.quadsClicked[2], currentX, currentY, 0, uisize, uisize)
        end

        currentX = currentX + quadSize 
    end

    if state == 1 then
        love.graphics.draw(mainSprites, panel.quadsInactive[3], currentX, currentY, 0, uisize, uisize)
    elseif state == 2 then
        love.graphics.draw(mainSprites, panel.quadsActive[3], currentX, currentY, 0, uisize, uisize)
    elseif state == 3 then
        love.graphics.draw(mainSprites, panel.quadsClicked[3], currentX, currentY, 0, uisize, uisize)
    end
    currentY = currentY + quadSize
        
    currentX = x

    -- bottom
    if state == 1 then
        love.graphics.draw(mainSprites, panel.quadsInactive[4], currentX, currentY, 0, uisize, uisize)
    elseif state == 2 then
        love.graphics.draw(mainSprites, panel.quadsActive[4], currentX, currentY, 0, uisize, uisize)
    elseif state == 3 then
        love.graphics.draw(mainSprites, panel.quadsClicked[4], currentX, currentY, 0, uisize, uisize)
    end

    currentX = currentX + quadSize 

    for i = 1, panelWidthTiles do
        if state == 1 then
            love.graphics.draw(mainSprites, panel.quadsInactive[5], currentX, currentY, 0, uisize, uisize)
        elseif state == 2 then
            love.graphics.draw(mainSprites, panel.quadsActive[5], currentX, currentY, 0, uisize, uisize)
        elseif state == 3 then
            love.graphics.draw(mainSprites, panel.quadsClicked[5], currentX, currentY, 0, uisize, uisize)
        end

        currentX = currentX + quadSize        
    end

    if state == 1 then
        love.graphics.draw(mainSprites, panel.quadsInactive[6], currentX, currentY, 0, uisize, uisize)
    elseif state == 2 then
        love.graphics.draw(mainSprites, panel.quadsActive[6], currentX, currentY, 0, uisize, uisize)
    elseif state == 3 then
        love.graphics.draw(mainSprites, panel.quadsClicked[6], currentX, currentY, 0, uisize, uisize)
    end
    love.graphics.setColor(1, 1, 1)

    -- draw text
    if uisize == 1 then
        love.graphics.draw(panel.text1, x + panelWidthOffset, y)
    elseif uisize == 2 then
        love.graphics.draw(panel.text2, x + panelWidthOffset, y)
    elseif uisize == 3 then
        love.graphics.draw(panel.text3, x + panelWidthOffset, y)
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

return uiHelper