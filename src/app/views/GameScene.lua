local GameScene = class("GameScene", cc.load("mvc").ViewBase)
local RollNumGroup = import(".RollNumGroup")
local Cannon = import(".Cannon")
local Fish = import(".Fish")

local FishInBatchNode1 = {1, 2, 3, 4, 5, 6, 7, 8, 9, 13, 14};

local FishInBatchNode2 = {10, 18};


local FishInBatchNode4 = {11, 12};

local scheduler = cc.Director:getInstance():getScheduler()
local updateFish_updateFish = nil
local updateFish_updateGame = nil
local MAX_FISH_COUNT = 15


function GameScene:ctor()
    self.m_pBullets = nil
    self.m_pFishes = nil
    self.m_nScore = 0
    self.m_pCannon = nil
    self.m_pSpriteAdd = nil
    self.m_pRollNumGroup = nil
end

function GameScene:init()
    this:setTouchEnabled(true);
    this:initFrames();
    this:initBackground();
	this:initListeners();
    this:initFishes();
    this:initCannon();
     local function updateFish1()
        self:updateFish()
    end
    updateFish_updateFish = scheduler:scheduleScriptFunc(updateFish1, 1.0)
    updateFish_updateGame = scheduler:scheduleScriptFunc(updateFish1, 1.0)
    return true;
end

function GameScene:initListeners()


     local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)

    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    local eventDispatcher = ret:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

end


function GameScene:initFrames()
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish2.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish3.plist");
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("fish4.plist"); 
    cc.SpriteFrameCache:getInstance():addSpriteFramesWithFile("cannon.plist");
end

function GameScene:initBackground()
    local texture=cc.Director:getInstance():getTextureCache():addImage("bj01.jpg");
    local pBackGround =  cc.Sprite:createWithTexture(batchNode:getTexture())

    pBackGround:setAnchorPoint(cc.p(0.5, 0.5));
    local winSize=cc.director:sharedDirector():getWinSize();
    pBackGround:setPosition(cc.p(winSize.width/2, winSize.height/2));
    self:addChild(pBackGround);
    
    texture=cc.Director:getInstance():getTextureCache():addImage("ui_box_01.png");
    local pTopBar=cc.Sprite:createWithTexture(texture);
    pTopBar:setPosition(cc.p(500, 580));
	
    self:addChild(pTopBar,100);
    
    texture=cc.Director:getInstance():getTextureCache():addImage("ui_box_02.png");
    local pBottomBar=cc.Sprite:createWithTexture(texture);
    pBottomBar:setPosition(cc.p(440, 90));
    self:addChild(pBottomBar,100);

	self.m_pRollNumGroup= RollNumGroup:createWithGameLayer(self, 6)
    self.m_pRollNumGroup:setPosition(cc.p(353, 21));    
end

function GameScene:initFishes()

	local texture = cc.Director:getInstance():getTextureCache():addImage("fish.png");
    this.setBatchNodeFish1(cc.Sprite:createWithTexture(texture));
    this:addChild(this.m_pBatchNodeFish1); 
    
    texture = cc.Director:getInstance():getTextureCache():addImage("fish2.png");
    self.m_pBatchNodeFish2AndBullets=cc.Sprite:createWithTexture(texture);
    self:addChild(self.m_pBatchNodeFish2AndBullets);
    
    texture = cc.Director:getInstance():getTextureCache():addImage("fish3.png");
    self.m_pBatchNodeFish3AndNets=cc.SpriteBatchNode:createWithTexture(texture);
    self:addChild(self.m_pBatchNodeFish3AndNets);
    
     
   -- this->setFishes(Array::createWithCapacity(MAX_FISH_COUNT));
    m_pFishes:removeAllObjects();


end

function GameScene:initCannon()

    self.m_Bullets = {};
    local ptexture=cc.Director:getInstance():getTextureCache():addImage("cannon.png");
    local pBatchNode=cc.SpriteBatchNode:create(ptexture);
    self:addChild(pBatchNode,101,7);
    self.m_Cannon= Cannon:createWithCannonType(6, self, self.pBatchNode);
    
    self.m_pSpriteAdd=cc.Sprite:createWithSpriteFrameName("button_add.png");
    self.m_pSpriteAdd:setPosition(cc.p(585,28));
    self.m_pSpriteAdd:setScale(1.5);
    self.addChild(self.m_pSpriteAdd,101);
    
    local texture2dReduce=  cc.Director:getInstance():getTextureCache():addImage("button_reduce.png");
    local spriteFrameReduceNormal=cc.SpriteBatchNode:createWithTexture(texture2dReduce, cc.rect(0, 0, texture2dReduce:getContentSize().width/2, texture2dReduce:getContentSize().height));
    self.m_pSpriteReduce=cc.Sprite:createWithSpriteFrameName("button_reduce.png");
    self.m_pSpriteReduce:setPosition(cc.p(450,28));
    self.m_pSpriteReduce:setScale(1.5);
    self:addChild(self.m_pSpriteReduce,101);
end

function GameScene:addConnonSize()
    local curConnonType=self.m_pCannon:getConnonType();
    curConnonType = curConnonType + 1
    if urConnonType>7 then
        curConnonType=1
    end
   -- CC_SAFE_DELETE(this->m_pCannon);
    self.m_Cannon =Cannon:createWithCannonType(curConnonType, self, self:getChildByTag(7));

end

function GameScene:reduceConnonSize()
    local curConnonType=self.m_pCannon:getConnonType();
    curConnonType=7;
    self.m_Cannon =Cannon:createWithCannonType(curConnonType, self, self:getChildByTag(7));
end

function GameScene:onTouchBegan(pTouch, pEvent)

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

function GameScene:onTouchMoved(pTouch, pEvent) 

	local pt = pTouch:getLocation()
	this.m_pCannon:rotateToPoint(pt);

end		
function GameScene:onTouchEnded(pTouch, pEvent)

	self.m_pCannon:fire();

end

function GameScene:addFish() 
    local loadFishSpriteBatchNode=nil;
     local type= 0
    while (true) do
        type = math.random() % 18 + 1;
        
        if nil==loadFishSpriteBatchNode then
            for i=0,table.getn(FishInBatchNode1) do
                if  type==FishInBatchNode1[i] then
                    loadFishSpriteBatchNode=m_pBatchNodeFish1;
                    break;
                end
            end
        end
        if nil==loadFishSpriteBatchNode then
            for i=0,table.getn(FishInBatchNode2) do
                if type==FishInBatchNode2[i] then
                    loadFishSpriteBatchNode=m_pBatchNodeFish2AndBullets;
                    break;
                end
            end
        end
		

        if loadFishSpriteBatchNode  then
            Fish:createWithFishType(type, this, loadFishSpriteBatchNode);
            return;
        end
    
    end
    loadFishSpriteBatchNode=nil;
     


end

function GameScene:updateFish(dt)
    if table.getn(m_pFishes) < MAX_FISH_COUNT then
    
        local n = MAX_FISH_COUNT - table.getn(m_pFishes);
        local x = 1 nAdd = math.random() % n + 1;

        for i = 0,nAdd do
            self:addFish()
        end
    end

end
function GameScene:shrinkRect(rc, xr,yr)

    local w = rc.size.width * xr;
    local h = rc.size.height * yr;
    local pt = cc.p(rc.origin.x + rc.size.width * (1.0 - xr) / 2,
                     rc.origin.y + rc.size.height * (1.0 - yr) / 2);
    return cc.Rect(pt.x, pt.y, w, h);

end

function GameScene:updateGame(floatdt)

    local pFishObj = nil;
    local pBulletObj = nil;
    for i=0,table.getn(self.m_pBullets) do
        local pBullet = self.m_pBullets[i];
        if pBullet:getCaught()  == false then
            local caught = false;
            for i=0,table.getn(self.m_pFishes) do
                local pFish = self.m_pFishes[i];
                if pFish:getCaught()  == false then
                  
                    local hittestRect = self:shrinkRect(pFish:getSpriteFish():boundingBox(), 0.8, 0.5);
            
                    if hittestRect.containsPoint(pBullet:getSpriteBullet():getPosition()) then
                        caught = true;
                        pFish:showCaught();
                        m_nScore = m_nScore + 125;
                        self.m_pRollNumGroup:setValue(m_nScore);
                    end
                end
            end
        end
        
        if caught then
            pBullet:showNet()
        end
    end
end

return GameScene