local Bullet = class("Bullet")

local scheduler = cc.Director:getInstance():getScheduler()

function Bullet:ctor(imageFilename, bugModel)
    self.m_bCaught = false;
    self.m_nBulletType= nil
    self.m_pGameLayer = nil
    self.m_pSpriteNet = nil
end

function Bullet:initWithBulletType(bulletType, gameLayer, pBatchNodeBullet, pBatchNodeNet)

    self.m_bCaught = false;
    self.m_nBulletType= bulletType
    self.m_pGameLayer = gameLayer
    local bulletName =  string.format("bullet0%d.png",m_nBulletType)
    self.m_pSpriteBullet=display.newSprite(bulletName)
    m_pSpriteBullet:align(520, 50);
    spBatchNodeBullet:addChild(m_pSpriteBullet);

    local nodenetName = string.format("net0%d.png", m_nBulletType); 
    self.m_pSpriteNet =display.newSprite(nodenetName)
    self.m_pSpriteNet:setVisible(false);
    pBatchNodeNet:addChild(m_pSpriteNet);
    
    self.m_pGameLayer:getBullets():addObject(this);    
    return true;
     
end

function Bullet:shootTo(targetDirection)

    local ptFrom = self.m_pSpriteBullet:getPosition();
    local ptTo = targetDirection;
    local angle = math.atan(ptTo.y - ptFrom.y, ptTo.x - ptFrom.x);
    local rotation = angle / M_PI * 180.0;
    self.m_pSpriteBullet:setRotation(90.0 - rotation);
    
	local size = cc.Director:getInstance():getWinSize(); 
    local distance = 0
    if size.width > size.height then 
        distance = size.width
    else 
        distance = size.height
    end

    local function removeSelf1()
        self:removeSelf()
    end
   
    local targetPt = cc.p(ptFrom.x + distance * math.cos(angle), ptFrom.y + distance * math.sin(angle));
    local moveto = cc.MoveTo:create(1.0, targetPt);
    local callFunc = cc.CallFunc:create(removeSelf1)
    local sequence = cc.Sequence:create(moveto, callFunc, NULL);
    self.m_pSpriteBullet:runAction(sequence);
end

function Bullet:showNet()

    self.m_bCaught = true;
    self.m_pSpriteBullet:stopAllActions();
    self.m_pSpriteBullet:setVisible(false);
    self.m_pSpriteNet:setVisible(true);
     
    local scale = cc.ScaleTo:create(0.3, 1.25);
    local function removeSelf1()
        self:removeSelf()
    end
    local callFunc = cc.CallFunc:create(removeSelf1)
    local sequence = cc.Sequence:create(scale, callFunc, NULL);
    self.m_pSpriteNet:runAction(sequence);
    self.m_pSpriteNet:setPosition(self.m_pSpriteBullet:getPosition());
    
    local particle = cc.ParticleSystemQuad:create("netparticle.plist");
    particle:setPosition(self.m_pSpriteNet:getPosition());
    particle:setPositionType(kCCPositionTypeGrouped);
    particle:setAutoRemoveOnFinish(true);
    self.m_pGameLayer:addChild(particle, 100);

end

function Bullet:removeSelf()

   
    self.m_pGameLayer:getBullets():removeObject(self);
    self.m_pSpriteBullet:removeFromParentAndCleanup(true);
    self.m_pSpriteNet:removeFromParentAndCleanup(true);
end

return Bullet