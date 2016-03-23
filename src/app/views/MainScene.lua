
local MainScene = class("MainScene", cc.load("mvc").ViewBase)
local FishSprite = import(".FishSprite")
MainScene.RESOURCE_FILENAME = "battleScene.csb"

function MainScene:onCreate()
    printf("resource node = %s", tostring(self:getResourceNode()))

     local sprite = FishSprite:create("fish3.png", "fish3.plist", "#bk_01.png", "bk_%02d.png", 1, 14, display.cx, display.cy)
     
    --sprite:align(display.CENTER,positionX,positionY)
    sprite:addTo(self)
  
    --sprite:runAction(cc.RepeatForever:create( cc.Animate:create(animMixed) ) )
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
