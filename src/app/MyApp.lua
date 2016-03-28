
local MyApp = class("MyApp", cc.load("mvc").AppBase)

function MyApp:onCreate()
     local cache = cc.SpriteFrameCache:getInstance()
    local filename = "fish3"
   
    cache:addSpriteFrames("fish3.plist", "fish3.png")

   

    local animFrames = {}
    for i = 1,14 do 
        local frame = cache:getSpriteFrame( string.format("bk_%02d.png", i) )
        animFrames[i] = frame
    end
    local animation = display.newAnimation(animFrames, 0.3)
        -- caching animation
    display.setAnimationCache(filename, animation)
end

return MyApp
