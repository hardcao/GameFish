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
        self.m_pSpriteBullet= gameLayer
        local bulletName =  string.format("bullet0%d.png",m_nBulletType)
        self:setSpriteBullet(display.newSprite(bulletName))
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
    Point ptFrom = self:m_pSpriteBullet:getPosition();
    Point ptTo = targetDirection;
    float angle = atan2f(ptTo.y - ptFrom.y, ptTo.x - ptFrom.x);
    float rotation = angle / M_PI * 180.0f;
    m_pSpriteBullet->setRotation(90.0f - rotation);
    
	Size size = Director::getInstance()->getWinSize(); 
    
    float distance =MAX(size.width, size.height); 
    Point targetPt = ccp(ptFrom.x + distance * cosf(angle), ptFrom.y + distance * sinf(angle));
    FiniteTimeAction *moveto = MoveTo::create(1.0f, targetPt);
    FiniteTimeAction *callFunc = CCCallFunc::create(this, callfunc_selector(Bullet::removeSelf));
    FiniteTimeAction *sequence = Sequence::create(moveto, callFunc, NULL);
    m_pSpriteBullet->runAction(sequence);
}

void Bullet::showNet()
{
    m_bCaught = true;
    m_pSpriteBullet->stopAllActions();
    m_pSpriteBullet->setVisible(false);
    m_pSpriteNet->setVisible(true);
     
    ScaleTo *scale = ScaleTo::create(0.3f, 1.25f);
    FiniteTimeAction *callFunc = CCCallFunc::create(this, callfunc_selector(Bullet::removeSelf));
    FiniteTimeAction *sequence = Sequence::create(scale, callFunc, NULL);
    m_pSpriteNet->runAction(sequence);
    m_pSpriteNet->setPosition(m_pSpriteBullet->getPosition());
    
    ParticleSystem *particle = ParticleSystemQuad::create("netparticle.plist");
    particle->setPosition(m_pSpriteNet->getPosition());
    particle->setPositionType(kCCPositionTypeGrouped);
    particle->setAutoRemoveOnFinish(true);
    m_pGameLayer->addChild(particle, 100);

}

void Bullet::removeSelf()
{
    CCLOG("remove bullet");
    this->getGameLayer()->getBullets()->removeObject(this);
    m_pSpriteBullet->removeFromParentAndCleanup(true);
    m_pSpriteNet->removeFromParentAndCleanup(true);
}

return Bullet