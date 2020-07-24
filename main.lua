
  local LibPlayerSpells = LibStub('LibPlayerSpells-1.0')
  currentGroupInterrupts = {};
  function clearTable()
    firstPerson:SetText("");
    secondPerson:SetText("");
    thirdPerson:SetText("");
    fourthPerson:SetText("");
    fifthPerson:SetText("");
    currentGroupInterrupts = {};
    --interruptLookupTable = {};
    priority = 1;
    s1=nil;
    s2=nil;
    s3=nil;
    s4=nil;
    s5=nil;
    EDHInterfaceFrame:Hide();
    --f=nil;
  end
  function initializeInterface()
    EDHInterfaceFrame = CreateFrame("Frame", "testframe", UIParent);
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
    local PADDING_FOR_BAR = -4;
    s1 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s1:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8", "BACKGROUND")
    s1:SetStatusBarColor(1,0,.5,0)
    s1:SetSize(150 ,22) -- width, height
    s1:SetPoint("TOPLEFT", 0, -25)
    firstPerson=s1:CreateFontString(firstPerson,"OVERLAY","GameFontNormal");
    firstPerson:SetPoint("TOP", 0, PADDING_FOR_BAR);

    s2 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s2:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8", "BACKGROUND")
    s2:SetStatusBarColor(1,0,.5,0)
    s2:SetSize(150 ,22) -- width, height
    s2:SetPoint("TOPLEFT", 0, -55)
    secondPerson=s2:CreateFontString(secondPerson,"OVERLAY","GameFontNormal");
    secondPerson:SetPoint("TOP", 0, PADDING_FOR_BAR);


    s3 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s3:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s3:SetStatusBarColor(1,0,.5,0)
    s3:SetSize(150 ,22) -- width, height
    s3:SetPoint("TOPLEFT", 0, -85)
    thirdPerson=s3:CreateFontString(thirdPerson,"OVERLAY","GameFontNormal");
    thirdPerson:SetPoint("TOP", 0, PADDING_FOR_BAR);

    s4 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s4:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s4:SetStatusBarColor(1,0,.5,0)
    s4:SetSize(150 ,22) -- width, height
    s4:SetPoint("TOPLEFT", 0, -115)
    fourthPerson=s4:CreateFontString(fourthPerson,"OVERLAY","GameFontNormal");
    fourthPerson:SetPoint("TOP", 0, PADDING_FOR_BAR);

    s5 = CreateFrame("StatusBar", "MyButton", EDHInterfaceFrame)
    s5:SetStatusBarTexture("Interface\\BUTTONS\\WHITE8X8")
    s5:SetStatusBarColor(1,0,.5,0)
    s5:SetSize(150 ,22) -- width, height
    s5:SetPoint("TOPLEFT", 0, -145)
    fifthPerson=s5:CreateFontString(fifthPerson,"OVERLAY","GameFontNormal");
    fifthPerson:SetPoint("TOP", 0, PADDING_FOR_BAR);

    EDHInterfaceFrame:Hide();
  end

  nextNumber = 0;
  function interruptTracker(self, event, target, castGUID, spellID, ...)
    if not (next(currentGroupInterrupts) == nil) then
      for i, thing in pairs(currentGroupInterrupts) do
        --print(thing.interruptID .. " " ..spellID)
        if((thing.interruptID == spellID) or (currentGroupInterrupts[i].tableKey == "BalanceDruid")) then
          local spellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellID)
            if(currentGroupInterrupts[i].tableKey == "BalanceDruid") then
              -- I hate boomkins
              cooldownMS = "60000";
              gcdMS = "0";
            else
              cooldownMS, gcdMS = GetSpellBaseCooldown(spellID)
              --print("Triggered!" .. cooldownMS .. " " .. gcdMS)
              cooldownSeconds = cooldownMS/1000
              startCounting(i, cooldownSeconds);
              
              if(i==GetNumGroupMembers()) then
                i=0; -- my take on your generic "circular queue"
              end 
              updateUI(i+1)
              SendChatMessage(thing.individualName .. " used " .. spellName .. "   NEXT: " .. currentGroupInterrupts[i+1].individualName ,EntropiChatSaveTo ,"COMMON" ,1);  
            end
        end
      end
    end
    
  end
function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end
function startCounting(priorityTarget, seconds)
  --print("counting for "..priorityTarget .. seconds)
  if(not (s1 == nil)) then
    if     priorityTarget == 1 then numberToChange = firstPerson:GetText():gsub("( [0-9]*\.[0-9]*s)" , ""); firstPerson:SetText(numberToChange .. " "..seconds.."s"); s1:SetValue(seconds)
    elseif priorityTarget == 2 then numberToChange = secondPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); secondPerson:SetText(numberToChange .." ".. seconds.."s"); s2:SetValue(seconds)
    elseif priorityTarget == 3 then numberToChange = thirdPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); thirdPerson:SetText(numberToChange .." ".. seconds.."s"); s3:SetValue(seconds)
    elseif priorityTarget == 4 then numberToChange = fourthPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); fourthPerson:SetText(numberToChange .." ".. seconds.."s") s4:SetValue(seconds)
    elseif priorityTarget == 5 then numberToChange = fifthPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); fifthPerson:SetText(numberToChange .." ".. seconds.."s") s5:SetValue(seconds)
    end
    if(seconds >= 0.1) then
    C_Timer.After(0.1, function()
      startCounting(priorityTarget, round(seconds-0.1, 1))
    end);
    else
      if     priorityTarget == 1 then numberToChange = firstPerson:GetText():gsub("( [0-9]*\.[0-9]*s)" , ""); firstPerson:SetText(numberToChange); s1:SetValue(currentGroupInterrupts[1].cooldown)
      elseif priorityTarget == 2 then numberToChange = secondPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); secondPerson:SetText(numberToChange); s2:SetValue(currentGroupInterrupts[2].cooldown)
      elseif priorityTarget == 3 then numberToChange = thirdPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); thirdPerson:SetText(numberToChange); s3:SetValue(currentGroupInterrupts[3].cooldown)
      elseif priorityTarget == 4 then numberToChange = fourthPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); fourthPerson:SetText(numberToChange); s4:SetValue(currentGroupInterrupts[4].cooldown)
      elseif priorityTarget == 5 then numberToChange = fifthPerson:GetText():gsub(" ([0-9]*\.[0-9]*s)" , ""); fifthPerson:SetText(numberToChange); s5:SetValue(currentGroupInterrupts[5].cooldown)
      end
    end 
  end
end

NextPersonChar = "--> ";
function updateUI(toArrow)
  clearArrows(toArrow)
  if     toArrow == 1 then textToChange = firstPerson:GetText():gsub(NextPersonChar , ""); firstPerson:SetText(NextPersonChar..textToChange)
  elseif toArrow == 2 then textToChange = secondPerson:GetText():gsub(NextPersonChar, ""); secondPerson:SetText(NextPersonChar..textToChange)
  elseif toArrow == 3 then textToChange = thirdPerson:GetText():gsub(NextPersonChar, ""); thirdPerson:SetText(NextPersonChar..textToChange)
  elseif toArrow == 4 then textToChange = fourthPerson:GetText():gsub(NextPersonChar, ""); fourthPerson:SetText(NextPersonChar..textToChange)
  elseif toArrow == 5 then textToChange = fifthPerson:GetText():gsub(NextPersonChar, ""); fifthPerson:SetText(NextPersonChar..textToChange)
  end
end
function clearArrows(toArrow)
  if toArrow == 1 then secondPerson:SetText(secondPerson:GetText():gsub(NextPersonChar, ""));
    if not (thirdPerson:GetText() == nil) then thirdPerson:SetText(thirdPerson:GetText():gsub(NextPersonChar, "")); end
    if not (fourthPerson:GetText() == nil) then fourthPerson:SetText(fourthPerson:GetText():gsub(NextPersonChar, ""));end
    if not (fifthPerson:GetText() == nil) then fifthPerson:SetText(fifthPerson:GetText():gsub(NextPersonChar, ""));end
  elseif toArrow == 2 then firstPerson:SetText(firstPerson:GetText():gsub(NextPersonChar, ""));
    if not (thirdPerson:GetText() == nil) then thirdPerson:SetText(thirdPerson:GetText():gsub(NextPersonChar, "")); end
    if not (fourthPerson:GetText() == nil) then fourthPerson:SetText(fourthPerson:GetText():gsub(NextPersonChar, ""));end
    if not (fifthPerson:GetText() == nil) then fifthPerson:SetText(fifthPerson:GetText():gsub(NextPersonChar, ""));end
  elseif toArrow == 3 then secondPerson:SetText(secondPerson:GetText():gsub(NextPersonChar, ""));
    if not (firstPerson:GetText() == nil) then firstPerson:SetText(firstPerson:GetText():gsub(NextPersonChar, "")); end
    if not (fourthPerson:GetText() == nil) then fourthPerson:SetText(fourthPerson:GetText():gsub(NextPersonChar, ""));end
    if not (fifthPerson:GetText() == nil) then fifthPerson:SetText(fifthPerson:GetText():gsub(NextPersonChar, ""));end
  elseif toArrow == 4 then secondPerson:SetText(secondPerson:GetText():gsub(NextPersonChar, ""));
    if not (thirdPerson:GetText() == nil) then thirdPerson:SetText(thirdPerson:GetText():gsub(NextPersonChar, "")); end
    if not (firstPerson:GetText() == nil) then firstPerson:SetText(firstPerson:GetText():gsub(NextPersonChar, ""));end
    if not (fifthPerson:GetText() == nil) then fifthPerson:SetText(fifthPerson:GetText():gsub(NextPersonChar, ""));end
  elseif toArrow == 5 then secondPerson:SetText(secondPerson:GetText():gsub(NextPersonChar, ""));
    if not (thirdPerson:GetText() == nil) then thirdPerson:SetText(thirdPerson:GetText():gsub(NextPersonChar, "")); end
    if not (fourthPerson:GetText() == nil) then fourthPerson:SetText(fourthPerson:GetText():gsub(NextPersonChar, ""));end
    if not (firstPerson:GetText() == nil) then firstPerson:SetText(firstPerson:GetText():gsub(NextPersonChar, ""));end
  end
end
-- you should replace this with a better one
local print = function (msg)
  DEFAULT_CHAT_FRAME:AddMessage(msg)
end
currentPartyInterrupt = {}
is_casting = false
SampleTracker = CreateFrame("Frame", nil, UIParent)
SampleTracker:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED")
SampleTracker:SetScript("OnEvent", interruptTracker)

local frame = CreateFrame("FRAME"); -- Need a frame to respond to events
frame:RegisterEvent("ADDON_LOADED"); -- Fired when saved variables are loaded
frame:RegisterEvent("PLAYER_LOGOUT"); -- Fired when about to log out

function frame:OnEvent(event, arg1)
  if event == "ADDON_LOADED" and arg1 == "EntropiDungeonHelper" then
    if EntropiChatSaveTo == nil then
      EntropiChatSaveTo = "PARTY"
      partyButton:SetChecked(1);
    end
  end
end
frame:SetScript("OnEvent", frame.OnEvent);
  
  
  
  


local f = CreateFrame ("frame", "EntropiOptions", UIParent)
f.name = "EDH"
f.logo = f:CreateTexture (nil, "overlay")
f.logo:SetPoint ("center", f, "center", 0, 0)
f.logo:SetPoint ("top", f, "top", 25, 56)
f.logo:SetSize (256, 128)
InterfaceOptions_AddCategory (f)

local uniquealyzer = 1;
function createCheckbutton(parent, x_loc, y_loc, displayname, tooltip, setScriptFunction)
  uniquealyzer = uniquealyzer + 1;
  
  local checkbutton = CreateFrame("CheckButton", "my_addon_checkbutton_0" .. uniquealyzer, parent, "ChatConfigCheckButtonTemplate");
  checkbutton:SetPoint("TOPLEFT", x_loc, y_loc);
  getglobal(checkbutton:GetName() .. 'Text'):SetText(displayname);
  checkbutton.tooltip = tooltip;

  return checkbutton;
end
partyButton = createCheckbutton(f, 10, -100, "Party","Output EDH Order to Party");
partyButton:SetScript("OnClick", 
function()
  yellButton:SetChecked(false);
  sayButton:SetChecked(false);
  EntropiChatSaveTo = "PARTY";
end
);
yellButton = createCheckbutton(f, 10, -150, "Yell","Output EDH Order to Yell");
yellButton:SetScript("OnClick", 
function()
  partyButton:SetChecked(false);
  sayButton:SetChecked(false);
  EntropiChatSaveTo = "YELL";
end
);
sayButton = createCheckbutton(f, 10, -200, "Say","Output EDH Order to Say");
sayButton:SetScript("OnClick", 
function()
  partyButton:SetChecked(false);
  yellButton:SetChecked(false);
  EntropiChatSaveTo = "SAY";
end
);
-- Each Class/Spec Combo in the game
tableOfInterrupts = {
  {id = "BalanceDruid", cooldown =60, cleanName = "Balance Druid", playerName = ""},
  {id = "DAMAGERDruid", cooldown =15, cleanName = "Feral Druid", playerName = ""},
  {id = "TANKDruid", cooldown =15, cleanName = "Guardian Druid", playerName = ""},
  {id = "DAMAGERHunter", cooldown =24, cleanName = "Hunter", playerName = ""},
  {id = "DAMAGERPriest", cooldown =45, cleanName = "Shadow Priest", playerName = ""},
  {id = "DAMAGERShaman", cooldown =12, cleanName = "DPS Shaman", playerName = ""},
  {id = "HEALERShaman", cooldown =12, cleanName = "Restoration Shaman", playerName = ""},
  {id = "DAMAGERWarrior", cooldown =15, cleanName = "DPS Warrior", playerName = ""},
  {id = "TANKWarrior", cooldown =15, cleanName = "Protection Warrior", playerName = ""},
  {id = "DAMAGERPaladin", cooldown =15, cleanName = "Retribution Paladin", playerName = ""},
  {id = "TANKPaladin", cooldown =15, cleanName = "Protection Paladin", playerName = ""},
  {id = "DAMAGERDemon Hunter", cooldown =15, cleanName = "Havoc Demon Hunter", playerName = ""},
  {id = "TANKDemon Hunter", cooldown =15, cleanName = "Vengeance Demon Hunter", playerName = ""},
  {id = "DAMAGERDeath Knight", cooldown =15, cleanName = "DPS Death Knight", playerName = ""},
  {id = "TANKDeath Knight", cooldown =15, cleanName = "Blood Death Knight", playerName = ""},
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

function getColored(unit)
  if not unit then return end
  local function DecimalToHex(r,g,b)
      return string.format("|cff%02x%02x%02x", r*255, g*255, b*255)
  end
  local playername = UnitName(unit)
  local playerclass,PLAYERCLASS = UnitClass(unit)
  if not PLAYERCLASS then return unit end
  local classcolor = RAID_CLASS_COLORS[PLAYERCLASS]
  if not classcolor then return unit end
  local r,g,b = classcolor.r,classcolor.g,classcolor.b
  if UnitIsDeadOrGhost(unit) then r,g,b = 0.5,0.5,0.5 end        
  local classcolorhex = DecimalToHex(r,g,b)
  return classcolorhex..playername.."|r"
end

groupindex = 0;


function compare(a,b)
  return a.cooldown < b.cooldown
end

function dungeonHandler(self, event, isInitialLogin, isReloadingUi, ...)
  inInstance, instanceType = IsInInstance()
  if(s1 == nil) then
    initializeInterface()
  end
  --printInterrupts()
  if(instanceType == "party") then
      name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID = GetInstanceInfo()
      ChatFrame1:AddMessage("EDH -- You have entered: "..name, 125, 0, 125, 3)
      
      printInterrupts()
      
  end
  -- Iterate through spells that have a cooldown, are/apply an aura and are either survival or mana-regenerating skills.

end

function printInterrupts()
  if(UnitInParty("player")) then
    local isTrue = UnitIsGroupLeader("player")
    if(isTrue) then
    priority = 1;
    SendChatMessage("EDH:Available Interrupts",EntropiChatSaveTo ,"COMMON" ,1);
    for groupindex = 1,MAX_PARTY_MEMBERS+1 do
      
      local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(groupindex);
      if(class) then 

        tableKey = combatRole..class
        --ChatFrame1:AddMessage(name .. " " .. interruptLookupTable[tableKey].cooldown, 125, 0, 125)
        if(class == "Druid") then
          --id = GetInspectSpecialization("party"..groupIndex)
          powerType, powerTypeString = UnitPowerType("party"..groupindex);
          --ChatFrame1:AddMessage(powerType, 125, 0, 125)
          --print(powerType)
          if (powerType == 8) then -- Power Type 0 is Energy, 1 is mana or DC, Astral is 8
            --print("ree")
            tableKey = "BalanceDruid"
          end
        end
        if(not (interruptLookupTable[tableKey].cooldown == -1)) then --Ignores Healers
          strippedclass = class:gsub("%s+", "")
          for spellId, flags, providers, modifiedSpells, moreFlags in LibPlayerSpells:IterateSpells(strippedclass:upper()) do

            spellName, rank, icon, castTime, minRange, maxRange = GetSpellInfo(spellId)
            
            if bit.band(flags, LibPlayerSpells.constants.INTERRUPT) ~= 0 then
              -- This spell is an aura, do something meaningful with it.
              --start, duration, enabled = GetSpellCooldown(spellID, "BOOKTYPE_SPELL");
              interruptSpellId = spellId
              cooldownMS, gcdMS = GetSpellBaseCooldown(spellId)
              SendChatMessage(spellName .. ": "..cooldownMS/1000 .. "s",EntropiChatSaveTo ,"COMMON" ,1);
            end
          end
          currentGroupInterrupts[priority] = {individualName = name, cooldown = cooldownMS/1000, className = class:upper(), interruptID = interruptSpellId, tableKey = tableKey}
            --SendChatMessage(name..": "..interruptLookupTable[tableKey].cooldown.." seconds","PARTY" ,"COMMON" ,1);
          priority = priority + 1;
          --table.sort(currentGroupInterrupts, compare)
          EDHInterfaceFrame:Show();
        end

      end
    end
  end
    table.sort(currentGroupInterrupts, compare)
    --SendChatMessage("EDH:Suggested Interrupt Order",EntropiChatSaveTo ,"COMMON" ,1);
    for k, v in pairs(currentGroupInterrupts) do
      --ChatFrame1:AddMessage(k .. " " .. v.cooldown, 125, 0, 125, 3)
      v.className = strupper(v.className)
      v.className = v.className:gsub(" ", "")
      if(v) then
        local classColorRGB = RAID_CLASS_COLORS[v.className]
          
        if(k == 1) then
          timing = "First or {Diamond}"
          firstPerson:SetText(v.individualName)
          firstPerson:SetTextColor(255, 255, 255)
          firstPerson:SetFont("Fonts\\FRIZQT__.TTF", 12, "OUTLINE")
          s1:SetValue(cooldownMS/1000)
          s1:SetStatusBarColor(classColorRGB.r,classColorRGB.g,classColorRGB.b,.5)
          s1:SetMinMaxValues(0, currentGroupInterrupts[1].cooldown)
        elseif(k==2) then
          timing = "Second or {Moon}"
          secondPerson:SetText(v.individualName)
          secondPerson:SetTextColor(255, 255, 255)
          secondPerson:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
          s2:SetStatusBarColor(classColorRGB.r,classColorRGB.g,classColorRGB.b,.5)
          s2:SetMinMaxValues(0, currentGroupInterrupts[2].cooldown)
        elseif(k==3) then
          timing = "Third or {Square}"
          thirdPerson:SetText(v.individualName)
          thirdPerson:SetTextColor(255, 255, 255)
          thirdPerson:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
          s3:SetStatusBarColor(classColorRGB.r,classColorRGB.g,classColorRGB.b,.5)
          s3:SetMinMaxValues(0, currentGroupInterrupts[3].cooldown)
        elseif(k==4) then
          timing = "Fourth or {Circle}"
          fourthPerson:SetText(v.individualName)
          fourthPerson:SetTextColor(255, 255, 255)
          fourthPerson:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
          s4:SetStatusBarColor(classColorRGB.r,classColorRGB.g,classColorRGB.b,.5)
          s4:SetMinMaxValues(0, currentGroupInterrupts[4].cooldown)
        else
          timing = "Fifth or {Star}"
          fifthPerson:SetText(v.individualName)
          fifthPerson:SetTextColor(255, 255, 255)
          fifthPerson:SetFont("Fonts\\FRIZQT__.TTF", 13, "OUTLINE")
          s5:SetStatusBarColor(classColorRGB.r,classColorRGB.g,classColorRGB.b,.5)
          s5:SetMinMaxValues(0, currentGroupInterrupts[5].cooldown)
        end
        --SendChatMessage(timing ..": "..v.individualName,EntropiChatSaveTo,"COMMON" ,1, 3);
      end
    end
  end
end
-- function inspectHandler(self, event,...)
--   local specID = GetInspectSpecialization("party"..groupindex)
--   if specID and specID > 0 then
--     id, specName, description, icon, role, class = GetSpecializationInfoByID(specID)
--     SendChatMessage(specName ,"PARTY" ,"COMMON" ,1);
--   end
--   ClearInspectPlayer()
-- end
local playerEnterWorld = CreateFrame("Frame");
playerEnterWorld:RegisterEvent("PLAYER_ENTERING_WORLD");
playerEnterWorld:SetScript("OnEvent", dungeonHandler);

SLASH_EDH1 = "/edh"
SLASH_EDH2 = "/dh"
SlashCmdList["EDH"] = function(msg)
   if msg == "off"  or msg == "hide" then
    EDHInterfaceFrame:Hide();
   end
   if msg == "on" then
    EDHInterfaceFrame:Show();
   end
   if msg == "" then
    if(s1 == nil) then
      initializeInterface();
    end
    printInterrupts()
   end
   if msg == "clear" then
    clearTable()
   end
end 


