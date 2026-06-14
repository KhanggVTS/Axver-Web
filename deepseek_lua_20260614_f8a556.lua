-- Dojo Hub | Auto Level + Fast Attack
-- Rayfield Sirius Official

-- ============ LOAD RAYFIELD ============
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- ============ SERVICES ============
local RS = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local RunService = game:GetService("RunService")

local plr = Players.LocalPlayer

-- ============ MODULES ============
local Net = require(RS.Modules.Net)
local Combat = require(RS.Modules.CombatUtil)
local hit = Net:RemoteEvent("RegisterHit", true)
local atk = RS.Modules.Net["RE/RegisterAttack"]

-- ============ VARIABLES ============
_G.AutoLevel = false
_G.AttackRange = 60
_G.HitRate = 0.1
_G.Combo = 2
_G.MobHeight = 20
_G.SpinRadius = 12
_G.SpinSpeed = 48
_G.TweenSpeed = 250
_G.World = nil

-- ============ XÁC ĐỊNH WORLD ============
local placeId = game.PlaceId
if placeId == 2753915549 or placeId == 85211729168715 then
    _G.World = 1
elseif placeId == 4442272183 or placeId == 79091703265657 then
    _G.World = 2
elseif placeId == 7449423635 or placeId == 100117331123089 then
    _G.World = 3
end

-- ============ DATA QUEST ============
local Mon = ""
local LevelQuest = 1
local NameQuest = ""
local NameMon = ""
local CFrameQuest = CFrame.new()
local CFrameMon = CFrame.new()

local function CheckQuest()
    local lvl = plr.Data.Level.Value
    
    if _G.World == 1 then
        if lvl <= 9 then
            Mon = "Bandit"
            LevelQuest = 1
            NameQuest = "BanditQuest1"
            NameMon = "Bandit"
            CFrameQuest = CFrame.new(1059,17,1546)
            CFrameMon = CFrame.new(943,45,1562)
        elseif lvl <= 14 then
            Mon = "Monkey"
            LevelQuest = 1
            NameQuest = "JungleQuest"
            NameMon = "Monkey"
            CFrameQuest = CFrame.new(-1598,37,153)
            CFrameMon = CFrame.new(-1524,50,37)
        elseif lvl <= 29 then
            Mon = "Gorilla"
            LevelQuest = 2
            NameQuest = "JungleQuest"
            NameMon = "Gorilla"
            CFrameQuest = CFrame.new(-1598,37,153)
            CFrameMon = CFrame.new(-1128,40,-451)
        elseif lvl <= 39 then
            Mon = "Pirate"
            LevelQuest = 1
            NameQuest = "BuggyQuest1"
            NameMon = "Pirate"
            CFrameQuest = CFrame.new(-1140,4,3829)
            CFrameMon = CFrame.new(-1262,40,3905)
        elseif lvl <= 59 then
            Mon = "Brute"
            LevelQuest = 2
            NameQuest = "BuggyQuest1"
            NameMon = "Brute"
            CFrameQuest = CFrame.new(-1140,4,3829)
            CFrameMon = CFrame.new(-976,55,4304)
        elseif lvl <= 74 then
            Mon = "Desert Bandit"
            LevelQuest = 1
            NameQuest = "DesertQuest"
            NameMon = "Desert Bandit"
            CFrameQuest = CFrame.new(897,6,4389)
            CFrameMon = CFrame.new(924,7,4482)
        elseif lvl <= 89 then
            Mon = "Desert Officer"
            LevelQuest = 2
            NameQuest = "DesertQuest"
            NameMon = "Desert Officer"
            CFrameQuest = CFrame.new(897,6,4389)
            CFrameMon = CFrame.new(1608,9,4371)
        elseif lvl <= 99 then
            Mon = "Snow Bandit"
            LevelQuest = 1
            NameQuest = "SnowQuest"
            NameMon = "Snow Bandit"
            CFrameQuest = CFrame.new(1385,87,-1298)
            CFrameMon = CFrame.new(1362,120,-1531)
        elseif lvl <= 119 then
            Mon = "Snowman"
            LevelQuest = 2
            NameQuest = "SnowQuest"
            NameMon = "Snowman"
            CFrameQuest = CFrame.new(1385,87,-1298)
            CFrameMon = CFrame.new(1243,140,-1437)
        elseif lvl <= 149 then
            Mon = "Chief Petty Officer"
            LevelQuest = 1
            NameQuest = "MarineQuest2"
            NameMon = "Chief Petty Officer"
            CFrameQuest = CFrame.new(-5035,29,4326)
            CFrameMon = CFrame.new(-4881,23,4274)
        elseif lvl <= 174 then
            Mon = "Sky Bandit"
            LevelQuest = 1
            NameQuest = "SkyQuest"
            NameMon = "Sky Bandit"
            CFrameQuest = CFrame.new(-4844,718,-2621)
            CFrameMon = CFrame.new(-4953,296,-2899)
        elseif lvl <= 189 then
            Mon = "Dark Master"
            LevelQuest = 2
            NameQuest = "SkyQuest"
            NameMon = "Dark Master"
            CFrameQuest = CFrame.new(-4844,718,-2621)
            CFrameMon = CFrame.new(-5260,391,-2229)
        elseif lvl <= 209 then
            Mon = "Prisoner"
            LevelQuest = 1
            NameQuest = "PrisonerQuest"
            NameMon = "Prisoner"
            CFrameQuest = CFrame.new(5306,2,477)
            CFrameMon = CFrame.new(5099,0,474)
        elseif lvl <= 249 then
            Mon = "Dangerous Prisoner"
            LevelQuest = 2
            NameQuest = "PrisonerQuest"
            NameMon = "Dangerous Prisoner"
            CFrameQuest = CFrame.new(5306,2,477)
            CFrameMon = CFrame.new(5655,16,866)
        elseif lvl <= 274 then
            Mon = "Toga Warrior"
            LevelQuest = 1
            NameQuest = "ColosseumQuest"
            NameMon = "Toga Warrior"
            CFrameQuest = CFrame.new(-1581,7,-2982)
            CFrameMon = CFrame.new(-1820,51,-2741)
        elseif lvl <= 299 then
            Mon = "Gladiator"
            LevelQuest = 2
            NameQuest = "ColosseumQuest"
            NameMon = "Gladiator"
            CFrameQuest = CFrame.new(-1581,7,-2982)
            CFrameMon = CFrame.new(-1268,30,-2996)
        elseif lvl <= 324 then
            Mon = "Military Soldier"
            LevelQuest = 1
            NameQuest = "MagmaQuest"
            NameMon = "Military Soldier"
            CFrameQuest = CFrame.new(-5319,12,8515)
            CFrameMon = CFrame.new(-5335,46,8638)
        elseif lvl <= 374 then
            Mon = "Military Spy"
            LevelQuest = 2
            NameQuest = "MagmaQuest"
            NameMon = "Military Spy"
            CFrameQuest = CFrame.new(-5319,12,8515)
            CFrameMon = CFrame.new(-5803,86,8829)
        elseif lvl <= 449 then
            Mon = "Fishman Warrior"
            LevelQuest = 1
            NameQuest = "FishmanQuest"
            NameMon = "Fishman Warrior"
            CFrameQuest = CFrame.new(61122,18,1567)
            CFrameMon = CFrame.new(60998,50,1534)
        elseif lvl <= 474 then
            Mon = "God's Guard"
            LevelQuest = 1
            NameQuest = "SkyExp1Quest"
            NameMon = "God's Guard"
            CFrameQuest = CFrame.new(-4720,846,-1951)
            CFrameMon = CFrame.new(-4720,846,-1951)
        elseif lvl <= 524 then
            Mon = "Shanda"
            LevelQuest = 2
            NameQuest = "SkyExp1Quest"
            NameMon = "Shanda"
            CFrameQuest = CFrame.new(-7861,5545,-381)
            CFrameMon = CFrame.new(-7741,5580,-395)
        elseif lvl <= 549 then
            Mon = "Royal Squad"
            LevelQuest = 1
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Squad"
            CFrameQuest = CFrame.new(-7903,5636,-1412)
            CFrameMon = CFrame.new(-7727,5650,-1410)
        elseif lvl <= 624 then
            Mon = "Royal Soldier"
            LevelQuest = 2
            NameQuest = "SkyExp2Quest"
            NameMon = "Royal Soldier"
            CFrameQuest = CFrame.new(-7903,5636,-1412)
            CFrameMon = CFrame.new(-7894,5640,-1629)
        elseif lvl <= 649 then
            Mon = "Galley Pirate"
            LevelQuest = 1
            NameQuest = "FountainQuest"
            NameMon = "Galley Pirate"
            CFrameQuest = CFrame.new(5258,39,4052)
            CFrameMon = CFrame.new(5391,70,4023)
        else
            Mon = "Galley Captain"
            LevelQuest = 2
            NameQuest = "FountainQuest"
            NameMon = "Galley Captain"
            CFrameQuest = CFrame.new(5258,39,4052)
            CFrameMon = CFrame.new(5985,70,4790)
        end
    elseif _G.World == 2 then
        if lvl <= 724 then
            Mon = "Raider"
            LevelQuest = 1
            NameQuest = "Area1Quest"
            NameMon = "Raider"
            CFrameQuest = CFrame.new(-427,73,1835)
            CFrameMon = CFrame.new(-614,90,2240)
        elseif lvl <= 774 then
            Mon = "Mercenary"
            LevelQuest = 2
            NameQuest = "Area1Quest"
            NameMon = "Mercenary"
            CFrameQuest = CFrame.new(-427,73,1835)
            CFrameMon = CFrame.new(-867,110,1621)
        elseif lvl <= 874 then
            Mon = "Swan Pirate"
            LevelQuest = 1
            NameQuest = "Area2Quest"
            NameMon = "Swan Pirate"
            CFrameQuest = CFrame.new(635,73,919)
            CFrameMon = CFrame.new(635,73,919)
        elseif lvl <= 899 then
            Mon = "Marine Lieutenant"
            LevelQuest = 1
            NameQuest = "MarineQuest3"
            NameMon = "Marine Lieutenant"
            CFrameQuest = CFrame.new(-2441,73,-3219)
            CFrameMon = CFrame.new(-2552,110,-3050)
        elseif lvl <= 949 then
            Mon = "Marine Captain"
            LevelQuest = 2
            NameQuest = "MarineQuest3"
            NameMon = "Marine Captain"
            CFrameQuest = CFrame.new(-2441,73,-3219)
            CFrameMon = CFrame.new(-1695,110,-3299)
        elseif lvl <= 974 then
            Mon = "Zombie"
            LevelQuest = 1
            NameQuest = "ZombieQuest"
            NameMon = "Zombie"
            CFrameQuest = CFrame.new(-5495,48,-794)
            CFrameMon = CFrame.new(-5715,90,-917)
        elseif lvl <= 999 then
            Mon = "Vampire"
            LevelQuest = 2
            NameQuest = "ZombieQuest"
            NameMon = "Vampire"
            CFrameQuest = CFrame.new(-5495,48,-794)
            CFrameMon = CFrame.new(-6027,50,-1130)
        elseif lvl <= 1049 then
            Mon = "Snow Trooper"
            LevelQuest = 1
            NameQuest = "SnowMountainQuest"
            NameMon = "Snow Trooper"
            CFrameQuest = CFrame.new(607,401,-5371)
            CFrameMon = CFrame.new(445,440,-5175)
        elseif lvl <= 1099 then
            Mon = "Winter Warrior"
            LevelQuest = 2
            NameQuest = "SnowMountainQuest"
            NameMon = "Winter Warrior"
            CFrameQuest = CFrame.new(607,401,-5371)
            CFrameMon = CFrame.new(1224,460,-5332)
        elseif lvl <= 1124 then
            Mon = "Lab Subordinate"
            LevelQuest = 1
            NameQuest = "IceSideQuest"
            NameMon = "Lab Subordinate"
            CFrameQuest = CFrame.new(-6061,16,-4904)
            CFrameMon = CFrame.new(-5941,50,-4322)
        elseif lvl <= 1174 then
            Mon = "Horned Warrior"
            LevelQuest = 2
            NameQuest = "IceSideQuest"
            NameMon = "Horned Warrior"
            CFrameQuest = CFrame.new(-6061,16,-4904)
            CFrameMon = CFrame.new(-6306,50,-5752)
        elseif lvl <= 1199 then
            Mon = "Magma Ninja"
            LevelQuest = 1
            NameQuest = "FireSideQuest"
            NameMon = "Magma Ninja"
            CFrameQuest = CFrame.new(-5430,16,-5298)
            CFrameMon = CFrame.new(-5233,60,-6227)
        elseif lvl <= 1249 then
            Mon = "Lava Pirate"
            LevelQuest = 2
            NameQuest = "FireSideQuest"
            NameMon = "Lava Pirate"
            CFrameQuest = CFrame.new(-5430,16,-5298)
            CFrameMon = CFrame.new(-4955,60,-4836)
        elseif lvl <= 1274 then
            Mon = "Ship Deckhand"
            LevelQuest = 1
            NameQuest = "ShipQuest1"
            NameMon = "Ship Deckhand"
            CFrameQuest = CFrame.new(1037,125,32911)
            CFrameMon = CFrame.new(1212,150,33059)
        elseif lvl <= 1299 then
            Mon = "Ship Engineer"
            LevelQuest = 2
            NameQuest = "ShipQuest1"
            NameMon = "Ship Engineer"
            CFrameQuest = CFrame.new(1037,125,32911)
            CFrameMon = CFrame.new(919,43,32779)
        elseif lvl <= 1324 then
            Mon = "Ship Steward"
            LevelQuest = 1
            NameQuest = "ShipQuest2"
            NameMon = "Ship Steward"
            CFrameQuest = CFrame.new(968,125,33244)
            CFrameMon = CFrame.new(919,129,33436)
        elseif lvl <= 1349 then
            Mon = "Ship Officer"
            LevelQuest = 2
            NameQuest = "ShipQuest2"
            NameMon = "Ship Officer"
            CFrameQuest = CFrame.new(968,125,33244)
            CFrameMon = CFrame.new(1036,181,33315)
        elseif lvl <= 1374 then
            Mon = "Arctic Warrior"
            LevelQuest = 1
            NameQuest = "FrostQuest"
            NameMon = "Arctic Warrior"
            CFrameQuest = CFrame.new(5667,26,-6486)
            CFrameMon = CFrame.new(5966,62,-6179)
        elseif lvl <= 1424 then
            Mon = "Snow Lurker"
            LevelQuest = 2
            NameQuest = "FrostQuest"
            NameMon = "Snow Lurker"
            CFrameQuest = CFrame.new(5667,26,-6486)
            CFrameMon = CFrame.new(5407,69,-6880)
        else
            Mon = "Water Fighter"
            LevelQuest = 2
            NameQuest = "ForgottenQuest"
            NameMon = "Water Fighter"
            CFrameQuest = CFrame.new(-3054,235,-10142)
            CFrameMon = CFrame.new(-3352,285,-10534)
        end
    elseif _G.World == 3 then
        if lvl <= 1524 then
            Mon = "Pirate Millionaire"
            LevelQuest = 1
            NameQuest = "PiratePortQuest"
            NameMon = "Pirate Millionaire"
            CFrameQuest = CFrame.new(-290,42,5581)
            CFrameMon = CFrame.new(-245,47,5584)
        elseif lvl <= 1574 then
            Mon = "Pistol Billionaire"
            LevelQuest = 2
            NameQuest = "PiratePortQuest"
            NameMon = "Pistol Billionaire"
            CFrameQuest = CFrame.new(-290,42,5581)
            CFrameMon = CFrame.new(-187,86,6013)
        elseif lvl <= 1599 then
            Mon = "Dragon Crew Warrior"
            LevelQuest = 1
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Warrior"
            CFrameQuest = CFrame.new(5832,51,-1101)
            CFrameMon = CFrame.new(6141,51,-1340)
        elseif lvl <= 1624 then
            Mon = "Dragon Crew Archer"
            LevelQuest = 2
            NameQuest = "AmazonQuest"
            NameMon = "Dragon Crew Archer"
            CFrameQuest = CFrame.new(5833,51,-1103)
            CFrameMon = CFrame.new(6616,441,446)
        elseif lvl <= 1649 then
            Mon = "Female Islander"
            LevelQuest = 1
            NameQuest = "AmazonQuest2"
            NameMon = "Female Islander"
            CFrameQuest = CFrame.new(5446,601,749)
            CFrameMon = CFrame.new(4685,735,815)
        elseif lvl <= 1699 then
            Mon = "Giant Islander"
            LevelQuest = 2
            NameQuest = "AmazonQuest2"
            NameMon = "Giant Islander"
            CFrameQuest = CFrame.new(5446,601,749)
            CFrameMon = CFrame.new(4729,590,-36)
        elseif lvl <= 1724 then
            Mon = "Marine Commodore"
            LevelQuest = 1
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Commodore"
            CFrameQuest = CFrame.new(2180,27,-6741)
            CFrameMon = CFrame.new(2286,73,-7159)
        elseif lvl <= 1774 then
            Mon = "Marine Rear Admiral"
            LevelQuest = 2
            NameQuest = "MarineTreeIsland"
            NameMon = "Marine Rear Admiral"
            CFrameQuest = CFrame.new(2179,28,-6740)
            CFrameMon = CFrame.new(3656,160,-7001)
        elseif lvl <= 1799 then
            Mon = "Fishman Raider"
            LevelQuest = 1
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Raider"
            CFrameQuest = CFrame.new(-10581,330,-8761)
            CFrameMon = CFrame.new(-10407,331,-8368)
        elseif lvl <= 1824 then
            Mon = "Fishman Captain"
            LevelQuest = 2
            NameQuest = "DeepForestIsland3"
            NameMon = "Fishman Captain"
            CFrameQuest = CFrame.new(-10581,330,-8761)
            CFrameMon = CFrame.new(-10994,352,-9002)
        elseif lvl <= 1849 then
            Mon = "Forest Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland"
            NameMon = "Forest Pirate"
            CFrameQuest = CFrame.new(-13234,331,-7625)
            CFrameMon = CFrame.new(-13274,332,-7769)
        elseif lvl <= 1899 then
            Mon = "Mythological Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland"
            NameMon = "Mythological Pirate"
            CFrameQuest = CFrame.new(-13234,331,-7625)
            CFrameMon = CFrame.new(-13680,501,-6991)
        elseif lvl <= 1924 then
            Mon = "Jungle Pirate"
            LevelQuest = 1
            NameQuest = "DeepForestIsland2"
            NameMon = "Jungle Pirate"
            CFrameQuest = CFrame.new(-12680,389,-9902)
            CFrameMon = CFrame.new(-12256,331,-10485)
        elseif lvl <= 1974 then
            Mon = "Musketeer Pirate"
            LevelQuest = 2
            NameQuest = "DeepForestIsland2"
            NameMon = "Musketeer Pirate"
            CFrameQuest = CFrame.new(-12682,391,-9901)
            CFrameMon = CFrame.new(-13098,450,-9831)
        elseif lvl <= 1999 then
            Mon = "Reborn Skeleton"
            LevelQuest = 1
            NameQuest = "HauntedQuest1"
            NameMon = "Reborn Skeleton"
            CFrameQuest = CFrame.new(-9481,142,5565)
            CFrameMon = CFrame.new(-8680,190,5852)
        elseif lvl <= 2024 then
            Mon = "Living Zombie"
            LevelQuest = 2
            NameQuest = "HauntedQuest1"
            NameMon = "Living Zombie"
            CFrameQuest = CFrame.new(-9481,142,5565)
            CFrameMon = CFrame.new(-10144,140,5932)
        elseif lvl <= 2049 then
            Mon = "Demonic Soul"
            LevelQuest = 1
            NameQuest = "HauntedQuest2"
            NameMon = "Demonic Soul"
            CFrameQuest = CFrame.new(-9515,172,607)
            CFrameMon = CFrame.new(-9275,210,6166)
        elseif lvl <= 2074 then
            Mon = "Posessed Mummy"
            LevelQuest = 2
            NameQuest = "HauntedQuest2"
            NameMon = "Posessed Mummy"
            CFrameQuest = CFrame.new(-9515,172,607)
            CFrameMon = CFrame.new(-9442,60,6304)
        elseif lvl <= 2099 then
            Mon = "Peanut Scout"
            LevelQuest = 1
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut Scout"
            CFrameQuest = CFrame.new(-2104,38,-10194)
            CFrameMon = CFrame.new(-1870,100,-10225)
        elseif lvl <= 2124 then
            Mon = "Peanut President"
            LevelQuest = 2
            NameQuest = "NutsIslandQuest"
            NameMon = "Peanut President"
            CFrameQuest = CFrame.new(-2104,38,-10194)
            CFrameMon = CFrame.new(-2005,100,-10585)
        elseif lvl <= 2149 then
            Mon = "Ice Cream Chef"
            LevelQuest = 1
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Chef"
            CFrameQuest = CFrame.new(-818,66,-10964)
            CFrameMon = CFrame.new(-501,100,-10883)
        elseif lvl <= 2199 then
            Mon = "Ice Cream Commander"
            LevelQuest = 2
            NameQuest = "IceCreamIslandQuest"
            NameMon = "Ice Cream Commander"
            CFrameQuest = CFrame.new(-818,66,-10964)
            CFrameMon = CFrame.new(-690,100,-11350)
        elseif lvl <= 2224 then
            Mon = "Cookie Crafter"
            LevelQuest = 1
            NameQuest = "CakeQuest1"
            NameMon = "Cookie Crafter"
            CFrameQuest = CFrame.new(-2023,38,-12028)
            CFrameMon = CFrame.new(-2332,90,-12049)
        elseif lvl <= 2249 then
            Mon = "Cake Guard"
            LevelQuest = 2
            NameQuest = "CakeQuest1"
            NameMon = "Cake Guard"
            CFrameQuest = CFrame.new(-2023,38,-12028)
            CFrameMon = CFrame.new(-1514,90,-12422)
        elseif lvl <= 2274 then
            Mon = "Baking Staff"
            LevelQuest = 1
            NameQuest = "CakeQuest2"
            NameMon = "Baking Staff"
            CFrameQuest = CFrame.new(-1931,38,-12840)
            CFrameMon = CFrame.new(-1930,90,-12963)
        elseif lvl <= 2299 then
            Mon = "Head Baker"
            LevelQuest = 2
            NameQuest = "CakeQuest2"
            NameMon = "Head Baker"
            CFrameQuest = CFrame.new(-1931,38,-12840)
            CFrameMon = CFrame.new(-2123,110,-12777)
        elseif lvl <= 2324 then
            Mon = "Cocoa Warrior"
            LevelQuest = 1
            NameQuest = "ChocQuest1"
            NameMon = "Cocoa Warrior"
            CFrameQuest = CFrame.new(235,25,-12199)
            CFrameMon = CFrame.new(110,80,-12245)
        elseif lvl <= 2349 then
            Mon = "Chocolate Bar Battler"
            LevelQuest = 2
            NameQuest = "ChocQuest1"
            NameMon = "Chocolate Bar Battler"
            CFrameQuest = CFrame.new(235,25,-12199)
            CFrameMon = CFrame.new(579,80,-12413)
        elseif lvl <= 2374 then
            Mon = "Sweet Thief"
            LevelQuest = 1
            NameQuest = "ChocQuest2"
            NameMon = "Sweet Thief"
            CFrameQuest = CFrame.new(150,25,-12777)
            CFrameMon = CFrame.new(-68,80,-12692)
        elseif lvl <= 2399 then
            Mon = "Candy Rebel"
            LevelQuest = 2
            NameQuest = "ChocQuest2"
            NameMon = "Candy Rebel"
            CFrameQuest = CFrame.new(150,25,-12777)
            CFrameMon = CFrame.new(17,80,-12962)
        elseif lvl <= 2424 then
            Mon = "Candy Pirate"
            LevelQuest = 1
            NameQuest = "CandyQuest1"
            NameMon = "Candy Pirate"
            CFrameQuest = CFrame.new(-1148,14,-14446)
            CFrameMon = CFrame.new(-1371,70,-14405)
        elseif lvl <= 2449 then
            Mon = "Snow Demon"
            LevelQuest = 2
            NameQuest = "CandyQuest1"
            NameMon = "Snow Demon"
            CFrameQuest = CFrame.new(-1148,14,-14446)
            CFrameMon = CFrame.new(-836,70,-14326)
        elseif lvl <= 2474 then
            Mon = "Isle Outlaw"
            LevelQuest = 1
            NameQuest = "TikiQuest1"
            NameMon = "Isle Outlaw"
            CFrameQuest = CFrame.new(-16547,56,-172)
            CFrameMon = CFrame.new(-16431,90,-223)
        elseif lvl <= 2499 then
            Mon = "Island Boy"
            LevelQuest = 2
            NameQuest = "TikiQuest1"
            NameMon = "Island Boy"
            CFrameQuest = CFrame.new(-16547,56,-172)
            CFrameMon = CFrame.new(-16668,70,-243)
        elseif lvl <= 2524 then
            Mon = "Sun-kissed Warrior"
            LevelQuest = 1
            NameQuest = "TikiQuest2"
            NameMon = "kissed"
            CFrameQuest = CFrame.new(-16540,56,1051)
            CFrameMon = CFrame.new(-16345,80,1004)
        elseif lvl <= 2549 then
            Mon = "Isle Champion"
            LevelQuest = 2
            NameQuest = "TikiQuest2"
            NameMon = "Isle Champion"
            CFrameQuest = CFrame.new(-16540,56,1051)
            CFrameMon = CFrame.new(-16634,85,1106)
        elseif lvl <= 2574 then
            Mon = "Serpent Hunter"
            LevelQuest = 1
            NameQuest = "TikiQuest3"
            NameMon = "Serpent Hunter"
            CFrameQuest = CFrame.new(-16665,105,1580)
            CFrameMon = CFrame.new(-16542.4824,146.675156,1529.61401)
        elseif lvl <= 2599 then
            Mon = "Skull Slayer"
            LevelQuest = 2
            NameQuest = "TikiQuest3"
            NameMon = "Skull Slayer"
            CFrameQuest = CFrame.new(-16665,105,1580)
            CFrameMon = CFrame.new(-16849.9336,147.005066,1640.88354)
        else
            Mon = "Grand Devotee"
            LevelQuest = 2
            NameQuest = "SubmergedQuest3"
            NameMon = "Grand Devotee"
            CFrameQuest = CFrame.new(9636.52441,-1992.19507,9609.52832)
            CFrameMon = CFrame.new(9557.5849609375,-1928.0404052734375,9859.1826171875)
        end
    end
end

-- ============ AUTO TRANG BỊ MELEE ============
local function EquipMelee()
    local char = plr.Character
    if not char then return end
    
    local priority = {"Godhuman", "Dragon Talon", "Electric Claw", "Sharkman Karate", "Death Step", "Superhuman", "Fishman Karate", "Electro", "Black Leg", "Combat"}
    
    for _, name in pairs(priority) do
        local tool = plr.Backpack:FindFirstChild(name)
        if tool then
            char.Humanoid:EquipTool(tool)
            return
        end
    end
    
    for _, tool in pairs(plr.Backpack:GetChildren()) do
        if tool:IsA("Tool") and (tool.ToolTip == "Melee" or tool.ToolTip == "Fighting Style") then
            char.Humanoid:EquipTool(tool)
            return
        end
    end
end

-- ============ TWEEN PLAYER ============
local TweenPart = Instance.new("Part")
TweenPart.Name = "TweenPart"
TweenPart.Size = Vector3.new(1,1,1)
TweenPart.Anchored = true
TweenPart.CanCollide = false
TweenPart.Transparency = 1
TweenPart.Parent = workspace

local currentTween = nil

local function TweenPlayer(pos)
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local dist = (pos.Position - hrp.Position).Magnitude
    if dist < 5 then return end
    
    if currentTween then
        currentTween:Cancel()
    end
    
    TweenPart.CFrame = hrp.CFrame
    local duration = math.max(0.1, dist / _G.TweenSpeed)
    currentTween = TweenService:Create(TweenPart, TweenInfo.new(duration, Enum.EasingStyle.Linear), {CFrame = pos})
    currentTween:Play()
    
    task.spawn(function()
        while currentTween and currentTween.PlaybackState == Enum.PlaybackState.Playing do
            pcall(function()
                local c = plr.Character
                if c and c:FindFirstChild("HumanoidRootPart") then
                    c.HumanoidRootPart.CFrame = TweenPart.CFrame
                end
            end)
            task.wait()
        end
        currentTween = nil
    end)
end

-- ============ AUTO HAKI ============
local function AutoHaki()
    local char = plr.Character
    if char and not char:FindFirstChild("HasBuso") then
        pcall(function()
            RS.Remotes.CommF_:InvokeServer("Buso")
        end)
    end
end

-- ============ ATTACK ============
local lastAttack = 0

local function PerformAttack(mob)
    local char = plr.Character
    if not char then return end
    
    if tick() - lastAttack < _G.HitRate then return end
    lastAttack = tick()
    
    local hrp = mob:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    pcall(function()
        atk:FireServer()
        for i = 1, _G.Combo do
            hit:FireServer(hrp, {{mob, hrp}}, nil, nil, "")
        end
        local tool = char:FindFirstChildOfClass("Tool")
        if tool then
            Combat:ApplyDamageHighlight(mob, char, Combat:GetWeaponName(tool), hrp)
        end
    end)
end

-- ============ FIND MOB ============
local function FindTarget()
    local char = plr.Character
    if not char then return nil end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return nil end
    
    local target = nil
    local minDist = _G.AttackRange
    
    for _, mob in pairs(workspace.Enemies:GetChildren()) do
        local mhrp = mob:FindFirstChild("HumanoidRootPart")
        local mhum = mob:FindFirstChild("Humanoid")
        if mhrp and mhum and mhum.Health > 0 and mob.Name == Mon then
            local dist = (mhrp.Position - hrp.Position).Magnitude
            if dist < minDist then
                minDist = dist
                target = mob
            end
        end
    end
    return target, minDist
end

-- ============ ACCEPT QUEST ============
local function AcceptQuest()
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    CheckQuest()
    
    if (hrp.Position - CFrameQuest.Position).Magnitude > 20 then
        TweenPlayer(CFrameQuest)
        task.wait(0.5)
    end
    
    if plr.PlayerGui.Main.Quest.Visible then        pcall(function()
            RS.Remotes.CommF_:InvokeServer("AbandonQuest")
        end)
        task.wait(0.3)
    end
    
    pcall(function()
        RS.Remotes.CommF_:InvokeServer("StartQuest", NameQuest, LevelQuest)
    end)
    task.wait(0.5)
end

-- ============ XOAY VÒNG ============
local currentAngle = 0
local currentMob = nil
local lastSpinTime = tick()

local function UpdateSpin()
    if not currentMob or not currentMob.Parent then return end
    
    local char = plr.Character
    if not char then return end
    local hrp = char:FindFirstChild("HumanoidRootPart")
    if not hrp then return end
    
    local mhrp = currentMob:FindFirstChild("HumanoidRootPart")
    if not mhrp then return end
    
    local now = tick()
    local delta = math.min(0.1, now - lastSpinTime)
    lastSpinTime = now
    
    currentAngle = currentAngle + (_G.SpinSpeed * delta)
    if currentAngle >= 360 then
        currentAngle = currentAngle - 360
    end
    
    local rad = math.rad(currentAngle)
    local newX = mhrp.Position.X + math.cos(rad) * _G.SpinRadius
    local newZ = mhrp.Position.Z + math.sin(rad) * _G.SpinRadius
    local newY = mhrp.Position.Y + _G.MobHeight
    
    hrp.CFrame = CFrame.new(newX, newY, newZ)
end

-- ============ MAIN LOOP ============
task.spawn(function()
    while task.wait() do
        if not _G.AutoLevel then
            task.wait(0.5)
            currentMob = nil
            continue
        end
        
        pcall(function()
            local char = plr.Character
            if not char then return end
            
            local hum = char:FindFirstChild("Humanoid")
            if not hum or hum.Health <= 0 then return end
            
            EquipMelee()
            CheckQuest()
            AutoHaki()
            
            local hasQuest = plr.PlayerGui.Main.Quest.Visible
            local questTitle = ""
            pcall(function()
                questTitle = plr.PlayerGui.Main.Quest.Container.QuestTitle.Title.Text
            end)
            
            if not hasQuest or not string.find(questTitle or "", NameMon or "") then
                AcceptQuest()
                return
            end
            
            local target, dist = FindTarget()
            
            if target then
                if currentMob ~= target then
                    currentMob = target
                    currentAngle = 0
                    lastSpinTime = tick()
                end
                
                local mhrp = target:FindFirstChild("HumanoidRootPart")
                if mhrp then
                    if dist > _G.SpinRadius + 8 then
                        local newY = mhrp.Position.Y + _G.MobHeight
                        TweenPlayer(CFrame.new(mhrp.Position.X, newY, mhrp.Position.Z))
                        task.wait(0.2)
                    else
                        UpdateSpin()
                    end
                end
                
                PerformAttack(target)
            else
                currentMob = nil
                TweenPlayer(CFrameMon)
                task.wait(0.5)
            end
        end)
    end
end)

-- ============ RENDER STEP ============
RunService.RenderStepped:Connect(function()
    if _G.AutoLevel and currentMob and currentMob.Parent then
        pcall(UpdateSpin)
    end
end)

-- ============ CREATE WINDOW ============
local Window = Rayfield:CreateWindow({
    Name = "Dojo Hub",
    LoadingTitle = "Đang tải...",
    LoadingSubtitle = "By Dojo",
    ConfigurationSaving = {
        Enabled = false
    }
})

local MainTab = Window:CreateTab("Chính", 4483362458)

MainTab:CreateToggle({
    Name = "🔥 Bật Auto Level",
    CurrentValue = false,
    Callback = function(Value)
        _G.AutoLevel = Value
        if Value then
            EquipMelee()
        end
    end
})

MainTab:CreateSlider({
    Name = "📏 Phạm Vi Tấn Công",
    Range = {30, 100},
    Increment = 5,
    CurrentValue = 60,
    Callback = function(Value)
        _G.AttackRange = Value
    end
})

MainTab:CreateSlider({
    Name = "⚡ Tốc Độ Đánh (1-20)",
    Range = {1, 20},
    Increment = 1,
    CurrentValue = 10,
    Callback = function(Value)
        _G.HitRate = 1 / Value
    end
})

MainTab:CreateSlider({
    Name = "🎯 Số Combo/Lần",
    Range = {1, 5},
    Increment = 1,
    CurrentValue = 2,
    Callback = function(Value)
        _G.Combo = Value
    end
})

MainTab:CreateSlider({
    Name = "📐 Độ Cao Bay",
    Range = {10, 50},
    Increment = 5,
    CurrentValue = 20,
    Callback = function(Value)
        _G.MobHeight = Value
    end
})

MainTab:CreateSlider({
    Name = "🔄 Bán Kính Xoay",
    Range = {8, 25},
    Increment = 1,
    CurrentValue = 12,
    Callback = function(Value)
        _G.SpinRadius = Value
    end
})

MainTab:CreateSlider({
    Name = "🐌 Tốc Độ Xoay (độ/s)",
    Range = {20, 120},
    Increment = 5,
    CurrentValue = 48,
    Callback = function(Value)
        _G.SpinSpeed = Value
    end
})

MainTab:CreateButton({
    Name = "🔄 Trang Bị Melee",
    Callback = function()
        EquipMelee()
    end
})

local Info = MainTab:CreateParagraph({
    Title = "📊 Thông Tin",
    Desc = "Chưa bật Auto Level"
})

task.spawn(function()
    while task.wait(1) do
        if _G.AutoLevel then
            local lvl = plr.Data.Level.Value
            Info:SetDesc(string.format(
                "Level: %d | World: %d\nQuái: %s\nXoay: R=%.0f | Tốc độ=%.0f°/s",
                lvl, _G.World, Mon, _G.SpinRadius, _G.SpinSpeed
            ))
        else
            Info:SetDesc("🔴 Auto Level đang tắt\nBật toggle bên trên để bắt đầu")
        end
    end
end)

print("Dojo Hub | Auto Level - Đã tải thành công!")