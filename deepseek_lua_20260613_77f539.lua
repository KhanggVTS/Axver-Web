-- Dojo Hub | Auto Level + Fast Attack + Giữ độ cao trên đầu quái
-- Dựa trên cơ chế AxverHub

local Players = game:GetService("Players")
local RS = game:GetService("ReplicatedStorage")
local Workspace = game:GetService("Workspace")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer
local Net = require(RS.Modules.Net)
local Combat = require(RS.Modules.CombatUtil)

-- ============ KHỞI TẠO VARIABLES ============
_G.AutoLevel = false
_G.AutoFastAttack = true
_G.BringMob = true
_G.AttackRange = 60
_G.FastDelay = 0.08
_G.ComboCount = 2
_G.BringRange = 235
_G.MobHeight = 20
_G.World = nil
_G.SpinPosition = false
_G.FarmDistance = 35

-- ============ XÁC ĐỊNH WORLD ============
if game.PlaceId == 2753915549 or game.PlaceId == 85211729168715 then
    _G.World = 1
elseif game.PlaceId == 4442272183 or game.PlaceId == 79091703265657 then
    _G.World = 2
elseif game.PlaceId == 7449423635 or game.PlaceId == 100117331123089 then
    _G.World = 3
end

-- ============ DATA QUEST THEO LEVEL ============
local function GetQuestData()
    local lvl = plr.Data.Level.Value
    local data = {}
    
    if _G.World == 1 then
        if lvl <= 9 then
            data = {Mon = "Bandit", Quest = "BanditQuest1", Level = 1, QuestPos = CFrame.new(1059,17,1546), MobPos = CFrame.new(943,45,1562)}
        elseif lvl <= 14 then
            data = {Mon = "Monkey", Quest = "JungleQuest", Level = 1, QuestPos = CFrame.new(-1598,37,153), MobPos = CFrame.new(-1524,50,37)}
        elseif lvl <= 29 then
            data = {Mon = "Gorilla", Quest = "JungleQuest", Level = 2, QuestPos = CFrame.new(-1598,37,153), MobPos = CFrame.new(-1128,40,-451)}
        elseif lvl <= 39 then
            data = {Mon = "Pirate", Quest = "BuggyQuest1", Level = 1, QuestPos = CFrame.new(-1140,4,3829), MobPos = CFrame.new(-1262,40,3905)}
        elseif lvl <= 59 then
            data = {Mon = "Brute", Quest = "BuggyQuest1", Level = 2, QuestPos = CFrame.new(-1140,4,3829), MobPos = CFrame.new(-976,55,4304)}
        elseif lvl <= 74 then
            data = {Mon = "Desert Bandit", Quest = "DesertQuest", Level = 1, QuestPos = CFrame.new(897,6,4389), MobPos = CFrame.new(924,7,4482)}
        elseif lvl <= 89 then
            data = {Mon = "Desert Officer", Quest = "DesertQuest", Level = 2, QuestPos = CFrame.new(897,6,4389), MobPos = CFrame.new(1608,9,4371)}
        elseif lvl <= 99 then
            data = {Mon = "Snow Bandit", Quest = "SnowQuest", Level = 1, QuestPos = CFrame.new(1385,87,-1298), MobPos = CFrame.new(1362,120,-1531)}
        elseif lvl <= 119 then
            data = {Mon = "Snowman", Quest = "SnowQuest", Level = 2, QuestPos = CFrame.new(1385,87,-1298), MobPos = CFrame.new(1243,140,-1437)}
        elseif lvl <= 149 then
            data = {Mon = "Chief Petty Officer", Quest = "MarineQuest2", Level = 1, QuestPos = CFrame.new(-5035,29,4326), MobPos = CFrame.new(-4881,23,4274)}
        elseif lvl <= 174 then
            data = {Mon = "Sky Bandit", Quest = "SkyQuest", Level = 1, QuestPos = CFrame.new(-4844,718,-2621), MobPos = CFrame.new(-4953,296,-2899)}
        elseif lvl <= 189 then
            data = {Mon = "Dark Master", Quest = "SkyQuest", Level = 2, QuestPos = CFrame.new(-4844,718,-2621), MobPos = CFrame.new(-5260,391,-2229)}
        elseif lvl <= 209 then
            data = {Mon = "Prisoner", Quest = "PrisonerQuest", Level = 1, QuestPos = CFrame.new(5306,2,477), MobPos = CFrame.new(5099,0,474)}
        elseif lvl <= 249 then
            data = {Mon = "Dangerous Prisoner", Quest = "PrisonerQuest", Level = 2, QuestPos = CFrame.new(5306,2,477), MobPos = CFrame.new(5655,16,866)}
        elseif lvl <= 274 then
            data = {Mon = "Toga Warrior", Quest = "ColosseumQuest", Level = 1, QuestPos = CFrame.new(-1581,7,-2982), MobPos = CFrame.new(-1820,51,-2741)}
        elseif lvl <= 299 then
            data = {Mon = "Gladiator", Quest = "ColosseumQuest", Level = 2, QuestPos = CFrame.new(-1581,7,-2982), MobPos = CFrame.new(-1268,30,-2996)}
        elseif lvl <= 324 then
            data = {Mon = "Military Soldier", Quest = "MagmaQuest", Level = 1, QuestPos = CFrame.new(-5319,12,8515), MobPos = CFrame.new(-5335,46,8638)}
        elseif lvl <= 374 then
            data = {Mon = "Military Spy", Quest = "MagmaQuest", Level = 2, QuestPos = CFrame.new(-5319,12,8515), MobPos = CFrame.new(-5803,86,8829)}
        elseif lvl <= 449 then
            data = {Mon = "Fishman Warrior", Quest = "FishmanQuest", Level = 1, QuestPos = CFrame.new(61122,18,1567), MobPos = CFrame.new(60998,50,1534)}
        elseif lvl <= 474 then
            data = {Mon = "God's Guard", Quest = "SkyExp1Quest", Level = 1, QuestPos = CFrame.new(-4720,846,-1951), MobPos = CFrame.new(-4720,846,-1951)}
        elseif lvl <= 524 then
            data = {Mon = "Shanda", Quest = "SkyExp1Quest", Level = 2, QuestPos = CFrame.new(-7861,5545,-381), MobPos = CFrame.new(-7741,5580,-395)}
        elseif lvl <= 649 then
            data = {Mon = "Galley Pirate", Quest = "FountainQuest", Level = 1, QuestPos = CFrame.new(5258,39,4052), MobPos = CFrame.new(5391,70,4023)}
        else
            data = {Mon = "Galley Captain", Quest = "FountainQuest", Level = 2, QuestPos = CFrame.new(5258,39,4052), MobPos = CFrame.new(5985,70,4790)}
        end
    elseif _G.World == 2 then
        if lvl <= 724 then
            data = {Mon = "Raider", Quest = "Area1Quest", Level = 1, QuestPos = CFrame.new(-427,73,1835), MobPos = CFrame.new(-614,90,2240)}
        elseif lvl <= 774 then
            data = {Mon = "Mercenary", Quest = "Area1Quest", Level = 2, QuestPos = CFrame.new(-427,73,1835), MobPos = CFrame.new(-867,110,1621)}
        elseif lvl <= 874 then
            data = {Mon = "Swan Pirate", Quest = "Area2Quest", Level = 1, QuestPos = CFrame.new(635,73,919), MobPos = CFrame.new(635,73,919)}
        elseif lvl <= 899 then
            data = {Mon = "Marine Lieutenant", Quest = "MarineQuest3", Level = 1, QuestPos = CFrame.new(-2441,73,-3219), MobPos = CFrame.new(-2552,110,-3050)}
        elseif lvl <= 949 then
            data = {Mon = "Marine Captain", Quest = "MarineQuest3", Level = 2, QuestPos = CFrame.new(-2441,73,-3219), MobPos = CFrame.new(-1695,110,-3299)}
        elseif lvl <= 974 then
            data = {Mon = "Zombie", Quest = "ZombieQuest", Level = 1, QuestPos = CFrame.new(-5495,48,-794), MobPos = CFrame.new(-5715,90,-917)}
        elseif lvl <= 999 then
            data = {Mon = "Vampire", Quest = "ZombieQuest", Level = 2, QuestPos = CFrame.new(-5495,48,-794), MobPos = CFrame.new(-6027,50,-1130)}
        elseif lvl <= 1049 then
            data = {Mon = "Snow Trooper", Quest = "SnowMountainQuest", Level = 1, QuestPos = CFrame.new(607,401,-5371), MobPos = CFrame.new(445,440,-5175)}
        elseif lvl <= 1099 then
            data = {Mon = "Winter Warrior", Quest = "SnowMountainQuest", Level = 2, QuestPos = CFrame.new(607,401,-5371), MobPos = CFrame.new(1224,460,-5332)}
        elseif lvl <= 1124 then
            data = {Mon = "Lab Subordinate", Quest = "IceSideQuest", Level = 1, QuestPos = CFrame.new(-6061,16,-4904), MobPos = CFrame.new(-5941,50,-4322)}
        elseif lvl <= 1174 then
            data = {Mon = "Horned Warrior", Quest = "IceSideQuest", Level = 2, QuestPos = CFrame.new(-6061,16,-4904), MobPos = CFrame.new(-6306,50,-5752)}
        elseif lvl <= 1199 then
            data = {Mon = "Magma Ninja", Quest = "FireSideQuest", Level = 1, QuestPos = CFrame.new(-5430,16,-5298), MobPos = CFrame.new(-5233,60,-6227)}
        elseif lvl <= 1249 then
            data = {Mon = "Lava Pirate", Quest = "FireSideQuest", Level = 2, QuestPos = CFrame.new(-5430,16,-5298), MobPos = CFrame.new(-4955,60,-4836)}
        elseif lvl <= 1324 then
            data = {Mon = "Ship Deckhand", Quest = "ShipQuest1", Level = 1, QuestPos = CFrame.new(1037,125,32911), MobPos = CFrame.new(1212,150,33059)}
        elseif lvl <= 1374 then
            data = {Mon = "Arctic Warrior", Quest = "FrostQuest", Level = 1, QuestPos = CFrame.new(5667,26,-6486), MobPos = CFrame.new(5966,62,-6179)}
        else
            data = {Mon = "Water Fighter", Quest = "ForgottenQuest", Level = 2, QuestPos = CFrame.new(-3054,235,-10142), MobPos = CFrame.new(-3352,285,-10534)}
        end
    elseif _G.World == 3 then
        if lvl <= 1524 then
            data = {Mon = "Pirate Millionaire", Quest = "PiratePortQuest", Level = 1, QuestPos = CFrame.new(-290,42,5581), MobPos = CFrame.new(-245,47,5584)}
        elseif lvl <= 1574 then
            data = {Mon = "Pistol Billionaire", Quest = "PiratePortQuest", Level = 2, QuestPos = CFrame.new(-290,42,5581), MobPos = CFrame.new(-187,86,6013)}
        elseif lvl <= 1599 then
            data = {Mon = "Dragon Crew Warrior", Quest = "AmazonQuest", Level = 1, QuestPos = CFrame.new(5832,51,-1101), MobPos = CFrame.new(6141,51,-1340)}
        elseif lvl <= 1624 then
            data = {Mon = "Dragon Crew Archer", Quest = "AmazonQuest", Level = 2, QuestPos = CFrame.new(5833,51,-1103), MobPos = CFrame.new(6616,441,446)}
        elseif lvl <= 1649 then
            data = {Mon = "Female Islander", Quest = "AmazonQuest2", Level = 1, QuestPos = CFrame.new(5446,601,749), MobPos = CFrame.new(4685,735,815)}
        elseif lvl <= 1699 then
            data = {Mon = "Giant Islander", Quest = "AmazonQuest2", Level = 2, QuestPos = CFrame.new(5446,601,749), MobPos = CFrame.new(4729,590,-36)}
        elseif lvl <= 1724 then
            data = {Mon = "Marine Commodore", Quest = "MarineTreeIsland", Level = 1, QuestPos = CFrame.new(2180,27,-6741), MobPos = CFrame.new(2286,73,-7159)}
        elseif lvl <= 1774 then
            data = {Mon = "Marine Rear Admiral", Quest = "MarineTreeIsland", Level = 2, QuestPos = CFrame.new(2179,28,-6740), MobPos = CFrame.new(3656,160,-7001)}
        elseif lvl <= 1799 then
            data = {Mon = "Fishman Raider", Quest = "DeepForestIsland3", Level = 1, QuestPos = CFrame.new(-10581,330,-8761), MobPos = CFrame.new(-10407,331,-8368)}
        elseif lvl <= 1824 then
            data = {Mon = "Fishman Captain", Quest = "DeepForestIsland3", Level = 2, QuestPos = CFrame.new(-10581,330,-8761), MobPos = CFrame.new(-10994,352,-9002)}
        elseif lvl <= 1849 then
            data = {Mon = "Forest Pirate", Quest = "DeepForestIsland", Level = 1, QuestPos = CFrame.new(-13234,331,-7625), MobPos = CFrame.new(-13274,332,-7769)}
        elseif lvl <= 1899 then
            data = {Mon = "Mythological Pirate", Quest = "DeepForestIsland", Level = 2, QuestPos = CFrame.new(-13234,331,-7625), MobPos = CFrame.new(-13680,501,-6991)}
        elseif lvl <= 1924 then
            data = {Mon = "Jungle Pirate", Quest = "DeepForestIsland2", Level = 1, QuestPos = CFrame.new(-12680,389,-9902), MobPos = CFrame.new(-12256,331,-10485)}
        elseif lvl <= 1974 then
            data = {Mon = "Musketeer Pirate", Quest = "DeepForestIsland2", Level = 2, QuestPos = CFrame.new(-12682,391,-9901), MobPos = CFrame.new(-13098,450,-9831)}
        elseif lvl <= 1999 then
            data = {Mon = "Reborn Skeleton", Quest = "HauntedQuest1", Level = 1, QuestPos = CFrame.new(-9481,142,5565), MobPos = CFrame.new(-8680,190,5852)}
        elseif lvl <= 2024 then
            data = {Mon = "Living Zombie", Quest = "HauntedQuest1", Level = 2, QuestPos = CFrame.new(-9481,142,5565), MobPos = CFrame.new(-10144,140,5932)}
        elseif lvl <= 2049 then
            data = {Mon = "Demonic Soul", Quest = "HauntedQuest2", Level = 1, QuestPos = CFrame.new(-9515,172,607), MobPos = CFrame.new(-9275,210,6166)}
        elseif lvl <= 2074 then
            data = {Mon = "Posessed Mummy", Quest = "HauntedQuest2", Level = 2, QuestPos = CFrame.new(-9515,172,607), MobPos = CFrame.new(-9442,60,6304)}
        elseif lvl <= 2099 then
            data = {Mon = "Peanut Scout", Quest = "NutsIslandQuest", Level = 1, QuestPos = CFrame.new(-2104,38,-10194), MobPos = CFrame.new(-1870,100,-10225)}
        elseif lvl <= 2124 then
            data = {Mon = "Peanut President", Quest = "NutsIslandQuest", Level = 2, QuestPos = CFrame.new(-2104,38,-10194), MobPos = CFrame.new(-2005,100,-10585)}
        elseif lvl <= 2149 then
            data = {Mon = "Ice Cream Chef", Quest = "IceCreamIslandQuest", Level = 1, QuestPos = CFrame.new(-818,66,-10964), MobPos = CFrame.new(-501,100,-10883)}
        elseif lvl <= 2199 then
            data = {Mon = "Ice Cream Commander", Quest = "IceCreamIslandQuest", Level = 2, QuestPos = CFrame.new(-818,66,-10964), MobPos = CFrame.new(-690,100,-11350)}
        elseif lvl <= 2224 then
            data = {Mon = "Cookie Crafter", Quest = "CakeQuest1", Level = 1, QuestPos = CFrame.new(-2023,38,-12028), MobPos = CFrame.new(-2332,90,-12049)}
        elseif lvl <= 2249 then
            data = {Mon = "Cake Guard", Quest = "CakeQuest1", Level = 2, QuestPos = CFrame.new(-2023,38,-12028), MobPos = CFrame.new(-1514,90,-12422)}
        elseif lvl <= 2274 then
            data = {Mon = "Baking Staff", Quest = "CakeQuest2", Level = 1, QuestPos = CFrame.new(-1931,38,-12840), MobPos = CFrame.new(-1930,90,-12963)}
        elseif lvl <= 2299 then
            data = {Mon = "Head Baker", Quest = "CakeQuest2", Level = 2, QuestPos = CFrame.new(-1931,38,-12840), MobPos = CFrame.new(-2123,110,-12777)}
        elseif lvl <= 2324 then
            data = {Mon = "Cocoa Warrior", Quest = "ChocQuest1", Level = 1, QuestPos = CFrame.new(235,25,-12199), MobPos = CFrame.new(110,80,-12245)}
        elseif lvl <= 2349 then
            data = {Mon = "Chocolate Bar Battler", Quest = "ChocQuest1", Level = 2, QuestPos = CFrame.new(235,25,-12199), MobPos = CFrame.new(579,80,-12413)}
        elseif lvl <= 2374 then
            data = {Mon = "Sweet Thief", Quest = "ChocQuest2", Level = 1, QuestPos = CFrame.new(150,25,-12777), MobPos = CFrame.new(-68,80,-12692)}
        elseif lvl <= 2399 then
            data = {Mon = "Candy Rebel", Quest = "ChocQuest2", Level = 2, QuestPos = CFrame.new(150,25,-12777), MobPos = CFrame.new(17,80,-12962)}
        elseif lvl <= 2424 then
            data = {Mon = "Candy Pirate", Quest = "CandyQuest1", Level = 1, QuestPos = CFrame.new(-1148,14,-14446), MobPos = CFrame.new(-1371,70,-14405)}
        elseif lvl <= 2449 then
            data = {Mon = "Snow Demon", Quest = "CandyQuest1", Level = 2, QuestPos = CFrame.new(-1148,14,-14446), MobPos = CFrame.new(-836,70,-14326)}
        elseif lvl <= 2474 then
            data = {Mon = "Isle Outlaw", Quest = "TikiQuest1", Level = 1, QuestPos = CFrame.new(-16547,56,-172), MobPos = CFrame.new(-16431,90,-223)}
        elseif lvl <= 2499 then
            data = {Mon = "Island Boy", Quest = "TikiQuest1", Level = 2, QuestPos = CFrame.new(-16547,56,-172), MobPos = CFrame.new(-16668,70,-243)}
        elseif lvl <= 2524 then
            data = {Mon = "Sun-kissed Warrior", Quest = "TikiQuest2", Level = 1, QuestPos = CFrame.new(-16540,56,1051), MobPos = CFrame.new(-16345,80,1004)}
        elseif lvl <= 2549 then
            data = {Mon = "Isle Champion", Quest = "TikiQuest2", Level = 2, QuestPos = CFrame.new(-16540,56,1051), MobPos = CFrame.new(-16634,85,1106)}
        elseif lvl <= 2574 then
            data = {Mon = "Serpent Hunter", Quest = "TikiQuest3", Level = 1, QuestPos = CFrame.new(-16665,105,1580), MobPos = CFrame.new(-16542,146,1529)}
        elseif lvl <= 2599 then
            data = {Mon = "Skull Slayer", Quest = "TikiQuest3", Level = 2, QuestPos = CFrame.new(-16665,105,1580), MobPos = CFrame.new(-16849,147,1640)}
        else
            -- LEVEL CAO NHẤT: SUBMERGED ISLAND
            data = {Mon = "Grand Devotee", Quest = "SubmergedQuest3", Level = 2, QuestPos = CFrame.new(9636,-1992,9609), MobPos = CFrame.new(9557,-1928,9859), isSubmerged = true}
        end
    end
    return data
end

-- ============ XỬ LÝ SUBMERGED ISLAND (ĐẢO CUỐI) ============
local isEnteringSubmerged = false

local function EnterSubmergedIsland()
    if isEnteringSubmerged then return end
    isEnteringSubmerged = true
    
    local char = plr.Character
    if not char then 
        isEnteringSubmerged = false
        return false 
    end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then 
        isEnteringSubmerged = false
        return false 
    end
    
    -- Vị trí NPC Submarine Worker
    local subWorkerCF = CFrame.new(-16417.6, 74.26, 1811.3)
    
    -- Di chuyển đến NPC
    if (hrp.Position - subWorkerCF.Position).Magnitude > 15 then
        TweenPlayer(subWorkerCF)
        task.wait(1)
    end
    
    -- Nói chuyện với NPC
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("NPC", "Submarine Worker")
    end)
    task.wait(0.5)
    
    -- Đi vào tàu ngầm
    pcall(function()
        RS.Modules.Net["RF/SubmarineWorkerSpeak"]:InvokeServer("TravelToSubmergedIsland")
    end)
    
    -- Chờ chuyển cảnh
    local timer = 0
    while timer < 15 do
        task.wait(0.5)
        timer = timer + 0.5
        -- Kiểm tra đã vào submerged chưa (Y < -200)
        local currentChar = plr.Character
        if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
            local y = currentChar.HumanoidRootPart.Position.Y
            if y < -200 then
                isEnteringSubmerged = false
                return true
            end
        end
    end
    
    isEnteringSubmerged = false
    return false
end

-- ============ HÀM DI CHUYỂN ============
local CFramePart = Instance.new("Part", Workspace)
CFramePart.Name = "DojoTweenPart"
CFramePart.Size = Vector3.new(1,1,1)
CFramePart.Anchored = true
CFramePart.CanCollide = false
CFramePart.Transparency = 1

local isTweening = false
local currentTween = nil

local function TweenPlayer(pos)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (pos.Position - hrp.Position).Magnitude
    if dist < 5 then return end
    
    if currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing then
        currentTween:Cancel()
    end
    
    isTweening = true
    CFramePart.CFrame = hrp.CFrame
    
    local speed = 350
    local duration = math.max(0.05, dist / speed)
    currentTween = TweenService:Create(CFramePart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = pos})
    currentTween:Play()
    
    task.spawn(function()
        while currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing do
            pcall(function()
                local currentChar = plr.Character
                if currentChar and currentChar:FindFirstChild("HumanoidRootPart") then
                    currentChar.HumanoidRootPart.CFrame = CFramePart.CFrame
                end
            end)
            task.wait()
        end
        isTweening = false
        currentTween = nil
    end)
end

-- ============ SPIN POSITION ============
local spinAngle = 0
local spinPos = CFrame.new(0, _G.FarmDistance, 0)

task.spawn(function()
    while task.wait(0.05) do
        if _G.SpinPosition then
            local radius = 20
            local radian = math.rad(spinAngle)
            local x = math.cos(radian) * radius
            local z = math.sin(radian) * radius
            spinPos = CFrame.new(x, _G.FarmDistance, z)
            spinAngle = (spinAngle + 30) % 360
        else
            spinPos = CFrame.new(0, _G.FarmDistance, 0)
        end
    end
end)

-- ============ BRING MOB ============
local bringTweenInfo = TweenInfo.new(0.45, Enum.EasingStyle.Linear)
local mobPos = nil

local function BringEnemy()
    if not _G.BringMob then return end
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp or not mobPos then return end
    
    local count = 0
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        if count >= 10 then break end
        local hum = mob:FindFirstChild("Humanoid")
        local root = mob:FindFirstChild("HumanoidRootPart")
        if hum and root and hum.Health > 0 then
            local dist = (root.Position - mobPos).Magnitude
            if dist <= _G.BringRange then
                count = count + 1
                pcall(function()
                    hum.WalkSpeed = 0
                    root.CanCollide = false
                    local destCF = CFrame.new(mobPos.X, root.Position.Y, mobPos.Z)
                    local tween = TweenService:Create(root, bringTweenInfo, {CFrame = destCF})
                    tween:Play()
                end)
            end
        end
    end
end

-- ============ FAST ATTACK + GIỮ ĐỘ CAO ============
local hitRemote = Net:RemoteEvent("RegisterHit", true)
local atkRemote = RS.Modules.Net["RE/RegisterAttack"]
local lastAttack = 0

local function PerformAttack(target)
    local char = plr.Character
    if not char then return end
    local root = char:FindFirstChild("HumanoidRootPart")
    local tool = char:FindFirstChildOfClass("Tool")
    if not (root and tool) then return end
    
    if tick() - lastAttack < _G.FastDelay then return end
    lastAttack = tick()
    
    local hrp = target:FindFirstChild("HumanoidRootPart")
    local hum = target:FindFirstChild("Humanoid")
    if not (hrp and hum and hum.Health > 0) then return end
    
    -- GIỮ ĐỘ CAO KHI Ở TRÊN ĐẦU QUÁI
    local currentPos = root.Position
    local targetPos = hrp.Position
    local heightDiff = currentPos.Y - targetPos.Y
    
    if heightDiff >= (_G.MobHeight - 5) and heightDiff <= (_G.MobHeight + 10) then
        local newPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
        root.CFrame = CFrame.new(newPos)
    end
    
    -- Gửi tín hiệu tấn công
    if _G.AutoFastAttack then
        atkRemote:FireServer()
        for i = 1, _G.ComboCount do
            hitRemote:FireServer(hrp, {{target, hrp}}, nil, nil, "")
        end
    end
    
    -- Fast M1 cho Fruit
    local toolTip = tool.ToolTip
    if toolTip == "Blox Fruit" and _G.AutoFastAttack then
        tool:Activate()
        local leftClickRemote = tool:FindFirstChild("LeftClickRemote") or tool:FindFirstChild("Remote")
        if leftClickRemote then
            leftClickRemote:FireServer(Vector3.new(0,0,0), 1)
        end
    end
    
    local weapon = Combat:GetWeaponName(tool)
    Combat:ApplyDamageHighlight(target, char, weapon, hrp)
end

-- ============ AUTO LEVEL CHÍNH ============
local function AcceptQuest(questData)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    -- XỬ LÝ SUBMERGED ISLAND
    if questData.isSubmerged then
        -- Kiểm tra đã ở trong Submerged chưa
        if hrp.Position.Y > -200 then
            EnterSubmergedIsland()
            task.wait(2)
            return
        end
    end
    
    if (hrp.Position - questData.QuestPos.Position).Magnitude > 20 then
        TweenPlayer(questData.QuestPos)
        task.wait(0.5)
    end
    
    if plr.PlayerGui.Main.Quest.Visible then
        RS.Remotes.CommF_:InvokeServer("AbandonQuest")
        task.wait(0.3)
    end
    
    RS.Remotes.CommF_:InvokeServer("StartQuest", questData.Quest, questData.Level)
    task.wait(0.5)
end

local function FindNearestMob(questData)
    local char = plr.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local nearest = nil
    local minDist = _G.AttackRange
    
    for _, mob in pairs(Workspace.Enemies:GetChildren()) do
        local mobHrp = mob:FindFirstChild("HumanoidRootPart")
        local mobHum = mob:FindFirstChild("Humanoid")
        if mobHrp and mobHum and mobHum.Health > 0 and mob.Name == questData.Mon then
            local dist = (mobHrp.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                nearest = mob
            end
        end
    end
    return nearest, minDist
end

local function AutoHaki()
    local char = plr.Character
    if char and not char:FindFirstChild("HasBuso") then
        RS.Remotes.CommF_:InvokeServer("Buso")
    end
end

-- ============ MAIN LOOP ============
task.spawn(function()
    while task.wait() do
        if not _G.AutoLevel then 
            task.wait(0.5)
            continue 
        end
        
        local char = plr.Character
        if not char then 
            task.wait(2)
            continue 
        end
        
        local hum = char:FindFirstChild("Humanoid")
        if not hum or hum.Health <= 0 then
            task.wait(2)
            continue
        end
        
        local questData = GetQuestData()
        if not questData.Mon then
            task.wait(1)
            continue
        end
        
        AutoHaki()
        
        -- XỬ LÝ SUBMERGED ISLAND RIÊNG
        if questData.isSubmerged then
            local hrp = char:FindFirstChild("HumanoidRootPart")
            if hrp and hrp.Position.Y > -200 then
                -- Chưa ở trong Submerged, cần vào
                AcceptQuest(questData)
                task.wait(2)
                continue
            end
        end
        
        local hasQuest = plr.PlayerGui.Main.Quest.Visible
        local questTitle = ""
        pcall(function()
            questTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
        end)
        
        if not hasQuest or not string.find(questTitle, questData.Mon) then
            AcceptQuest(questData)
            task.wait(0.5)
            continue
        end
        
        local mob, dist = FindNearestMob(questData)
        
        if mob then
            mobPos = mob.HumanoidRootPart.Position
            task.spawn(BringEnemy)
            
            local hrp = char:FindFirstChild("HumanoidRootPart")
            local mobHrp = mob:FindFirstChild("HumanoidRootPart")
            
            if hrp and mobHrp then
                local currentPos = hrp.Position
                local targetPos = mobHrp.Position
                local heightDiff = currentPos.Y - targetPos.Y
                local isAtCorrectHeight = heightDiff >= (_G.MobHeight - 5) and heightDiff <= (_G.MobHeight + 10)
                
                if dist > 12 or not isAtCorrectHeight then
                    local newHeight = targetPos.Y + _G.MobHeight
                    local targetCF = CFrame.new(targetPos.X, newHeight, targetPos.Z)
                    TweenPlayer(targetCF)
                    task.wait(0.15)
                else
                    local newPos = Vector3.new(targetPos.X, currentPos.Y, targetPos.Z)
                    hrp.CFrame = CFrame.new(newPos)
                end
            end
            
            PerformAttack(mob)
        else
            TweenPlayer(questData.MobPos)
            task.wait(0.5)
        end
    end
end)

-- ============ UI ============
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
    Name = "Dojo Hub | Auto Level",
    LoadingTitle = "Đang tải...",
    LoadingSubtitle = "By Dojo",
    ConfigurationSaving = {Enabled = false}
})

local MainTab = Window:CreateTab("Chính", 4483362458)

MainTab:CreateToggle({
    Name = "🔥 Bật Auto Level",
    CurrentValue = false,
    Callback = function(v)
        _G.AutoLevel = v
        if v then
            game:GetService("StarterGui"):SetCore("SendNotification", {
                Title = "Dojo Hub",
                Text = "Đã bật Auto Level!",
                Duration = 2
            })
        end
    end
})

MainTab:CreateToggle({
    Name = "⚡ Bật Fast Attack",
    CurrentValue = true,
    Callback = function(v)
        _G.AutoFastAttack = v
    end
})

MainTab:CreateToggle({
    Name = "🔄 Bật Bring Mob",
    CurrentValue = true,
    Callback = function(v)
        _G.BringMob = v
    end
})

MainTab:CreateToggle({
    Name = "🔄 Bật Spin Position",
    CurrentValue = false,
    Callback = function(v)
        _G.SpinPosition = v
    end
})

MainTab:CreateSlider({
    Name = "📏 Phạm Vi Tấn Công",
    Range = {30, 120},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(v)
        _G.AttackRange = v
    end
})

MainTab:CreateSlider({
    Name = "⚡ Tốc Độ Fast Attack (1-20)",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 12,
    Callback = function(v)
        _G.FastDelay = 1 / v
    end
})

MainTab:CreateSlider({
    Name = "🎯 Số Combo Mỗi Lần Đánh",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(v)
        _G.ComboCount = v
    end
})

MainTab:CreateSlider({
    Name = "📦 Phạm Vi Kéo Quái",
    Range = {100, 500},
    Increment = 10,
    CurrentValue = 235,
    Callback = function(v)
        _G.BringRange = v
    end
})

MainTab:CreateSlider({
    Name = "📐 Độ Cao Khi Đánh (Trên đầu quái)",
    Range = {10, 60},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(v)
        _G.MobHeight = v
    end
})

MainTab:CreateSlider({
    Name = "📏 Khoảng Cách Farm (Spin)",
    Range = {10, 50},
    Increment = 5,
    CurrentValue = 35,
    Callback = function(v)
        _G.FarmDistance = v
    end
})

local infoParagraph = MainTab:CreateParagraph({
    Title = "📊 Thông Tin",
    Desc = "Chưa bật Auto Level"
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoLevel then
            local lvl = plr.Data.Level.Value
            local questData = GetQuestData()
            local submergedStatus = ""
            if questData.isSubmerged then
                local char = plr.Character
                if char and char:FindFirstChild("HumanoidRootPart") then
                    local y = char.HumanoidRootPart.Position.Y
                    submergedStatus = y < -200 and " (Đã vào đảo chìm)" or " (Đang vào đảo chìm...)"
                end
            end
            infoParagraph:SetDesc(string.format(
                "Level: %d\nWorld: %d\nQuái: %s%s\nĐộ cao: %d\nFast Attack: %s\nBring Mob: %s",
                lvl, _G.World, questData.Mon or "N/A", submergedStatus,
                _G.MobHeight,
                _G.AutoFastAttack and "Bật" or "Tắt",
                _G.BringMob and "Bật" or "Tắt"
            ))
        else
            infoParagraph:SetDesc("🔴 Auto Level đang tắt\nBật toggle bên trên để bắt đầu")
        end
    end
end)

print("Dojo Hub | Auto Level + Fast Attack + Giữ độ cao - Đã tải thành công!")
print("Đã hỗ trợ Submerged Island (đảo cuối level 2600+)")