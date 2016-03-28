local GameLayer = class("GameLayer")
local Cannon = import(".Cannon")
local Fish = import(".Fish")

local FishInBatchNode1 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14};

local FishInBatchNode2 = {10, 18};

// 这两种鱼的被捕获到后的帧图与游动帧图被分割到了两个不同的大图中分别fish2.png与fish3.png，
// 导致在鱼儿被捕时播放Fish::showCaught()时在其m_pBatchNodeFish3AndNets中找不到对应的被捕帧图而抛出异常。

//const int FishInBatchNode3 = {16, 17};

local FishInBatchNode4 = {11, 12};

local scheduler = cc.Director:getInstance():getScheduler()
local updateFish_updateFish = nil
local updateFish_updateGame = nil
local MAX_FISH_COUNT = 15

GameLayer::GameLayer():m_pBullets(NULL),m_pFishes(NULL),/*m_pRollNumGroup(NULL),*/
	m_nScore(0),m_pCannon(NULL),m_pSpriteAdd(NULL){
    
}

function GameLayer:ctor()
    self.m_pBullets = nil
    self.m_pFishes = nil
    self.m_nScore = 0
    self.m_pCannon = nil
    self.m_pSpriteAdd = nil
    self.m_pRollNumGroup = nil
end

function GameLayer:init(){
    this:setTouchEnabled(true);
    this:initFrames();
    this:initBackground();
	this:initListeners();
    this:initFishes();
    this:initCannon();
    updateFish_updateFish = scheduler:scheduleScriptFunc(self:updateFish, 1.0)
    updateFish_updateGame = scheduler:scheduleScriptFunc(self:updateFish, 1.0)
    return true;
}

function GameLayer:initListeners()


     local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = ret:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


function GameLayer:initFrames(){
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish2.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish3.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish4.plist"); 
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("cannon.plist");
end

function GameLayer:initBackground(){
    local texture=cc.Director:getInstance():getTextureCache():addImage("bj01.jpg");
    local pBackGround =  cc.Sprite:createWithTexture(batchNode:getTexture())

    pBackGround:setAnchorPoint(Point(0.5f, 0.5f));
    local winSize=cc.director:sharedDirector():getWinSize();
    pBackGround:setPosition(cc.p(winSize.width/2, winSize.height/2));
    self:addChild(pBackGround);
    
    texture=cc.Director:getInstance():getTextureCache():addImage("ui_box_01.png");
    local pTopBar=cc.Sprite:createWithTexture(texture);
    pTopBar:setPosition(cc.p(500, 580));
	
    self:addChild(pTopBar,100);
    
    texture=cc.Director:getInstance():getTextureCache():addImage("ui_box_02.png");
    local pBottomBar=cc.Sprite:createWithTexture(texture);
    pBottomBar:setPosition(Point(440, 90));
    self:addChild(pBottomBar,100);

	self:setRollNumGroup(RollNumGroup:createWithGameLayer(this, 6));
    m_pRollNumGroup:setPosition(Point(353, 21));    
end

function GameLayer:initFishes(){

	local texture = cc.Director:getInstance():getTextureCache():addImage("fish.png");
    this.setBatchNodeFish1(cc.Sprite:createWithTexture(texture));
    this:addChild(this->m_pBatchNodeFish1); 
    
    texture = cc.Director:getInstance():getTextureCache():addImage("fish2.png");
    self.m_pBatchNodeFish2AndBullets=cc.Sprite:createWithTexture(texture);
    self:addChild(self.m_pBatchNodeFish2AndBullets);
    
    texture = cc.Director:getInstance():getTextureCache():addImage("fish3.png");
    self:m_pBatchNodeFish3AndNets=SpriteBatchNode::createWithTexture(texture);
    self:addChild(self.m_pBatchNodeFish3AndNets);
    
     
    this->setFishes(Array::createWithCapacity(MAX_FISH_COUNT));
    m_pFishes:removeAllObjects();


end

function GameLayer:initCannon()

    self.m_Bullets = {};
    Texture2D *ptexture=cc.Director:getInstance():getTextureCache():addImage("cannon.png");
    local pBatchNode=cc.SpriteBatchNode:create(ptexture);
    self:addChild(pBatchNode,101,7);
    self.m_Cannon= Cannon:createWithCannonType(6, self, self.pBatchNode);
    
    self.m_pSpriteAdd=cc.Sprite:createWithSpriteFrameName("button_add.png");
    self.m_pSpriteAdd:setPosition(cc.p(585,28));
    self.m_pSpriteAdd:setScale(1.5f);
    self.addChild(self.m_pSpriteAdd,101);
    
    Texture2D *texture2dReduce= TextureCache::getInstance()->addImage("button_reduce.png");
    SpriteFrame *spriteFrameReduceNormal=SpriteFrame::createWithTexture(texture2dReduce, Rect(0, 0, texture2dReduce->getContentSize().width/2, texture2dReduce->getContentSize().height));
    self.m_pSpriteReduce=cc.Sprite:createWithSpriteFrameName("button_reduce.png");
    self.m_pSpriteReduce:setPosition(cc.p(450,28));
    self.m_pSpriteReduce:setScale(1.5f);
    self:addChild(self.m_pSpriteReduce,101);
end

function GameLayer:addConnonSize()
    local curConnonType=self.m_pCannon:getConnonType();
    if(++curConnonType>7){
        curConnonType=1;
    }
   -- CC_SAFE_DELETE(this->m_pCannon);
    self.m_Cannon =Cannon:createWithCannonType(curConnonType, self, self:getChildByTag(7)));

end
function GameLayer:reduceConnonSize()
    local curConnonType=self.m_pCannon:getConnonType();
    if(--curConnonType<1){
        curConnonType=7;
    }
    --CC_SAFE_DELETE(this->m_pCannon);
    self.m_Cannon =Cannon:createWithCannonType(curConnonType, self, self:getChildByTag(7)));
end

function GameLayer:onTouchBegan(pTouch, pEvent)

	local rect = this.m_pSpriteAdd:getBoundingBox()
    if  cc.rectContainsPoint(rect, pTouch:getLocation()) then
        self:addConnonSize();
		return false;
    end

    local rect = this.m_pSpriteReduce:getBoundingBox()
    if  cc.rectContainsPoint(rect, pTouch:getLocation()) then
        self:reduceConnonSize();
        return false;
    end
  
    this.m_pCannon:rotateToPoint(pt);
	return true;

end

function GameLayer:onTouchMoved(pTouch, pEvent) 
{
	local pt = pTouch:getLocation()
	this.m_pCannon:rotateToPoint(pt);
}
end		
function GameLayer:onTouchEnded(cocos2d::Touch *pTouch, cocos2d::Event *pEvent)

	self.m_pCannon:fire();

end

function GameLayer:addFish(){
    local loadFishSpriteBatchNode=NULL;
    while 1 
        local type = math.random() % 18 + 1;
        
        if NULL==loadFishSpriteBatchNode then
            for i=0,table.getn(FishInBatchNode1) then
                if  type==FishInBatchNode1[i] then
                    loadFishSpriteBatchNode=m_pBatchNodeFish1;
                    break;
                end
            end
        end
        if(NULL==loadFishSpriteBatchNode){
            for i=0,table.getn(FishInBatchNode2) then
                if type==FishInBatchNode2[i] then
                    loadFishSpriteBatchNode=m_pBatchNodeFish2AndBullets;
                    break;
                end
            end
        end
		

        if loadFishSpriteBatchNode then
            Fish:createWithFishType(type, this, loadFishSpriteBatchNode);
            return;
        end
    
    end
    loadFishSpriteBatchNode=NULL;
     
}

end

function GameLayer:updateFish(float dt){
    if table.getn(m_pFishes) < MAX_FISH_COUNT then
    
        local n = MAX_FISH_COUNT - table.getn(m_pFishes);
        local x = 1 nAdd = math.random() % n + 1;

        for i = 0,nAdd then
            self:addFish()
        end
    end
}
end
function GameLayer:shrinkRect(rc, xr,yr)
{
    local w = rc.size.width * xr;
    local h = rc.size.height * yr;
    local pt = cc.p(rc.origin.x + rc.size.width * (1.0f - xr) / 2,
                     rc.origin.y + rc.size.height * (1.0f - yr) / 2);
    return cc.Rect(pt.x, pt.y, w, h);
}
end

function GameLayer:updateGame(float dt)
{
    local pFishObj = nil;
    local pBulletObj = nil;
    for i=0,table.getn(self.m_pBullets) then
        local pBullet = self.m_pBullets[i];
        if(pBullet:getCaught())
            continue;
        local caught = false;
        for i=0,table.getn(self.m_pFishes) then
            local pFish = self.m_pFishes[i];
            if(pFish:getCaught())
                continue;
            
            local hittestRect = self:shrinkRect(pFish:getSpriteFish():boundingBox(), 0.8f, 0.5f);
            
            if hittestRect.containsPoint(pBullet:getSpriteBullet():getPosition()) then
                caught = true;
                pFish:showCaught();
                m_nScore += 125;
                m_pRollNumGroup->setValue(m_nScore);
            end
        end
        
        if(caught)
        {
            pBullet->showNet();
        }
    }
    end
}
end