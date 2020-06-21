

tableOfInterrupts = {
  {id = "BalanceDruid", cooldown =60, cleanName = "Balance Druid", playerName = ""},
  {id = "DAMAGERDruid", cooldown =15, cleanName = "Feral Druid", playerName = ""},
  {id = "TANKDruid", cooldown =1, cleanName = "Guardian Druid", playerName = ""},
  {id = "DAMAGERHunter", cooldown =24, cleanName = "Hunter", playerName = ""},
  {id = "DAMAGERPriest", cooldown =45, cleanName = "Shadow Priest", playerName = ""},
  {id = "DAMAGERShaman", cooldown =2, cleanName = "DPS Shaman", playerName = ""},
  {id = "HEALERShaman", cooldown =12, cleanName = "Restoration Shaman", playerName = ""},
  {id = "DAMAGERWarrior", cooldown =15, cleanName = "DPS Warrior", playerName = ""},
  {id = "TANKWarrior", cooldown =15, cleanName = "Protection Warrior", playerName = ""},
  {id = "DAMAGERPaladin", cooldown =15, cleanName = "Retribution Paladin", playerName = ""},
  {id = "TANKPaladin", cooldown =15, cleanName = "Protection Paladin", playerName = ""},
  {id = "DAMAGERDemonHunter", cooldown =15, cleanName = "Havoc Demon Hunter", playerName = ""},
  {id = "TANKDemonHunter", cooldown =15, cleanName = "Vengeance Demon Hunter", playerName = ""},
  {id = "DAMAGERDeathKnight", cooldown =15, cleanName = "DPS Death Knight", playerName = ""},
  {id = "TANKDeathKnight", cooldown =15, cleanName = "Blood Death Knight", playerName = ""},
  {id = "TANKMonk", cooldown =15, cleanName = "Brewmaster Monk", playerName = ""},
  {id = "DAMAGERMonk", cooldown =15, cleanName = "Windwalker Monk", playerName = ""},
  {id = "DAMAGERRogue", cooldown =15, cleanName = "Rogue", playerName = ""},
  {id = "DAMAGERMage", cooldown =24, cleanName = "Mage", playerName = ""},
  {id = "DAMAGERWarlock", cooldown =24, cleanName = "Warlock", playerName = ""},
  {id = "HEALERPaladin", cooldown =-1, cleanName = "", playerName = ""},
  {id = "HEALERDruid", cooldown =-1, cleanName = "", playerName = ""},
  {id = "HEALERPriest", cooldown =-1, cleanName = "", playerName = ""},
  {id = "HEALERMonk", cooldown =-1, cleanName = "", playerName = ""}
};

interruptLookupTable = {}

for i, thing in pairs(tableOfInterrupts) do
  interruptLookupTable[thing.id] = thing
end



groupindex = 0;
currentGroupInterrupts = {};

function compare(a,b)
  return a.cooldown < b.cooldown
end

function dungeonHandler(self, event, isInitialLogin, isReloadingUi, ...)
  inInstance, instanceType = IsInInstance()
  if(instanceType == "party") then
      name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
      ChatFrame1:AddMessage("EDH -- You have entered: "..name, 125, 0, 125, 3)
      printInterrupts()
  end
end

    local tObj = CreateFrame("Frame", "testframe", UIParent, "GameTooltipTemplate");
        tObj:SetPoint("CENTER", UIParent, "CENTER")
        tObj:SetSize(100,300)
        tObj:SetBackdropColor(0, 0, 0, 0.75)
        tObj:EnableMouse(true)
        tObj:SetMovable(true)
        tObj:SetResizable(true)
        tObj:SetScript("OnDragStart", function(self) 
            self.isMoving = true
            self:StartMoving() 
        end)
        tObj:SetScript("OnDragStop", function(self) 
            self.isMoving = false
            self:StopMovingOrSizing() 
            self.x = self:GetLeft() 
            self.y = (self:GetTop() - self:GetHeight()) 
            self:ClearAllPoints()
            self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.x, self.y)
        end)
        tObj:SetScript("OnUpdate", function(self) 
            if self.isMoving == true then
                self.x = self:GetLeft() 
                self.y = (self:GetTop() - self:GetHeight()) 
                self:ClearAllPoints()
                self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.x, self.y)
            end
        end)
        tObj:SetClampedToScreen(true)
        tObj:RegisterForDrag("LeftButton")
        tObj:SetScale(1)
        tObj.x = tObj:GetLeft() 
        tObj.y = (tObj:GetTop() - tObj:GetHeight()) 
        tObj:Show()
     
        local resizeButton = CreateFrame("Button", "resButton", tObj)
        resizeButton:SetSize(16, 16)
        resizeButton:SetPoint("BOTTOMRIGHT")
        resizeButton:SetNormalTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Up")
        resizeButton:SetHighlightTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Highlight")
        resizeButton:SetPushedTexture("Interface\\ChatFrame\\UI-ChatIM-SizeGrabber-Down")
        resizeButton:SetScript("OnMouseDown", function(self, button)
            if button == "LeftButton" then
                self.isSizing = true
                self:GetParent():StartSizing("BOTTOMRIGHT")
                self:GetParent():SetUserPlaced(true)
            elseif button == "RightButton" then
                self.isScaling = true
            end
        end)
        resizeButton:SetScript("OnMouseUp", function(self, button)
            if button == "LeftButton" then
                self.isSizing = false
                self:GetParent():StopMovingOrSizing()
            elseif button == "RightButton" then
                self.isScaling = false
            end
        end)
        resizeButton:SetScript("OnUpdate", function(self, button)
            if self.isScaling == true then
                local cx, cy = GetCursorPosition()
                cx = cx / self:GetEffectiveScale() - self:GetParent():GetLeft() 
                cy = self:GetParent():GetHeight() - (cy / self:GetEffectiveScale() - self:GetParent():GetBottom() )
     
                local tNewScale = cx / self:GetParent():GetWidth()
                local tx, ty = self:GetParent().x / tNewScale, self:GetParent().y / tNewScale
                
                self:GetParent():ClearAllPoints()
                self:GetParent():SetScale(self:GetParent():GetScale() * tNewScale)
                self:GetParent():SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", tx, ty)
                self:GetParent().x, self:GetParent().y = tx, ty
            end
        end)
     
    local text2=tObj:CreateFontString(nil,"OVERLAY","GameFontNormal");
    text:SetPoint("CENTER");
    text:SetText("HI MOM!");
--  Title
    local text=tObj:CreateFontString(nil,"OVERLAY","GameFontNormal");
    text:SetPoint("TOP",0,-7);
    text:SetText("Interrupt Rotation");

    
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

--local UIConfig = CreateFrame("Frame", "EDH_Interrupt Config", UIParent, "BasicFrameTemplateWithInset");
--UIConfig:SetSize(300,360);
--UIConfig:SetPoint("CENTER", UIParent, "Center");

