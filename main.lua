-- Each Class/Spec Combo in the game
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

function printInterrupts()
  if(UnitInParty("player")) then
    priority = 1;
    for groupindex = 1,MAX_PARTY_MEMBERS do
      
      local name, rank, subgroup, level, class, fileName, zone, online, isDead, role, isML, combatRole = GetRaidRosterInfo(groupindex);
      if(class) then 
        --ChatFrame1:AddMessage(name, 125, 0, 125)
        tableKey = combatRole..class
        if(class == "Druid") then
          powerType, powerTypeString = UnitPowerType("party"..groupindex);
          --ChatFrame1:AddMessage(powerType, 125, 0, 125)
          if (powerType == 8 and combatRole == "DAMAGER") then -- Power Type 0 is Energy, 1 is mana or DC, Astral is 8
            tableKey = "BalanceDruid"
          end
          
          
        end
        currentGroupInterrupts[priority] = {individualName = name, cooldown = interruptLookupTable[tableKey].cooldown}
          --SendChatMessage(name..": "..interruptLookupTable[tableKey].cooldown.." seconds","PARTY" ,"COMMON" ,1);
        priority = priority + 1;
        --table.sort(currentGroupInterrupts, compare)


      end
    end
    table.sort(currentGroupInterrupts, compare)
    SendChatMessage("EDH:Suggested Interrupt Order","PARTY" ,"COMMON" ,1);
    for k, v in pairs(currentGroupInterrupts) do
      --ChatFrame1:AddMessage(k .. " " .. v.cooldown, 125, 0, 125, 3)
      if(k == 1) then
        timing = "First or {Diamond}"
      elseif(k==2) then
        timing = "Second or {Moon}"
      elseif(k==3) then
        timing = "Third or {Square}"
      elseif(k==4) then
        timing = "Fourth or {Circle}"
      else
        timing = "Fifth or {Star}"
      end
      if(v) then
        SendChatMessage(timing ..": "..v.individualName,"PARTY" ,"COMMON" ,1, 3);
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
   printInterrupts()
end 
-- local inspectReady = CreateFrame("FRAME");
-- inspectReady:RegisterEvent("INSPECT_READY");
-- inspectReady:SetScript("OnEvent", inspectHandler);



-- interruptLookupTable = {};
-- interruptLookupTable["BalanceDruid"] = 60
-- interruptLookupTable["DAMAGERDruid"] = 15
-- interruptLookupTable["TANKDruid"] = 15
-- interruptLookupTable["DAMAGERHunter"] = 24
-- interruptLookupTable["DAMAGERPriest"] = 45
-- interruptLookupTable["DAMAGERShaman"] = 12
-- interruptLookupTable["HEALERShaman"] = 12
-- interruptLookupTable["DAMAGERWarrior"] = 15
-- interruptLookupTable["TANKWarrior"] = 15
-- interruptLookupTable["DAMAGERPaladin"] = 15
-- interruptLookupTable["TANKPaladin"] = 15
-- interruptLookupTable["DAMAGERDemonHunter"] = 15
-- interruptLookupTable["TANKDemonHunter"] = 15
-- interruptLookupTable["DAMAGERDeathKnight"] = 15
-- interruptLookupTable["TANKDeathKnight"] = 15
-- interruptLookupTable["TANKMonk"] = 15
-- interruptLookupTable["DAMAGERMonk"] = 15
-- interruptLookupTable["DAMAGERRogue"] = 15
-- interruptLookupTable["DAMAGERMage"] = 24
-- interruptLookupTable["DAMAGERWarlock"] = 24
-- interruptLookupTable["HEALERPaladin"] = -1
-- interruptLookupTable["HEALERDruid"] = -1
-- interruptLookupTable["HEALERPriest"] = -1
-- interruptLookupTable["HEALERMonk"] = -1


