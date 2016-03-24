local Bullet = class("Bullet")

function Bullet:createWithBulletType(bulletType, gameLayer, pBatchNodeBullet, pBatchNodeNet)
{
    Bullet *pBullet = new Bullet();
    if(pBullet && pBullet->initWithBulletType(bulletType, gameLayer, pBatchNodeBullet, pBatchNodeNet))
    {
        pBullet->autorelease();
        return pBullet;
    }
    else
    {
        CC_SAFE_DELETE(pBullet);
        return NULL;
    }
}

function Bullet:initWithBulletType(bulletType, gameLayer, pBatchNodeBullet, pBatchNodeNet)
{
        self.m_bCaught = false;
        self.m_nBulletType= bulletType
        self.m_pGameLayer = gameLayer
        local bulletName =  string.format("bullet0%d.png",m_nBulletType)
        self:m_pSpriteBullet=display.newSprite(bulletName)
        m_pSpriteBullet:align(520, 50);
        pBatchNodeBullet:addChild(m_pSpriteBullet);

        local nodenetName = string.format("net0%d.png", m_nBulletType); 
        self:setSpriteNet(display.newSprite(nodenetName->getCString))
        m_pSpriteNet:setVisible(false);
        pBatchNodeNet:addChild(m_pSpriteNet);
    
        m_pGameLayer:getBullets():addObject(this);    
        return true;
     
}

function Bullet:shootTo(targetDirection)
{
    local ptFrom = self:m_pSpriteBullet:getPosition();
    local ptTo = targetDirection;
    local angle = atan2f(ptTo.y - ptFrom.y, ptTo.x - ptFrom.x);
    local rotation = angle / M_PI * 180.0f;
    m_pSpriteBullet:setRotation(90.0f - rotation);
    
	local size = cc.Director:getInstance():getWinSize(); 
    
    local distance =MAX(size.width, size.height); 
    local targetPt = cc.p(ptFrom.x + distance * cosf(angle), ptFrom.y + distance * sinf(angle));
    local moveto = cc.MoveTo:create(1.0f, targetPt);
    local callFunc = cc.CCCallFunc:create(this, callfunc_selector(Bullet:removeSelf));
    local sequence = cc.Sequence:create(moveto, callFunc, NULL);
    m_pSpriteBullet:runAction(sequence);
}

function Bullet:showNet()
{
    self.m_bCaught = true;
    self.m_pSpriteBullet:stopAllActions();
    self.m_pSpriteBullet:setVisible(false);
    self.m_pSpriteNet:setVisible(true);
     
    local scale = cc.ScaleTo:create(0.3f, 1.25f);
    local sequence = cc.Sequence::create(scale, cc.CallFunc:create(Bullet::removeSelf)), NULL);
    m_pSpriteNet:runAction(sequence);
    m_pSpriteNet:setPosition(m_pSpriteBullet->getPosition());
    
    local particle = cc.ParticleSystemQuad:create("netparticle.plist");
    particle:setPosition(m_pSpriteNet->getPosition());
    particle:setPositionType(kCCPositionTypeGrouped);
    particle:setAutoRemoveOnFinish(true);
    m_pGameLayer:addChild(particle, 100);

}

function Bullet:removeSelf()
{
   
    self.m_pGameLayer:getBullets():removeObject(this);
     self.m_pSpriteBullet:removeFromParentAndCleanup(true);
    self.m_pSpriteNet:removeFromParentAndCleanup(true);
}

return Bullet