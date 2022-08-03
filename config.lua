Config = {}

Config.Cooldown = 1 --- Cooldown until next allowed meth run
Config.DefaultValues = {
    armor = 10,
    accuracy = 40,
}
--- METH RUN ---

local MethBoss = {
    coords = vector4(-2609.76, 1867.66, 167.32, 347.67),
    model = 'g_m_m_mexboss_01',
    missionTitle = "Accept meth raid",
    available = {from = 21, to = 6},
}

local MethItems = {
    FetchItemLocation = vector4(3828.87, 4471.85, 3.0, 176.02),
    FetchItemTime = 60000, -- time it takes for the item to activate
    FetchItem = 'securityCase', -- item (inventory)
    FetchItemProp = 'prop_security_case_01', -- item (world object)
    FetchItemContents = 'meth_cured', -- item that drops from FetchItem after FetchItemTime is over
    FetchItemContentsAmount = 20, -- Amount of FetchItemContent items
    FetchItemMinigame = {
        Type = 'Thermite',
        Variables = { 20, 5, 4 }
    }
}

local MethGuards = {
        { coords = vector4(3820.32, 4458.0, 3.57, 230.37),  model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3819.05, 4464.62, 3.61, 162.91), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3810.61, 4469.97, 3.97, 110.91), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3803.51, 4464.97, 4.81, 18.9), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3809.33, 4455.14, 4.13, 352.57), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3800.44, 4452.45, 4.54, 309.68), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3799.84, 4474.73, 5.99, 108.55), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3820.13, 4483.23, 5.99, 66.19), model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3849.42, 4463.54, 2.7, 59.84),  model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
        { coords = vector4(3829.66, 4458.0, 2.75, 88.73),  model = 'g_m_y_lost_01', weapon = 'WEAPON_PISTOL'},
}

local MethVehicles = {
    { coords = vector3(3814.76, 4461.75, 3.6), model = 'slamvan2'}
}

local MethSpecialRewards = {
    { Item = 'meth', Amount = math.random(20, 30), Chance = 90 },
    { Item = '10kgoldchain', Amount = 1, Chance = 70 }
}

local MethJobPayout = math.random(150000, 220000)
local MethJob = {
    JobName = 'meth',
    Boss = MethBoss,
    Guards = MethGuards,
    Vehicles = MethVehicles,
    Items = MethItems,
    MinimumPolice = 0,
    RunCost = 10000,
    Payout =  MethJobPayout,
    SpecialRewards = MethSpecialRewards  
}

-- Cocaine job
local CokeBoss = {
    coords = vector4(-2612.29, 1869.73,  167.32, 277.32),
    model = 's_m_m_movprem_01',
    missionTitle = "Accept cocaine raid",
    animation = 'WORLD_HUMAN_GUARD_STAND', -- OPTIONAL https://pastebin.com/6mrYTdQv
    available = {from = 6, to = 18}
}

local CokeItems = {
    FetchItemLocation = vector4(-2082.82, -1019.6, 12.62, 180.78),
    FetchItemTime = 120000, -- time it takes for the item to activate
    FetchItem = 'securityCase', -- item (inventory)
    FetchItemProp = 'prop_security_case_01', -- item (world object)
    FetchItemContents = 'coke_pure', -- item that drops from FetchItem after FetchItemTime is over
    FetchItemContentsAmount = 20, -- Amount of FetchItemContent items
    FetchItemMinigame = {
        Type = 'Circle',
        Variables = { 2, 20 }
    }
}

-- These will be used to pick random spots for the guards
local CokeGuardPositions = {
    vector4(-2048.04, -1033.31, 2.57, 333.61),
    vector4(-2061.42, -1032.78, 5.88, 161.71),
    vector4(-2077.04, -1024.95, 5.88, 70.61),
    vector4(-2071.45, -1020.09, 5.88, 66.23),
    vector4(-2078.82, -1020.1, 5.88, 10.66),
    vector4(-2089.93, -1013.48, 5.88, 258.26),
    vector4(-2091.54, -1021.34, 5.91, 250.19),
    vector4(-2092.88, -1008.09, 5.88, 325.87),
    vector4(-2105.32, -1005.26, 8.97, 334.65),
    vector4(-2108.19, -1016.64, 8.97, 208.1),
    vector4(-2096.17, -1018.9, 8.97, 108.6),
    vector4(-2093.38, -1010.66, 8.97, 38.31),
    vector4(-2085.1, -1018.12, 8.97, 72.87),
    vector4(-2077.95, -1027.82, 8.97, 173.91),
    vector4(-2074.35, -1014.07, 8.97, 313.32),
    vector4(-2053.42, -1031.69, 8.97, 347.54),
    vector4(-2050.5, -1026.81, 8.97, 188.6),
    vector4(-2037.12, -1035.75, 8.97, 263.51),
    vector4(-2035.78, -1031.22, 8.97, 232.05),
    vector4(-2057.16, -1020.12, 11.91, 28.73),
    vector4(-2062.66, -1032.35, 11.91, 141.95),
    vector4(-2059.16, -1029.9, 11.91, 265.68),
    vector4(-2084.53, -1020.01, 12.78, 46.12)
}

local CokeCivilians = {
    { coords = vector4(-2084.22, -1018.2, 12.78, 258.77), model = 'mp_m_boatstaff_01' },
    { coords = vector4(-2113.34, -1006.53, 9.64, 100.85), model = 'a_f_y_beach_01', animation = 'WORLD_HUMAN_SUNBATHE' },
    { coords = vector4(-2114.71, -1010.66, 9.63, 66.88), model = 'a_f_y_beach_01', animation = 'WORLD_HUMAN_SUNBATHE_BACK' },
}

local CokeGuards = {
    { model = 's_m_m_highsec_02', weapon = 'weapon_pumpshotgun', armor = 100 },
    { model = 's_m_m_highsec_02', weapon = 'WEAPON_PISTOL'},
    { model = 's_m_m_highsec_02', weapon = 'WEAPON_PISTOL'},
    { model = 's_m_m_highsec_02', weapon = 'weapon_pumpshotgun', armor = 100 },
    { model = 's_m_m_highsec_02', weapon = 'WEAPON_PISTOL'},
    { model = 's_m_m_highsec_02', weapon = 'WEAPON_PISTOL'},
    { model = 's_m_m_highsec_02', weapon = 'weapon_pumpshotgun', armor = 100 },
    { model = 's_m_m_highsec_02', weapon = 'WEAPON_PISTOL'},
    { coords = vector4(-2082.71, -1012.14, 5.88, 159.0), model = 's_m_m_highsec_01', weapon = 'WEAPON_PISTOL50'},
    { coords = vector4(-2041.38, -1032.34, 11.98, 88.73), model = 's_m_m_highsec_01', weapon = 'WEAPON_SMG', armor = 100 },
}

local CokeVehicles = {
    { coords = vector4(-2014.52, -1052.52, -0.53, 285.69), model = 'speeder'}
}

local CokeSpecialRewards = {
    { Item = 'cokebaggy', Amount = math.random(20, 30), Chance = 90 },
    { Item = '10kgoldchain', Amount = 1, Chance = 70 }
}

local CokeMessages = {
    Sender = 'Unknown',
    Subject = 'Briefcase Location',
    Message = "Updated your gps with the location to the yacht. Get over there and find the fucking briefcase. Retrieve whats inside it and bring it back to me. I've given you a special key that would be used to remove the first layer of security on the case."
}

local CokeJob = {
    JobName = 'coke',
    Boss = CokeBoss,
    Guards = CokeGuards,
    GuardPositions = CokeGuardPositions,
    Civilians = CokeCivilians,
    Vehicles = CokeVehicles,
    Items = CokeItems,
    MinimumPolice = 0,
    RunCost = 15000,
    Payout =  math.random(150000, 220000),
    SpecialRewards = CokeSpecialRewards,
    Messages = CokeMessages 
}

-- Weed job
local WeedBoss = {
    coords = vector4(526.69, -1655.61, 29.36, 60.04),
    model = 'g_f_importexport_01',
    missionTitle = "Accept weed raid",
    animation = 'WORLD_HUMAN_SMOKING_POT', -- OPTIONAL https://pastebin.com/6mrYTdQv
    available = {from = 10, to = 20}
}

local WeedItems = {
    FetchItemLocation = vector4(2194.9, 5601.85, 53.37, 343.94),
    FetchItemTime = 30000, -- time it takes for the item to activate
    FetchItem = 'securityCase', -- item (inventory)
    FetchItemProp = 'prop_security_case_01', -- item (world object)
    FetchItemContents = 'weed_notes', -- item that drops from FetchItem after FetchItemTime is over
    FetchItemContentsAmount = 1 -- Amount of FetchItemContent items
}

local WeedGuards = {
        { coords = vector4(2220.62, 5614.49, 54.72, 100.83), model = 'a_m_m_hillbilly_02', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2221.24, 5602.82, 54.76, 153.79), model = 'a_m_m_hillbilly_02', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2211.45, 5574.69, 53.58, 23.77), model = 'a_m_m_hillbilly_02', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2195.79, 5574.87, 53.83, 0.81), model = 'a_m_m_rurmeth_01', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2246.8, 5561.69, 52.1, 226.76), model = 'a_m_m_rurmeth_01', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2250.25, 5563.66, 52.15, 186.65), model = 'a_m_m_rurmeth_01', weapon = 'WEAPON_PISTOL', accuracy = 30, armor = 25 },
        { coords = vector4(2181.14, 5554.24, 53.93, 167.81), model = 'a_m_m_hillbilly_01', weapon = 'WEAPON_DBSHOTGUN', accuracy = 30, armor = 25 },
}

local WeedVehicles = {
    { coords = vector4(2207.95, 5600.41, 53.78, 354.28), model = 'pony2'}
}

-- Add random chance of getting different kind of weed. maybe. figure out something for the special item too
local WeedSpecialRewards = {
    { Item = 'weed_purple-haze', Amount = math.random(20, 30), Chance = 90 },
    { Item = 'thermite', Amount = 1, Chance = 10 }
}

local WeedJob = {
    JobName = 'weed',
    Boss = WeedBoss,
    Guards = WeedGuards,
    Vehicles = WeedVehicles,
    Items = WeedItems,
    MinimumPolice = 0,
    RunCost = 500,
    Payout =  math.random(15000, 22000),
    SpecialRewards = WeedSpecialRewards  
}

-- Clown job
local ClownBoss = {
    coords = vector4(-1200.88, -1554.56, 4.33, 301.29),
    model = 's_m_m_strperf_01',
    missionTitle = "Do you hate clowns too?  to get your hands dirty?",
    animation = 'WORLD_HUMAN_HUMAN_STATUE', -- OPTIONAL https://pastebin.com/6mrYTdQv
    available = { from = 10 , to = 13 }
}

local ClownItems = {
    FetchItemLocation = vector4(-1578.44, 2099.56, 67.54, 343.32),
    FetchItemTime = 30000, -- time it takes for the item to activate
    FetchItem = 'securityCase', -- item (inventory)
    FetchItemProp = 'prop_security_case_01', -- item (world object)
    FetchItemContents = 'clown_notes', -- item that drops from FetchItem after FetchItemTime is over
    FetchItemContentsAmount = 1 -- Amount of FetchItemContent items
}

-- These will be used to pick random spots for the guards
local ClownGuardPositions = {
    vector4(-1579.7, 2097.14, 68.85, 9.44),
    vector4(-1566.39, 2100.68, 68.97, 346.99),
    vector4(-1581.25, 2089.2, 70.51, 31.35),
    vector4(-1586.97, 2104.1, 67.43, 336.84),
    vector4(-1583.12, 2109.8, 66.01, 314.2),
    vector4(-1571.17, 2118.67, 62.83, 343.53),
    vector4(-1568.33, 2118.86, 62.76, 283.28),
    vector4(-1569.99, 2107.57, 65.99, 212.12),    
}

local ClownGuards = {
        { model = 's_m_y_clown_01', weapon = 'weapon_snspistol'},
        { model = 's_m_y_clown_01', weapon = 'weapon_snspistol'},
        { model = 's_m_y_clown_01', weapon = 'weapon_snspistol'},
        { model = 's_m_y_clown_01', weapon = 'weapon_snspistol'},
        { coords = vector4(-1575.7, 2100.51, 68.36, 91.81), model = 's_m_y_clown_01', weapon = 'weapon_snspistol'},
        { coords = vector4(-1578.12, 2101.79, 68.15, 143.86), model = 's_m_y_clown_01', weapon = 'weapon_minismg'},
}

local ClownVehicles = {
    { coords = vector4(-1582.67, 2098.87, 70.23, 12.97), model = 'speedo2'}
}

local ClownSpecialRewards = {
    { Item = 'xtcbaggy', Amount = math.random(10, 30), Chance = 90 },
    { Item = 'nitrous', Amount = 1, Chance = 30 }
}

local ClownMessages = {
    Sender = 'Unknown',
    Subject = 'HONK HONK',
    Message = "Honk honk mother fucker it's me. Time to pie some clowns! Send you the GPS location of where they are. Head over there and steal the secrets of the clowns for me 🗿"
}

local ClownJob = {
    JobName = 'clown',
    Boss = ClownBoss,
    Guards = ClownGuards,
    GuardPositions = ClownGuardPositions,
    Vehicles = ClownVehicles,
    Items = ClownItems,
    MinimumPolice = 0,
    RunCost = 200,
    Payout =  math.random(3000, 4000),
    SpecialRewards = ClownSpecialRewards,
    Messages = ClownMessages
}

-- Art job
local ArtBoss = {
    coords = vector4(16.54, 565.47, 177.79, 262.24),
    model = 'a_m_m_golfer_01',
    missionTitle = "Accept art theft job",
    animation = 'WORLD_HUMAN_GOLF_PLAYER', -- OPTIONAL https://pastebin.com/6mrYTdQv
    available = {from = 14, to = 19}
}

local ArtItems = {
    FetchItemLocation = vector4(8.4, 529.35, 169.64, 53.86),
    FetchItemTime = 180000, -- time it takes for the item to activate
    FetchItem = 'securityCase', -- item (inventory)
    FetchItemProp = 'ex_prop_crate_art_bc', -- item (world object)
    FetchItemContents = 'art_notes', -- item that drops from FetchItem after FetchItemTime is over
    FetchItemContentsAmount = 1, -- Amount of FetchItemContent items
    FetchItemMinigame = {
        Type = 'Circle',
        Variables = { 2, 10 }
    },
    FetchItemRandom = {
        CircleCenter = vector3(3.63, 528.46, 174.63),
        Locations = {
            vector4(10.2, 526.48, 173.63, 96.2),
            vector4(2.48, 529.84, 173.63, 222.46),
            vector4(-6.1, 520.83, 173.63, 329.94),
            vector4(-8.76, 516.18, 173.63, 147.25),
            vector4(10.78, 529.79, 173.09, 122.99),
            vector4(10.5, 536.42, 169.62, 111.98),
            vector4(-5.38, 530.57, 169.62, 12.19),
            vector4(-9.63, 532.47, 170.08, 213.65),
            vector4(-1.68, 525.97, 169.63, 276.11),
            vector4(-1.1, 524.02, 170.32, 294.44),
            vector4(10.06, 526.79, 169.64, 30.19),
            vector4(14.24, 533.73, 169.63, 298.7),
            vector4(24.24, 541.11, 175.03, 32.01)
        }
    }
}

-- These will be used to pick random spots for the guards
local ArtGuardPositions = {
    vector4(1.52, 523.65, 170.62, 309.18),
    vector4(-6.97, 509.82, 170.63, 135.18),
    vector4(-1.14, 518.09, 170.63, 302.91),
    vector4(9.01, 519.67, 170.23, 221.82),
    vector4(24.15, 520.22, 170.23, 217.78),
    vector4(15.68, 529.01, 170.63, 293.99),
    vector4(19.14, 530.15, 174.63, 222.93),
    vector4(10.95, 523.67, 174.63, 206.1),
    vector4(-13.21, 510.2, 174.63, 138.64),
    vector4(9.04, 540.48, 176.03, 12.24),
    vector4(3.82, 533.99, 170.62, 21.58),
    vector4(-9.31, 531.47, 170.62, 289.24),
    vector4(22.25, 535.58, 170.63, 112.54),
}

local ArtCivilians = {
    { coords = vector4(24.15, 520.22, 170.23, 217.78), model = 'g_m_m_mexboss_02',animation = 'PROP_HUMAN_BBQ' },
    { coords = vector4(21.95, 520.2, 170.23, 229.74), model = 'a_f_y_beach_01', animation = 'WORLD_HUMAN_PARTYING' },
    { coords = vector4(25.37, 521.02, 170.23, 150.87), model = 'a_f_y_beach_01', animation = 'WORLD_HUMAN_PARTYING' },
    { coords = vector4(13.92, 521.27, 170.23, 192.74), model = 'a_f_m_beach_01', animation = 'WORLD_HUMAN_SMOKING_POT' },
}

local ArtGuards = {
    { model = 'g_m_y_mexgang_01', weapon = 'weapon_pistol50', armor = 100 },
    { model = 'ig_ramp_mex', weapon = 'weapon_vintagepistol'},
    { model = 'ig_ramp_mex', weapon = 'weapon_vintagepistol'},
    { model = 'ig_ramp_mex', weapon = 'weapon_pumpshotgun', armor = 100 },
    { model = 'g_m_y_mexgoon_03', weapon = 'weapon_vintagepistol'},
    { model = 'g_m_y_mexgoon_03', weapon = 'WEAPON_PISTOL'},
    { model = 'g_m_y_mexgoon_03', weapon = 'weapon_pumpshotgun', armor = 100 },
    { model = 'g_m_y_pologoon_01', weapon = 'WEAPON_PISTOL'},
    { coords = vector4(0.81, 521.57, 170.62, 220.58), model = 'a_m_y_mexthug_01', weapon = 'weapon_microsmg'},
    { coords = vector4(-6.92, 529.97, 175.04, 198.58), model = 'a_m_y_mexthug_01', weapon = 'weapon_microsmg', armor = 100 },
}

local ArtVehicles = {
    { coords = vector4(13.72, 547.47, 176.08, 78.14), model = 'adder'}
}

local ArtSpecialRewards = {
    { Item = 'cokebaggy', Amount = math.random(20, 30), Chance = 90 },
    { Item = 'pistol_luxuryfinish', Amount = 1, Chance = 5 },
    { Item = 'combatpistol_luxuryfinish', Amount = 1, Chance = 5 },
    { Item = 'appistol_luxuryfinish', Amount = 1, Chance = 5 },
    { Item = 'pistol50_luxuryfinish', Amount = 1, Chance = 5 },
    { Item = 'revolver_vipvariant', Amount = 1, Chance = 5 }
}

local ArtMessages = {
    Sender = 'Unknown',
    Subject = 'That THING',
    Message = "Updated your gps with the location to the house. Get over there and find the box. You're looking for a small wooden crate! There should be a case inside it with the documents. Retrieve it and bring it back to me when it's safe. I've given you a special key that should allow you to unlock the crate lock, but you might need to disable the security device. Godspeed."
}

local ArtJob = {
    JobName = 'art',
    Boss = ArtBoss,
    Guards = ArtGuards,
    GuardPositions = ArtGuardPositions,
    Civilians = ArtCivilians,
    Vehicles = ArtVehicles,
    Items = ArtItems,
    MinimumPolice = 0,
    RunCost = 35000,
    Payout =  math.random(270000, 300000),
    SpecialRewards = ArtSpecialRewards,
    Messages = ArtMessages 
}

Config.Jobs = {
    MethJob,
    CokeJob,
    WeedJob,
    ClownJob,
    ArtJob
}