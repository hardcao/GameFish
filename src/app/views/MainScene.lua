
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local DeadBugSprite = import(".FishSprite")
MainScene.RESOURCE_FILENAME = "battleScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))
    local cache = cc.SpriteFrameCache:getInstance()
    local filename = "fish3"
   
    cache:addSpriteFrames("fish3.plist", "fish3.png")

   local sprite = display.newSprite("#bk_01.png")
 

    local moreFrames = {}
    for i = 1,14 do
        local frame = cache:getSpriteFrame(string.format("bk_%02d.png",i))
        moreFrames[i] = frame
    end

    
    local animMixed = cc.Animation:createWithSpriteFrames(moreFrames, 0.3)
     sprite:align(display.CENTER,display.cx,display.cy)
    sprite:addTo(self)
  
    sprite:runAction(cc.RepeatForever:create( cc.Animate:create(animMixed) ) )
   -- self:addChild(sprite)

   
end

function MainScene:createLabel()
 cc.Label:createWithSystemFont("test", "Marker Felt.ttf", 96)
    :align(display.CENTER, display.cx, display.cy)
    :addTo(self)

end
function MainScene:onEnter()
end
 
function MainScene:onExit()
end

return MainScene
