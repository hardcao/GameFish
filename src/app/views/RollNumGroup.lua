local RollNumGroup = class("RollNumGroup")

local RollNum = import(".RollNum")
RollNumGroup.m_pBatchNode = nil
RollNumGroup.m_pGameLayer = nil
RollNumGroup.m_pRollNumArray= {}
RollNumGroup.m_ptPosition = cc.p(0,0)
RollNumGroup.m_nDigit =0
RollNumGroup.m_nValue = 0

function RollNumGroup:ctor()
   
end

function RollNumGroup:createWithGameLayer(pGameLayer, nDigit)

    self:initWithGameLayer(pGameLayer, nDigit)

end
function RollNumGroup:initWithGameLayer(GameLayer *pGameLayer, int nDigit)
    self.m_pGameLayer = pGameLayer;
   
    local pTex = cc.TextureCache:getInstance():addImage("number.png");
    self.m_pBatchNode = cc.SpriteBatchNode:createWithTexture(pTex);
    
    self.m_pGameLayer:addChild(m_pBatchNode, 100);
    
    for i = 1,nDigit then
    
        
        local pRollNum = RollNum:create();
        self.m_pRollNumArray[i] = pRollNum;
        
        self.m_pBatchNode:addChild(pRollNum);
    end
    return true;

end
function RollNumGroup:setPosition(pt)

    self.m_ptPosition = pt;
    for i = 0,self.m_pRollNumArray:count() then
    
        local pRollNum = self.m_pRollNumArray[i];
        pRollNum:setPosition(pt);
        pt.x -= 20.7f;
    
    end

end

function RollNumGroup:setValue(nValue)

   
    if self m_nValue == nValue then
        return;
    end
    
    local bUp = m_nValue < nValue;
    self.m_nValue = nValue;
    
    for  i = 0,self.m_pRollNumArray:count() then
    
        local pRollNum = m_pRollNumArray[i];
        local num = nValue % 10;
        
        if pRollNum:getNumber() != num then
          
            pRollNum:setNumber(num, bUp);
        end
        nValue = nValue / 10;
    end

end

return RollNumGroup