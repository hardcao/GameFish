
local MainScene = class("MainScene", cc.load("mvc").ViewBase)


function MainScene:onCreate()
    -- add background image
    
    local cache = cc.SpriteFrameCache:getInstance()
    local filename = "fish3"
   
    cache:addSpriteFrames("fish3.plist", "fish3.png")

   local sprite = display.newSprite("#bk_01.png")
    sprite:align(display.CENTER,20,display.cy)
    sprite:addTo(self)
    sprite:setScale(2)

    --local animFrames = {}
    --for i = 1,14 do 
      --  local frame = cache:getSpriteFrame( string.format("bk_%02d.png", i) )
      --  animFrames[i] = frame
   -- end
  --  local animation = display.newAnimation(animFrames, 0.3)
        -- caching animation
   --   self:playAnimationForever(display.getAnimationCache(self.animationName_))
    
end

return MainScene
