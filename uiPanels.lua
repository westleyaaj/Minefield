uiPanels = {}

function uiPanels.openEndBanner(time, goal)
    bannerTween = tween.new(0.2, animationOffset, {0}, 'inSine')

    displayedTime = time
    displayedGoal = goal

    endBannerActive = true    
end

function uiPanels.drawEndBanner()
    love.graphics.setColor(colorIndex.timer)
    love.graphics.rectangle("fill", 0, height - 100 + animationOffset[1], width, 100 )

    love.graphics.setColor(1,1,1)

    local title = love.graphics.newText( fontSize2, {colorIndex.text, "Area Compleate"} )
    love.graphics.draw(title, 40, height - 60 + animationOffset[1] - title:getHeight() / 2)

    if displayedGoal > displayedTime then
        local subTitle = love.graphics.newText( fontSize1, {colorIndex.text, "Goal Reached   " .. "Goal Time:" .. formatTime(displayedGoal) .. " Your Time:" .. formatTime(displayedTime) } )
        love.graphics.draw(subTitle, 40, height - 15 + animationOffset[1] - title:getHeight() / 2)
    else
        local subTitle = love.graphics.newText( fontSize1, {colorIndex.text, "Goal Failed   " .. "Goal Time:" .. formatTime(displayedGoal) .. " Your Time:" .. formatTime(displayedTime) } )
        love.graphics.draw(subTitle, 40, height - 15 + animationOffset[1] - title:getHeight() / 2)
    end

    -- button logic
    if endBannerState == 1 then
        endBannerExitButtonState = 2
        endBannerRetryButtonState = 1
    elseif endBannerState == 2 then
        endBannerExitButtonState = 1
        endBannerRetryButtonState = 2
    end

end

function uiPanels.init()
    -- End Banner

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

    endBannerExitButton = uiHelper.makeButton(buttonQuadsInactive, buttonQuadsActive, buttonQuadsClicked, "Next →", colorIndex.name)
    endBannerExitButtonState = 2
    endBannerRetryButton = uiHelper.makeButton(buttonQuadsInactive, buttonQuadsActive, buttonQuadsClicked, "Retry ↙", colorIndex.name)
    endBannerRetryButtonState = 1



    animationOffset = {100} -- make scale
    bannerTween = nil
    displayedTime = nil
    displayedGoal = nil

    endBannerState = 1

    endBannerActive = false
    
    
end

function uiPanels.keypressed(key)
    if endBannerActive then
        print("aaaaaaaaaaaaaaaa")
        if key == "left" then
            if endBannerState == 1 then
                endBannerState = 2
            else
                endBannerState = 1
            end
        end
        if key == "right" then
            if endBannerState == 1 then
                endBannerState = 2
            else
                endBannerState = 1
            end
        end
    end
    
end

function uiPanels.draw()
    if endBannerActive then
        uiPanels.drawEndBanner()
        uiHelper.drawbutton(endBannerExitButton, setUiSize, width - 280, height - 65 + animationOffset[1], endBannerExitButtonState)
        uiHelper.drawbutton(endBannerRetryButton, setUiSize, width - 150, height - 65 + animationOffset[1], endBannerRetryButtonState)
    end
    
end

function uiPanels.update(dt)
    if bannerTween then
        bannerTween:update(dt)
        print(animationOffset[1])
    end  
end

return uiPanels