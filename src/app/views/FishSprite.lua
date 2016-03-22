
local FishSprite = class("FishSprite", function(imageFilename, plistFileName, startImageName, stringFormat, startFrameIndex,endFameIndex)
    local cache = cc.SpriteFrameCache:getInstance()
    local filename = "fish3"
   
    cache:addSpriteFrames(plistFileName, imageFilename)

   local sprite = display.newSprite(startImageName)
 

    local moreFrames = {}
    for i = startFrameIndex,endFameIndex do
        local frame = cache:getSpriteFrame(string.format(stringFormat,i))
        moreFrames[i] = frame
    end

    
    local animMixed = cc.Animation:createWithSpriteFrames(moreFrames, 0.3)
    sprite:align(display.CENTER,display.cx,display.cy)
    return sprite;
end)

function FishSprite:setPosition(positionX, positionY)
    self.align(display.CENTER,positionX,positionY)
end

return FishSprite
