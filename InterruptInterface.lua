

        EDHInterfaceFrame = CreateFrame("Frame", "testframe", UIParent, "ShadowOverlayTemplate");
        EDHInterfaceFrame:SetPoint("CENTER", UIParent, "CENTER")
        EDHInterfaceFrame:SetSize(100,300)
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
     
        local resizeButton = CreateFrame("Button", "resButton", EDHInterfaceFrame)
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
     
--  Title
    EDHInterfaceTitle=EDHInterfaceFrame:CreateFontString(titleText,"OVERLAY","GameFontNormal");
    EDHInterfaceTitle:SetPoint("TOP",0,-7);
    EDHInterfaceTitle:SetText("Interrupt Rotation");

    firstPerson=EDHInterfaceFrame:CreateFontString(firstPerson,"OVERLAY","GameFontNormal");
    firstPerson:SetPoint("TOP", 0, -30);
        
    secondPerson=EDHInterfaceFrame:CreateFontString(secondPerson,"OVERLAY","GameFontNormal");
    secondPerson:SetPoint("TOP", 0, -60);

    thirdPerson=EDHInterfaceFrame:CreateFontString(thirdPerson,"OVERLAY","GameFontNormal");
    thirdPerson:SetPoint("TOP", 0, -90);

    fourthPerson=EDHInterfaceFrame:CreateFontString(fourthPerson,"OVERLAY","GameFontNormal");
    fourthPerson:SetPoint("TOP", 0, -120);

    fifthPerson=EDHInterfaceFrame:CreateFontString(fifthPerson,"OVERLAY","GameFontNormal");
    fifthPerson:SetPoint("TOP", 0, -160);
    -- local l = EDHInterfaceFrame:CreateLine()
    -- l:SetColorTexture(1,0,0,1)
    -- l:SetStartPoint("TOPLEFT",10,10)
    -- l:SetEndPoint("TOPRIGHT",10,10)
    EDHInterfaceFrame:Hide();
---------------------------------------------------------------------------------------------------

------------------------------------------------------------------------------------------------------------------

--local UIConfig = CreateFrame("Frame", "EDH_Interrupt Config", UIParent, "BasicFrameTemplateWithInset");
--UIConfig:SetSize(300,360);
--UIConfig:SetPoint("CENTER", UIParent, "Center");

