

        EDHInterfaceFrame = CreateFrame("Frame", "testframe", UIParent, "ShadowOverlayTemplate");
        EDHInterfaceFrame:SetPoint("CENTER", UIParent, "CENTER")
        EDHInterfaceFrame:SetSize(150,175)
        EDHInterfaceFrame:SetBackdropColor(0, 0, 0, 0.75)
        EDHInterfaceFrame:EnableMouse(true)
        EDHInterfaceFrame:SetMovable(true)
        EDHInterfaceFrame:SetResizable(true)
        EDHInterfaceFrame:SetScript("OnDragStart", function(self) 
            self.isMoving = true
            self:StartMoving() 
        end)
        EDHInterfaceFrame:SetScript("OnDragStop", function(self) 
            self.isMoving = false
            self:StopMovingOrSizing() 
            self.x = self:GetLeft() 
            self.y = (self:GetTop() - self:GetHeight()) 
            self:ClearAllPoints()
            self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.x, self.y)
        end)
        EDHInterfaceFrame:SetScript("OnUpdate", function(self) 
            if self.isMoving == true then
                self.x = self:GetLeft() 
                self.y = (self:GetTop() - self:GetHeight()) 
                self:ClearAllPoints()
                self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", self.x, self.y)
            end
        end)
        EDHInterfaceFrame:SetClampedToScreen(true)
        EDHInterfaceFrame:RegisterForDrag("LeftButton")
        EDHInterfaceFrame:SetScale(1)
        EDHInterfaceFrame.x = EDHInterfaceFrame:GetLeft() 
        EDHInterfaceFrame.y = (EDHInterfaceFrame:GetTop() - EDHInterfaceFrame:GetHeight()) 
        EDHInterfaceFrame:Show()
     
--  Title
    EDHInterfaceTitle=EDHInterfaceFrame:CreateFontString(titleText,"OVERLAY","GameFontNormal");
    EDHInterfaceTitle:SetPoint("TOP",0,-7);
    EDHInterfaceTitle:SetText("Entropi Interrupts");

    firstPerson=EDHInterfaceFrame:CreateFontString(firstPerson,"OVERLAY","GameFontNormal");
    firstPerson:SetPoint("TOP", 0, -30);
    s1 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s1:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s1:SetStatusBarColor(1,0,.5,0)
    s1:SetSize(150 ,22) -- width, height
    s1:SetPoint("TOPLEFT", 0, -25)
        
    secondPerson=EDHInterfaceFrame:CreateFontString(secondPerson,"OVERLAY","GameFontNormal");
    secondPerson:SetPoint("TOP", 0, -60);
    s2 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s2:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s2:SetStatusBarColor(1,0,.5,0)
    s2:SetSize(150 ,22) -- width, height
    s2:SetPoint("TOPLEFT", 0, -55)
    thirdPerson=EDHInterfaceFrame:CreateFontString(thirdPerson,"OVERLAY","GameFontNormal");
    thirdPerson:SetPoint("TOP", 0, -90);
    s3 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s3:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s3:SetStatusBarColor(1,0,.5,0)
    s3:SetSize(150 ,22) -- width, height
    s3:SetPoint("TOPLEFT", 0, -85)
    fourthPerson=EDHInterfaceFrame:CreateFontString(fourthPerson,"OVERLAY","GameFontNormal");
    fourthPerson:SetPoint("TOP", 0, -120);
    s4 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s4:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s4:SetStatusBarColor(1,0,.5,0)
    s4:SetSize(150 ,22) -- width, height
    s4:SetPoint("TOPLEFT", 0, -115)
    fifthPerson=EDHInterfaceFrame:CreateFontString(fifthPerson,"OVERLAY","GameFontNormal");
    fifthPerson:SetPoint("TOP", 0, -150);
    s5 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s5:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s5:SetStatusBarColor(1,0,.5,0)
    s5:SetSize(150 ,22) -- width, height
    s5:SetPoint("TOPLEFT", 0, -145)
    EDHInterfaceFrame:Hide();
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

--local UIConfig = CreateFrame("Frame", "EDH_Interrupt Config", UIParent, "BasicFrameTemplateWithInset");
--UIConfig:SetSize(300,360);
--UIConfig:SetPoint("CENTER", UIParent, "Center");

