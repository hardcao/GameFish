
local FishSprite = class("FishSprite", function(imageFilename, plistFileName, startImageName, stringFormat, startFrameIndex,endFameIndex, positionX,positionY)
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
    sprite:runAction(cc.RepeatForever:create( cc.Animate:create(animMixed) ) )
    sprite:align(display.CENTER,positionX,positionY)
    return sprite;
end)

function FishSprite:ctor(imageFilename, fishModel)
    self.model = fishModel
end

function FishSprite:getModel()
    return self.model
end

function FishSprite:start(destination)
    self.model:setDestination(destination)
    self:updatePosition()
    return self
end

function FishSprite:step(dt)
    self.model:step(dt)
    self:updatePosition()
    return self
end

function FishSprite:updatePosition()
    self:move(self.model:getPosition())
        :rotate(self.model:getRotation())
end

return FishSprite
