local RollNum = class("RollNum")

RollNum.NUMBERHEIGHT = 16
RollNum.NUMBERWIDTH = 12
RollNum.NUMBERWIDTH  = 196
local scheduler = cc.Director:getInstance():getScheduler()

local SpriteEase_entry = nil

function RollNum:ctor()
    self.m_nNumber = 0
    self.m_bUp = true
    self.m_nCurTexH = 0
    self.m_nEndTexH = 0
    self.m_bRolling = false
end


function RollNum:init()

	fullpath = cc.FileUtils:getInstance():fullPathForFilename("number.png");
	m_pTexture = director:getTextureCache():getTextureForKey(fullpath);
    local pFrame = cc.SpriteFrame:createWithTexture(m_pTexture, Rect(0, 0, NUMBERWIDTH, NUMBERHEIGHT));
    self:nitWithSpriteFrame(pFrame);
    self:setScale(1.0f);
    return true;
end

function RollNum:updateNumber(dt)

    if self.m_bRolling && self.m_nCurTexH == self.m_nEndTexH then
        scheduler:unscheduleScriptEntry(SpriteEase_entry)
        m_bRolling = false;
        return;
    
    end

    if m_bUp then
    
        self.m_nCurTexH += 4;
        if self.m_nCurTexH >= self.TEXTUREHEIGHT then
            self.m_nCurTexH = 0;
        end
    elseif
    
        self.m_nCurTexH -= 4;
        if self.m_nCurTexH < 0 then
            self.m_nCurTexH = TEXTUREHEIGHT;
    end

    local h = m_nCurTexH;
    if m_nCurTexH >= 180 then
        h = 180;
    end
    local pFrame = cc.SpriteFrame:createWithTexture(m_pTexture, cc.rect(0, h, NUMBERWIDTH, NUMBERHEIGHT));
    self:setDisplayFrame(pFrame);   
    m_bRolling = true;
end

function RollNum:setNumber(ivar, bUp)
    
    self.m_nNumber = var;
    self.m_bUp = bUp;
    self.m_nEndTexH = m_nNumber * (NUMBERHEIGHT + 4);
    SpriteEase_entry = scheduler:scheduleScriptFunc(self:updateNumber, 3.0)
   
end
function RollNum:getNumber()
    return self.m_nNumber;
end


return RollNum