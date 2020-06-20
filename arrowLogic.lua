local loaded, reason = LoadAddOn("MethodDungeonTools")
local ArrowFrame = CreateFrame("Frame", "DragFrame2", UIParent)
ArrowFrame:SetMovable(true)
ArrowFrame:EnableMouse(true)
ArrowFrame:SetScript("OnMouseDown", function(self, button)
  if button == "LeftButton" and not self.isMoving then
   self:StartMoving();
   self.isMoving = true;
  end
end)
ArrowFrame:SetScript("OnMouseUp", function(self, button)
  if button == "LeftButton" and self.isMoving then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)
ArrowFrame:SetScript("OnHide", function(self)
  if ( self.isMoving ) then
   self:StopMovingOrSizing();
   self.isMoving = false;
  end
end)

-- The code below makes the ArrowFrame visible, and is not necessary to enable dragging.
ArrowFrame:SetPoint("CENTER"); 
ArrowFrame:SetWidth(64);
ArrowFrame:SetHeight(64);
local tex = ArrowFrame:CreateTexture(nil,"BACKGROUND")
tex:SetTexture("Interface\\AddOns\\EntropiDungeonHelper\\Arrow.blp")


--f:SetAllPoints()
if not loaded then
  print(format(ADDON_LOAD_FAILED, "MethodDungeonTools", _G["ADDON_"..reason]));
  if reason == "DISABLED" then
    -- do stuff 
  elseif reason == "MISSING" then
    -- do other stuff
  elseif reason == "CORRUPT" then
    -- do something else
  elseif reason == "INTERFACE_VERSION" then
    -- do something different
  end
end
function dungeonHandler(self, event, isInitialLogin, isReloadingUi, ...)
  inInstance, instanceType = IsInInstance()
  if(instanceType == "party") then
      name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
      ChatFrame1:AddMessage("EDH -- You have entered: "..name, 125, 0, 125)
      ArrowFrame:Show()
      row = 1 --DEBUG ROW
      col = 1 --DEBUG COL
      x = 0
      y = 0
      posX = 0
      posY = 0
      local AAP_ArrowActive_TrigDistance
      local PI2 = math.pi * 2
      local atan2 = math.atan2
      local twopi = math.pi * 2
      local deltaX, deltaY = posX, (0 - posY)
      local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
      local angle = atan2(-deltaX, deltaY)
      local player = GetPlayerFacing()
      angle = angle - player
      local perc = math.abs((math.pi - math.abs(angle)) / math.pi)
      -- if perc > 0.98 and perc < 1.02 then
      --   AAPClassic.ArrowFrame.arrow:SetVertexColor(0,1,0)
      -- elseif perc >= 1.02 and perc < 1.49 then
      --   AAPClassic.ArrowFrame.arrow:SetVertexColor((perc-1)*2,1,0)
      -- elseif perc > 1.49 then
      --   perc = 2-perc
      --   AAPClassic.ArrowFrame.arrow:SetVertexColor(1,perc*2,0)
      -- elseif perc > 0.49 then
      --   AAPClassic.ArrowFrame.arrow:SetVertexColor((1-perc)*2,1,0)
      -- else
      --   AAPClassic.ArrowFrame.arrow:SetVertexColor(1,perc*2,0)
      -- end
      local cell = floor(angle / twopi * 108 + 0.5) % 108
      local cell = floor(angle / twopi * 108 + 0.5) % 108
      local col = cell % 9
      local row = floor(cell / 9)
      tex:SetTexCoord((col * 56) / 512,((col + 1) * 56) / 512,(row * 42) / 512,((row + 1) * 42) / 512)
      --tex:SetTexture(1.0, 0.5, 0); tex:SetAlpha(0.5);
      tex:SetAllPoints();
      ChatFrame1:AddMessage(posX, 125, 0, 125)

  else
      ArrowFrame:Hide()
  end
end
local playerEnterWorld = CreateFrame("Frame");
playerEnterWorld:RegisterEvent("PLAYER_ENTERING_WORLD");

playerEnterWorld:SetScript("OnEvent", dungeonHandler);
