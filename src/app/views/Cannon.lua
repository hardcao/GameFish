local Cannon = class("Cannon")
function Cannon:createWithCannonType(cannonType, pGameLayer, pBatchNode)
   self.m_pGameLayer = pGameLayer
   self.m_nCannonType = cannonType
   self.m_fRotation = 0;
    
	if self:initWithCannonType(pBatchNode) then
        return self
    end

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

    local ptNowX,ptNowY =self.m_pSprite:getPosition();
    local angle=Math:atan2f(ptToY-ptNowY,ptNowX-ptNowX)/3.14 * 180.0;
    self:setRotation(90.0-angle);
    self.m_pDirection= ptTo;

end

function Cannon:setRotation(rotation)

	self.m_fRotation=rotation;
	local absf_rotation=math.abs(m_fRotation-self.m_pSprite:getRotation());
    local duration=absf_rotation/180.0*0.2;

    local pAction = cc.RotateTo:create(duration, m_fRotation);
    self.m_pSprite:runAction(pAction);

end
function Cannon:fire()


    local pFireStartFrameName=string.format("actor_cannon1_%d1.png",self.m_nCannonType);
    local pFireEndFrameName=string.format("actor_cannon1_%d2.png",self.m_nCannonType);
	local pFireStartFrame=cc.SpriteFrameCache:getInstance():getSpriteFrame(pFireStartFrameName);
    local FireEndFrame=cc.SpriteFrameCache:getInstance():spriteFrameByName(pFireEndFrameName);
    local frames = {pFireStartFrame,FireEndFrame}
	local pAnimationFire=cc.Animation:createWithSpriteFrames(frames,0.1);
    pAnimationFire:setRestoreOriginalFrame(true);
    local pAction=cc.CCAnimate:create(pAnimationFire);
    self.m_pSprite:runAction(pAction);
    
    local pBullet = Bullet:createWithBulletType(self.m_nCannonType, self.m_pGameLayer, self.m_pGameLayer:getBatchNodeFish2AndBullets(), self.m_pGameLayer:getBatchNodeFish3AndNets());
    self.pBullet:shootTo(self.m_pDirection);


end

return Cannon