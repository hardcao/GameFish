local Cannon = class("Cannon")
function Cannon:createWithCannonType(cannonType, pGameLayer, pBatchNode){
   self.m_pGameLayer = pGameLayer
   self.m_nCannonType = cannonType
   self.m_fRotation = 0;
    
	if self:initWithCannonType(pBatchNode) then
        return self
    end
}
end



function Cannon:getConnonType()

    return  self.m_nCannonType

end

function Cannon:initWithCannonType( pBatchNode)

    
    local cannonName= string.format("actor_cannon1_%d1.png",m_nCannonType);
    self.m_pSprite=display.newSprite(cannonName); 

    self.m_pSprite:setPosition(cc.p(520, 50));

    pBatchNode:addChild(m_pSprite);
    return true;
end

function Cannon:rotateToPoint(ptToX, ptToY)
{
    local ptNowX,ptNowY =self.m_pSprite:getPosition();
    local angle=Math:atan2f(ptToY-ptNowY,ptNowX-ptNowX)/3.14 * 180.0f;
    self:setRotation(90.0f-angle);
    self.m_pDirection= ptTo;
}
end

function Cannon:setRotation(rotation)
{
	self.m_fRotation=rotation;
	local absf_rotation=fabsf(m_fRotation-self.m_pSprite:getRotation());
    local duration=absf_rotation/180.0f*0.2f;

    local pAction = cc.RotateTo:create(duration, m_fRotation);
    self.m_pSprite:runAction(pAction);
}
end
function Cannon:fire()


    local pFireStartFrameName=string.format("actor_cannon1_%d1.png",this->m_nCannonType);
    local pFireEndFrameName=string.format("actor_cannon1_%d2.png",this->m_nCannonType);
	local pFireStartFrame=cc.SpriteFrameCache:getInstance():getSpriteFrame(pFireStartFrameName);
    local FireEndFrame=SpriteFrameCache::getInstance()->spriteFrameByName(pFireEndFrameName->getCString());
    local frames = {pFireStartFrame,FireEndFrame}
	local pAnimationFire=cc.Animation:createWithSpriteFrames(frames,0.1f);
    pAnimationFire:setRestoreOriginalFrame(true);
    local pAction=cc.CCAnimate:create(pAnimationFire);
    self.m_pSprite:runAction(pAction);
    
    local pBullet = Bullet:createWithBulletType(m_nCannonType, self.m_pGameLayer, self.m_pGameLayer:getBatchNodeFish2AndBullets(), sm_pGameLayer:getBatchNodeFish3AndNets());
    pBullet->shootTo(this->m_pDirection);


end

return Cannon