animater = {}

function animater.new(quads, frameTime)
    local newAni = {} 

    newAni.quads = quads
    newAni.frameTime = frameTime
    newAni.timeCount = 0
    newAni.frameNumber = 1
    newAni.currentFrame = quads[1]
    newAni.active = true

    return newAni
end

function animater.update(tables, dt)
    for i, ani in pairs(tables) do
        if ani.active == true then
            ani.timeCount = ani.timeCount + dt
            print(ani.timeCount)
            
            if ani.timeCount > ani.frameTime then
                ani.timeCount = 0
                ani.frameNumber = ani.frameNumber + 1

                if ani.frameNumber > #ani.quads then
                    ani.frameNumber = 1
                end

                ani.currentFrame = ani.quads[ani.frameNumber]
            end

        end
    end
end

return animater