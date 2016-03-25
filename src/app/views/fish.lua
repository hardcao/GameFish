local Fish = class("Fish")

function Fish::createWithFishType(fishType, gameLayer, pBatchNode)
{
    
    if(self:initWithFishType(fishType, gameLayer, pBatchNode) )
    {
        
        return self;
    }
    else
    {
        delete self;
        return NULL;
    }
}

function Fish:initWithFishType(fishType, gameLayer, pBatchNode)
    self.m_bCaught = false
    self.m_nFishType = fishType
    self.m_pGameLayer = gameLayer
    self.m_pBatchNodeFish = pBatchNode
    self.m_bParticleBubble = false

    if m_nFishType == 11 || m_nFishType == 12 then
           m_bParticleBubble = true;
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
    local m_pSpriteFish = display.newSprite(originalFrameName)
    m_pSpriteFish:runAction(swing)
    m_pSpriteFish:align(display.CENTER,positionX,positionY)
    MoveTo *moveto = self:getPath()
    

    local releaseFunc = cc.CCCallFunc:create(self, callfunc_selector(self:removeSelf));
    local sequence = cc.Sequence:create(moveto, releaseFunc, NULL);
    m_pSpriteFish:runAction(sequence);
    
    self:getGameLayer():getFishes():addObject(this);

    this:getBatchNodeFish():addChild(m_pSpriteFish);
    return true
end




function Fish:initWithFishType(fishType, gameLayer, pBatchNode)
{
    m_bCaught = false; 
    this->setFishType(fishType);
    this->setGameLayer(gameLayer);
    this->setBatchNodeFish(pBatchNode);
    m_bParticleBubble = false;
    
    if(m_nFishType == 11 || m_nFishType == 12)
        m_bParticleBubble = true;
    
    local frames = {};
    for(int i = 1; i <= 16; i++)
    {

        String *frameName = cocos2d::String::createWithFormat("fish%02d_%02d.png", fishType, i);

		SpriteFrame *pFrame = cocos2d::SpriteFrameCache::getInstance()->spriteFrameByName(frameName->getCString());
        if(pFrame) {            
            frames->addObject(pFrame);
        }
    }

    Animation *animation = cocos2d::Animation::createWithSpriteFrames(frames, 0.2f);
    animation->setRestoreOriginalFrame(false);
    Animate *animate = Animate::create(animation);

    Action *swing = RepeatForever::create(animate);
    
    String *originalFrameName = String::createWithFormat("fish%02d_01.png", fishType);
    m_pSpriteFish = Sprite::createWithSpriteFrameName(originalFrameName->getCString());

	m_pSpriteFish->runAction(swing); 


    m_pSpriteFish->setAnchorPoint(ccp(0.5f, 0.5f));
	
    MoveTo *moveto = NULL;

    this->getPath(moveto);

	FiniteTimeAction *releaseFunc = CCCallFunc::create(this, callfunc_selector(Fish::removeSelf));
    FiniteTimeAction *sequence = Sequence::create(moveto, releaseFunc, NULL);
    m_pSpriteFish->runAction(sequence);
    
    this->getGameLayer()->getFishes()->addObject(this);

    this->getBatchNodeFish()->addChild(m_pSpriteFish);
    
    return true;
}


function Fish:showCaught()
{

    m_bCaught = true;
    m_pSpriteFish:stopAllActions();
    
    if m_bParticleBubble && m_pParticleBubble then
        m_pParticleBubble:stopAllActions();
        m_pParticleBubble:setVisible(false);
    end
    
    lcoal frames = {};

    for(int i = 1; i <= 4; i++) 
    {

        local frameName = string.format("fish%02d_catch_%02d.png", m_nFishType ,i);
		local *pFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName);
        
        frames[i] = frame
        
    }
   
    local animation = cc.Animation:createWithSpriteFrames(frames, 0.3f);
    local animate = cc.Animate:create(animation);

    local callFunc = cc.CCCallFunc:create(this, callfunc_selector(Fish::removeSelf));
    local sequence = cc.Sequence:create(animate, callFunc, NULL);
    m_pSpriteFish:runAction(sequence);
    
}

function Fish:offsetPoint(float offsetX, float offsetY)
{
    local pt;
    pt.x += offsetX;
    pt.y += offsetY;
    return pt;
}

function Fish:getPath() {
    local fishSize = m_pSpriteFish:getContentSize()
    local windowSize = cc.Director:getInstance():getWinSize()
    local ptStart, ptEnd;
    local radius = MAX(fishSize.width, fishSize.height) / 2
    switch (math.random() % 4) {
          
        case 0:
            ptStart.x = - radius;
            ptStart.y = rand() % (int)winSize.height;
          
            ptEnd.x = winSize.width + radius;
            ptEnd.y = rand() % (int)winSize.height;
            break;
        case 1:

            ptStart.x = winSize.width + radius;
            ptStart.y = rand() % (int)winSize.height;
            ptEnd.x = - radius;
            ptEnd.y = rand() % (int)winSize.height;
            break;
        case 2:
         
            ptStart.x = rand() % (int)winSize.width;
            ptStart.y = - radius;
         
            ptEnd.x = rand() % (int)winSize.width;
            ptEnd.y = winSize.height + radius;
            break;
        case 3:
           
            ptStart.x = rand() % (int)winSize.width;
            ptStart.y = winSize.height + radius;
          
            ptEnd.x = rand() % (int)winSize.width;
            ptEnd.y = - radius;
            break;
        default:
            break;
    }

    local angle = atan2f(ptEnd.y - ptStart.y, ptEnd.x - ptStart.x);

    local rotation = 180.0f - angle * 180.0f / M_PI;
    

    local duration = math.random() % 4 % 10 + 4.0f;
   
    m_pSpriteFish:setPosition(ptStart);
    m_pSpriteFish:setRotation(rotation);

    local moveto = cc.MoveTo::create(duration, ptEnd);

    if m_bParticleBubble then
    
        self:setParticleBubble(cc.ParticleSystemQuad::create("bubble.plist"));
        m_pGameLayer:addChild(m_pParticleBubble);
        float w = m_pSpriteFish:getContentSize().width / 2.0f;
        self:offsetPoint(ptStart, cosf(angle) * w, sinf(angle) * w);
        m_pParticleBubble->setPosition(ptStart);
        self:offsetPoint(ptEnd, cosf(angle) * w, sinf(angle) * w);
        lcoal act = cc.MoveTo:create(moveto:getDuration(), ptEnd);
        m_pParticleBubble:setAutoRemoveOnFinish(false);
        m_pParticleBubble:setPositionType(kCCPositionTypeFree);
        m_pParticleBubble:runAction(act);
    end

    return moveto
    
}


function Fish:removeSelf()
{
    self:getGameLayer():getFishes():removeObject(this); 
    m_pSpriteFish:removeFromParentAndCleanup(true);

    if m_bParticleBubble && m_pParticleBubble then
       m_pParticleBubble:removeFromParentAndCleanup(true);
    end
}

return Fish