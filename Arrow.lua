EDH = {}
EDH.Explored = {}
EDH.Build = GetBuildInfo()
EDH.Name = UnitName("player")
EDH.Realm = string.gsub(GetRealmName(), " ", "")
EDH.Faction = UnitFactionGroup("player")
EDH.Level = UnitLevel("player")
EDH.experience = UnitXP("player")
EDH.Version = tonumber(GetAddOnMetadata("EDH-Classic", "Version"))
EDH.Class = {}
EDH.RaceLocale, EDH.Race = UnitRace("player")
EDH.Class[1],EDH.Class[2],EDH.Class[3] = UnitClass("player")
EDH.QuestHelperEnable = "off"
EDH.Locale = GetLocale()
EDH.NotRepeatList = {
	[813] = 813,
}
EDHC1 = {}
EDH.ClassDBConv = {
	[1] = 1,
	[2] = 2,
	[3] = 4,
	[4] = 8,
	[5] = 16,
	[6] = 6,
	[7] = 64,
	[8] = 128,
	[9] = 256,
	[10] = 10,
	[11] = 1024,
	[12] = 12,
}
EDH.QStarterList = {
	1972,
	1307,
	1971,
	5352,
	4881,
	4891,
	16305,
	16304,
	16303,
}
function EDH.getContinent()
    local mapID = C_Map.GetBestMapForUnit("player")
    if(mapID) then
        local info = C_Map.GetMapInfo(mapID)
        if(info) then
            while(info['mapType'] and info['mapType'] > 2) do
                info = C_Map.GetMapInfo(info['parentMapID'])
            end
            if(info['mapType'] == 2) then
                return info['mapID']
            end
        end
    end
end
EDH.Arrow = {}
EDH.ArrowActive = 0
EDH.ArrowActive_X = 0
EDH.ArrowActive_Y = 0
EDH.SetArrowStep = 0
local EDH_ArrowUpdateNr = 0

EDH.ArrowFrameM = CreateFrame("Button", "EDH_ArrowFrame", UIParent)
EDH.ArrowFrameM:SetHeight(1)
EDH.ArrowFrameM:SetWidth(1)
EDH.ArrowFrameM:SetPoint("TOPLEFT", UIParent, "TOPLEFT", 0, 0)
EDH.ArrowFrameM:EnableMouse(true)
EDH.ArrowFrameM:SetMovable(true)

EDH.ArrowFrame = CreateFrame("Button", "EDH_ArrowFrame2", UIParent)
EDH.ArrowFrame:SetHeight(42)
EDH.ArrowFrame:SetWidth(56)
EDH.ArrowFrame:SetPoint("TOPLEFT", EDH.ArrowFrameM, "TOPLEFT", 0, 0)
EDH.ArrowFrame:EnableMouse(true)
EDH.ArrowFrame:SetMovable(true)
EDH.ArrowFrame.arrow = EDH.ArrowFrame:CreateTexture(nil, "OVERLAY")
EDH.ArrowFrame.arrow:SetTexture("Interface\\AddOns\\EntropiDungeonHelper\\Arrow.blp")
EDH.ArrowFrame.arrow:SetAllPoints()
EDH.ArrowFrame.distance = EDH.ArrowFrame:CreateFontString("ARTWORK", "ChatFontNormal")
EDH.ArrowFrame.distance:SetFontObject("GameFontNormalSmall")
EDH.ArrowFrame.distance:SetPoint("TOP", EDH.ArrowFrame, "BOTTOM", 0, 0)
EDH.ArrowFrame:Hide()
EDH.ArrowFrame:SetScript("OnMouseDown", function(self, button)
	if button == "LeftButton" and not EDH.ArrowFrameM.isMoving then
		EDH.ArrowFrameM:StartMoving();
		EDH.ArrowFrameM.isMoving = true;
	end
end)
EDH.ArrowFrame:SetScript("OnMouseUp", function(self, button)
	if button == "LeftButton" and EDH.ArrowFrameM.isMoving then
		EDH.ArrowFrameM:StopMovingOrSizing();
		EDH.ArrowFrameM.isMoving = false;
	end
end)
EDH.ArrowFrame:SetScript("OnHide", function(self)
	if ( EDH.ArrowFrameM.isMoving ) then
		EDH.ArrowFrameM:StopMovingOrSizing();
		EDH.ArrowFrameM.isMoving = false;
	end
end)

EDH.ArrowFrame.Button = CreateFrame("Button", "EDH_ArrowFrame_Button", EDH_ArrowFrame)
EDH.ArrowFrame.Button:SetWidth(85)
EDH.ArrowFrame.Button:SetHeight(17)
EDH.ArrowFrame.Button:SetParent(EDH.ArrowFrame)
EDH.ArrowFrame.Button:SetPoint("BOTTOM", EDH.ArrowFrame, "BOTTOM", 0, -30)
EDH.ArrowFrame.Button:SetScript("OnMouseDown", function(self, button)
	EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr] = EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr] + 1
	print("EDH - Skipped Waypoint")
	EDH.QH.FuncLoopNumber = 1
end)
EDH.ArrowFrame.Button:SetBackdrop( { 
	bgFile = "Interface\\DialogFrame\\UI-DialogBox-Background", 
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	tile = true, tileSize = 10, edgeSize = 10, insets = { left = 2, right = 2, top = 2, bottom = 2 }
});
EDH.ArrowFrame.Fontstring = EDH.ArrowFrame:CreateFontString("EDH_ArrowFrame_Fontstring ","ARTWORK", "ChatFontNormal")
EDH.ArrowFrame.Fontstring:SetParent(EDH.ArrowFrame.Button)
EDH.ArrowFrame.Fontstring:SetPoint("CENTER", EDH.ArrowFrame.Button, "CENTER", 0, 0)

EDH.ArrowFrame.Fontstring:SetFontObject("GameFontNormalSmall")
EDH.ArrowFrame.Fontstring:SetText("Skip waypoint")
EDH.ArrowFrame.Fontstring:SetTextColor(1, 1, 0)
EDH.ArrowFrame.Button:Hide()

function EDH.SetQPTT()
	local CurStep = EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr]
	if (CurStep and EDH.Path[EDH.QH.ZoneNr] and EDH.Path[EDH.QH.ZoneNr][CurStep] and EDH.Path[EDH.QH.ZoneNr][CurStep]["TT"] and EDH.SetArrowStep ~= CurStep) then
		local Step = EDH.Path[EDH.QH.ZoneNr][CurStep]
		EDH.SetArrowStep = CurStep
		if (Step and Step["DoneClass"]) then
			local Class = EDH.Class[3]
			if (Step["DoneClass"][Class] and Step["DoneClass"][Class][EDH.Race]) then
				EDH.ArrowActive = 1
				EDH.ArrowActive_X = Step["DoneClass"][Class][EDH.Race]["x"]
				EDH.ArrowActive_Y = Step["DoneClass"][Class][EDH.Race]["y"]
			end
		elseif (Step and Step["PickUpClass"]) then
			local Class = EDH.Class[3]
			if (Step["PickUpClass"][Class] and Step["PickUpClass"][Class][EDH.Race]) then
				EDH.ArrowActive = 1
				EDH.ArrowActive_X = Step["PickUpClass"][Class][EDH.Race]["x"]
				EDH.ArrowActive_Y = Step["PickUpClass"][Class][EDH.Race]["y"]
			end
		else
			EDH.ArrowActive = 1
			EDH.ArrowActive_X = EDH.Path[EDH.QH.ZoneNr][CurStep]["TT"]["x"]
			EDH.ArrowActive_Y = EDH.Path[EDH.QH.ZoneNr][CurStep]["TT"]["y"]
		end
	end
end
function EDH.ArrowFrame.CheckDistance()
	local CurStep = EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr]
	if (CurStep and EDH.Path[EDH.QH.ZoneNr] and EDH.Path[EDH.QH.ZoneNr][CurStep]) then
		local Step = EDH.Path[EDH.QH.ZoneNr][CurStep]
		if (EDH.Path[EDH.QH.ZoneNr][CurStep]["CRange"]) then
			EDH.ArrowFrame.Button:Show()
			local plusnr = CurStep
			local Distancenr = 0
			local testad = true
			if (EDH.Path[EDH.QH.ZoneNr][CurStep]["NoExtraRange"]) then
				testad = false
			end
			while testad do
				local oldx = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["x"]
				local oldy = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["y"]
				plusnr = plusnr + 1
				if (EDH.Path[EDH.QH.ZoneNr][plusnr] and EDH.Path[EDH.QH.ZoneNr][plusnr]["CRange"]) then
					local newx = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["x"]
					local newy = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["y"]
					local deltaX, deltaY = oldx - newx, newy - oldy
					local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
					Distancenr = Distancenr + distance
				else
					if (EDH.Path[EDH.QH.ZoneNr][plusnr] and EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]) then
						local newx = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["x"]
						local newy = EDH.Path[EDH.QH.ZoneNr][plusnr]["TT"]["y"]
						local deltaX, deltaY = oldx - newx, newy - oldy
						local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
						Distancenr = Distancenr + distance
					end
					return floor(Distancenr + 0.5)
				end
			end
		end
	end
	return 0
end
function EDH.ArrowFrame.ArrowPosTest()
	if (1 == 0) then
		EDH.ArrowActive = 0
		EDH.ArrowFrame:Hide()
	else
		local CurStep = EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr]
		if ((EDH.ArrowActive == 0) or (EDH.ArrowActive_X == 0) or (IsInInstance()) or not EDH.Path[EDH.QH.ZoneNr] or EDH.QuestHelperEnable == "on") then
			EDH.ArrowActive = 0
			EDH.ArrowFrame:Hide()
		else
			EDH.ArrowFrame:Show()
			EDH.ArrowFrame.Button:Hide()
			local d_y, d_x = UnitPosition("player")
			if (d_x and d_y) then
				x = EDH.ArrowActive_X
				y = EDH.ArrowActive_Y
				local EDH_ArrowActive_TrigDistance
				local PI2 = math.pi * 2
				local atan2 = math.atan2
				local twopi = math.pi * 2
				local deltaX, deltaY = d_x - x, y - d_y
				local distance = (deltaX * deltaX + deltaY * deltaY)^0.5
				local angle = atan2(-deltaX, deltaY)
				local player = GetPlayerFacing()
				angle = angle - player
				local perc = math.abs((math.pi - math.abs(angle)) / math.pi)
				if perc > 0.98 and perc < 1.02 then
					EDH.ArrowFrame.arrow:SetVertexColor(0,1,0)
				elseif perc >= 1.02 and perc < 1.49 then
					EDH.ArrowFrame.arrow:SetVertexColor((perc-1)*2,1,0)
				elseif perc > 1.49 then
					perc = 2-perc
					EDH.ArrowFrame.arrow:SetVertexColor(1,perc*2,0)
				elseif perc > 0.49 then
					EDH.ArrowFrame.arrow:SetVertexColor((1-perc)*2,1,0)
				else
					EDH.ArrowFrame.arrow:SetVertexColor(1,perc*2,0)
				end
				local cell = floor(angle / twopi * 108 + 0.5) % 108
				local cell = floor(angle / twopi * 108 + 0.5) % 108
				local col = cell % 9
				local row = floor(cell / 9)
				EDH.ArrowFrame.arrow:SetTexCoord((col * 56) / 512,((col + 1) * 56) / 512,(row * 42) / 512,((row + 1) * 42) / 512)
				EDH.ArrowFrame.distance:SetText(floor(distance + EDH.ArrowFrame.CheckDistance()) .. " yards")
				local Classic_ArrowActive_Distance = 0
				if (CurStep and EDH.QH.ZoneNr and EDH.Path[EDH.QH.ZoneNr] and EDH.Path[EDH.QH.ZoneNr][CurStep]) then
					if (EDH.Path[EDH.QH.ZoneNr][CurStep]["Trigger"]) then
						local d_y, d_x = UnitPosition("player")
						local EDH_ArrowActive_Trigger_X = EDH.Path[EDH.QH.ZoneNr][CurStep]["Trigger"]["x"]
						local EDH_ArrowActive_Trigger_Y = EDH.Path[EDH.QH.ZoneNr][CurStep]["Trigger"]["y"]
						local deltaX, deltaY = d_x - EDH_ArrowActive_Trigger_X, EDH_ArrowActive_Trigger_Y - d_y
						Classic_ArrowActive_Distance = (deltaX * deltaX + deltaY * deltaY)^0.5
						EDH_ArrowActive_TrigDistance = EDH.Path[EDH.QH.ZoneNr][CurStep]["Range"]
						if (EDH.Path[EDH.QH.ZoneNr][CurStep]["HIDEME"]) then
							EDH.ArrowActive = 0
						end
					end
				end
				if (distance < 5 and Classic_ArrowActive_Distance == 0) then
					EDH.ArrowActive_X = 0
				elseif (Classic_ArrowActive_Distance and EDH_ArrowActive_TrigDistance and Classic_ArrowActive_Distance < EDH_ArrowActive_TrigDistance) then
					EDH.ArrowActive_X = 0
					if (CurStep and EDH.QH.ZoneNr and EDH.Path[EDH.QH.ZoneNr] and EDH.Path[EDH.QH.ZoneNr][CurStep]) then
						if (EDH.Path[EDH.QH.ZoneNr][CurStep]["CRange"]) then
							EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr] = EDHC1[EDH.Realm][EDH.Name]["Zones"][EDH.QH.ZoneNr] + 1
							EDH.QH.FuncLoopNumber = 1
						end
					end
				end
			end
		end
	end
end
function EDH.ArrowUpdate()
	if (EDH_ArrowUpdateNr >= 2) then
		EDH.ArrowFrame.ArrowPosTest()
		EDH_ArrowUpdateNr = 0
	else
		EDH_ArrowUpdateNr = EDH_ArrowUpdateNr + 1
	end
end

EDH.ArrowFrame.LoopUpdate = CreateFrame("frame")
EDH.ArrowFrame.LoopUpdate:SetScript("OnUpdate", EDH.ArrowUpdate)
EDH.EventFrame = CreateFrame("Frame")
EDH.EventFrame:RegisterEvent ("ADDON_LOADED")

EDH.EventFrame:SetScript("OnEvent", function(self, event, ...)
	if (event=="ADDON_LOADED") then
		local arg1, arg2, arg3, arg4, arg5 = ...;
			if (not EDHC1) then
				EDHC1 = {}
			end
			if (not EDHC1[EDH.Realm]) then
				EDHC1[EDH.Realm] = {}
			end
			if (not EDHC1[EDH.Realm][EDH.Name]) then
				EDHC1[EDH.Realm][EDH.Name] = {}
			end
			if (not EDHC1[EDH.Realm][EDH.Name]["Completed"]) then
				EDHC1[EDH.Realm][EDH.Name]["Completed"] = {}
			end
			if (not EDHC1[EDH.Realm][EDH.Name]["Elite"]) then
				EDHC1[EDH.Realm][EDH.Name]["Elite"] = {}
			end
			if (not EDHC1[EDH.Realm][EDH.Name]["Zones"]) then
				EDHC1[EDH.Realm][EDH.Name]["Zones"] = {}
			end
			SlashCmdList["EDH_Cmd"] = EDH_SlashCmd
			SLASH_EDH_Cmd1 = "/EDH"
			EDH.ReupdateQlistTimer = EDH.EventFrame:CreateAnimationGroup()
			EDH.ReupdateQlistTimer.anim = EDH.ReupdateQlistTimer:CreateAnimation()
			EDH.ReupdateQlistTimer.anim:SetDuration(5)
			EDH.ReupdateQlistTimer:SetLooping("REPEAT")
			EDH.ReupdateQlistTimer:SetScript("OnLoop", function(self, event, ...)
				EDH.QH.BookingList.UpdateQuestList = 1
				EDH.ReupdateQlistTimer:Stop()
			end)
			EDH.CheckQcountTimer = EDH.EventFrame:CreateAnimationGroup()
			EDH.CheckQcountTimer.anim = EDH.CheckQcountTimer:CreateAnimation()
			EDH.CheckQcountTimer.anim:SetDuration(2)
			EDH.CheckQcountTimer:SetLooping("REPEAT")
			EDH.CheckQcountTimer:SetScript("OnLoop", function(self, event, ...)
				EDH.QH.BookingList.ExtraQ = 1
				EDH.CheckQcountTimer:Stop()
			end)
	end
end)

