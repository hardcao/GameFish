local Fish = class("Fish")

local scheduler = cc.Director:getInstance():getScheduler()

function Fish:ctor(imageFilename, bugModel)
    self.m_bCaught = false
    self.m_nFishType = 1
    self.m_pGameLayer = nil
    self.m_pBatchNodeFish = nil
    self.m_bParticleBubble = false
end

function Fish:initWithFishType(fishType, gameLayer, pBatchNode)
    self.m_bCaught = false
    self.m_nFishType = fishType
    self.m_pGameLayer = gameLayer
    self.m_pBatchNodeFish = pBatchNode
    self.m_bParticleBubble = false

    if fishType == 11 or fishType == 12 then
           self.m_bParticleBubble = true;
    end

    local moreFrames = {}
    for i = 1,16 do
        local frame = cache:getSpriteFrame(string.format("fish%02d_%02d.png",i))
        moreFrames[i] = frame
    end
    local animMixed = cc.Animation:createWithSpriteFrames(moreFrames, 0.3)
    local animate = cc.Animate:create(animMixed)
   
    local swing = cc.RepeatForever:create( cc.Animate:create(animMixed))
    local originalFrameName = string.format("fish%02d_01.png",fishType)
    self.m_pSpriteFish = display.newSprite(originalFrameName)
    self.m_pSpriteFish:runAction(swing)
    self.m_pSpriteFish:align(display.CENTER,positionX,positionY)
    local moveto = self:getPath()
   -- local releaseFunc = cc.CallFunc:create(self:removeSelf)
    local sequence = cc.Sequence:create(moveto, releaseFunc)
    self.m_pSpriteFish:runAction(sequence)
    
    self.m_pGameLayer:getFishes():addObject(this)

    self.m_pBatchNodeFish:addChild(m_pSpriteFish)
    return true
end


function Fish:showCaught()


    self.m_bCaught = true;
    self.m_pSpriteFish:stopAllActions();
    
    if m_bParticleBubble and m_pParticleBubble then
        m_pParticleBubble:stopAllActions();
        m_pParticleBubble:setVisible(false);
    end
    
    local frames = {}

    for i = 1,4 do 
    

        local frameName = string.format("fish%02d_catch_%02d.png", m_nFishType ,i);
		local pFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName);
        
        frames[i] = frame
        
    end
   
    local animation = cc.Animation:createWithSpriteFrames(frames, 0.3)
    local animate = cc.Animate:create(animation);
    local function stopAction()
        self:removeSelf()
    end
    local callFunc = cc.CallFunc:create(stopAction)
    local sequence = cc.Sequence:create(animate, callFunc, NULL);
    self.m_pSpriteFish:runAction(sequence);
    
end

function Fish:offsetPoint(offsetX, offsetY)

    local pt = cc.p(0,0)
    pt.x = offsetX
    pt.y = offsetY
    return pt;

end

function Fish:getPath() 
    local fishSize = self.m_pSpriteFish:getContentSize()
    local windowSize = cc.Director:getInstance():getWinSize()
    local ptStart, ptEnd;
    local radius = MAX(fishSize.width, fishSize.height) / 2
    local flag = math.random() % 4
    if flag == 0  then
            ptStart.x = ptStart.x- radius;
            ptStart.y = math.random() % winSize.height;
          
            ptEnd.x = winSize.width + radius;
            ptEnd.y = math.random() % winSize.height;
           
    elseif  flag == 1 then

            ptStart.x = winSize.width + radius;
            ptStart.y = math.random() % winSize.height;
            ptEnd.x = - radius;
            ptEnd.y = math.random() % winSize.height;
           
     elseif  flag == 2 then
         
            ptStart.x = math.random() % winSize.width;
            ptStart.y = ptStart.y- radius;
         
            ptEnd.x = math.random() % winSize.width;
            ptEnd.y = winSize.height + radius;
            
    elseif  flag == 3 then
           
            ptStart.x =  math.random() % winSize.width;
            ptStart.y = winSize.height + radius;
          
            ptEnd.x = math.random() %winSize.width;
            ptEnd.y = ptEnd.y - radius;
            
     end
            
    

    local angle = math.atan2(ptEnd.y - ptStart.y, ptEnd.x - ptStart.x);

    local rotation = 180.0 - angle * 180.0 / M_PI;
    

    local duration = math.random() % 4 % 10 + 4.0;
   
    m_pSpriteFish:setPosition(ptStart);
    m_pSpriteFish:setRotation(rotation);

    local moveto = cc.MoveBy:create(duration, ptEnd);

    if m_bParticleBubble then
    
        self.m_bParticleBubble =cc.ParticleSystemQuad:create("bubble.plist")
        self.m_pGameLayer:addChild(m_pParticleBubble);
        local x = 1
        local w = self.m_pSpriteFish:getContentSize().width / 2.0;
        self:offsetPoint(ptStart, math.cos(angle) * w, math.sin(angle) * w);
        self.m_pParticleBubble:setPosition(ptStart);
        self:offsetPoint(ptEnd, math.cos(angle) * w, math.sin(angle) * w);
        local act = cc.MoveTo:create(moveto:getDuration(), ptEnd);
        self.m_pParticleBubble:setAutoRemoveOnFinish(false);
        self.m_pParticleBubble:setPositionType(kCCPositionTypeFree);
        self.m_pParticleBubble:runAction(act);
    end

    return moveto
    
end


function Fish:removeSelf()

    self.m_pGameLayer:getFishes():removeObject(self); 
    self.m_pSpriteFish:removeFromParentAndCleanup(true);

    if m_bParticleBubble and m_pParticleBubble then
       self.m_pParticleBubble:removeFromParentAndCleanup(true);
    end

end

return Fish