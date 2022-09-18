local QBCore = exports['qb-core']:GetCoreObject() 

local isLoggedIn = LocalPlayer.state['isLoggedIn']
local VehicleCoords = nil
local CurrentCops = 0
local currentJobId = nil
local onRun = false
local hasKey = false
local case = nil
local caseBlip = nil
local blipCircle = nil
local playerCase = nil

local npcs = {
    ['npcguards'] = {},
    ['npccivilians'] = {}
}

local function CleanUp()
    if Config.Debug then
        print('Cleanup')
    
    end
    TriggerServerEvent('cw-raidjob:server:cleanUp', currentJobId )
    if case then
        DeleteEntity(case)
    end
end

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('baseevents:onPlayerDied', function()
    if onRun and Config.RemoveItemsOnDeath then
        if Config.Debug then
            print('Player was on run and got revived')
        end
        onRun = false
        hasKey = false
        CleanUp()
    end
end)

local function shallowCopy(original)
	local copy = {}
	for key, value in pairs(original) do
		copy[key] = value
	end
	return copy
end

local function canInteract(value)
    local tokens = nil
    QBCore.Functions.TriggerCallback('cw-tokens:server:PlayerHasToken', function(result, value)
        tokens = result
    end)
    Wait(100)
    if tokens ~=nil and tokens[value] then return true else return false end
end

--- Create bosses
CreateThread(function()
    for i,v in pairs(Config.Jobs) do
        if Config.Debug then
            print('creating data for job: '..v.JobName.. ' with id: '..i.. ' with boss: '.. v.Boss.model)
        end
        local boss = v.Boss
        local animation
        if boss.animation then
            animation = boss.animation
        else
            animation = "WORLD_HUMAN_STAND_IMPATIENT"
        end
        RequestModel(boss.model)
        while not HasModelLoaded(boss.model) do
            Wait(1)
        end

        local title = v.Boss.missionTitle
        if Config.UseTokens then
            title = title.. ' using token'
        else
            title = title.. ' $'..v.RunCost
        end
        exports['qb-target']:SpawnPed({
            model = boss.model,
            coords = boss.coords,
            minusOne = true,
            freeze = true,
            invincible = true,
            blockevents = true,
            scenario = animation,
            target = {
                options = {
                    { 
                        type = "client",
                        event = "cw-raidjob:client:start",
                        jobId = i,
                        icon = "fas fa-circle",
                        label = title,
                        canInteract = function()    
                            if onRun then return false end
                            if Config.UseTokens then
                                if v.Token then
                                    return canInteract(v.Token)
                                end
                            end
                             if v.Boss.available then
                                 if v.Boss.available.from > v.Boss.available.to then
                                     if GetClockHours() >= v.Boss.available.from or GetClockHours() < v.Boss.available.to then return true else return false end
                                 else
                                     if GetClockHours() >= v.Boss.available.from and GetClockHours() < v.Boss.available.to then return true else return false end
                                 end
                             end
                        end
                    },
                    { 
                        type = "client",
                        event = "cw-raidjob:client:reward",
                        icon = "fas fa-circle",
                        label = "Check Product",
                        jobId = i,
                        canInteract = function()
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            if GetDistanceBetweenCoords(playerCoords,v.Boss.coords) > 3 then return false end
                            local itemInPockets = QBCore.Functions.HasItem(v.Items.FetchItemContents)
                            if itemInPockets then return true else return false end
                        end
                    },       
                },
                distance = 3.0 
            },
            spawnNow = true,
        })
    end

end)

local function CreateCaseInteraction()
    CreateThread(function()
        if onRun and case ~= nil then
            exports['qb-target']:AddTargetEntity(case, {
                options = {
                    {
                        type = 'client',
                        event = "cw-raidjob:client:items",
                        icon = "fas fa-circle",
                        label = "Grab Goods",
        
                        canInteract = function()
                            if onRun and hasKey then return true else return false end 
                        end
                    },
                },
                distance = 2.5
            })
        end

    end)
end
local function RunStart()
    onRun = true
    hasKey = true
	Citizen.Wait(2000)
end

---Phone msgs
local function FirstMessages()
    local sender = Lang:t('mailstart.sender')
    local subject = Lang:t('mailstart.subject')
    local message = Lang:t('mailstart.message')

    if Config.Jobs[currentJobId].Messages then
        if Config.Jobs[currentJobId].Messages.Sender then 
            sender = Config.Jobs[currentJobId].Messages.Sender
        end
        if Config.Jobs[currentJobId].Messages.Subject then
            subject = Config.Jobs[currentJobId].Messages.Subject
        end
        if Config.Jobs[currentJobId].Messages.Message then
            message = Config.Jobs[currentJobId].Messages.Message
        end
    end

	TriggerServerEvent('qb-phone:server:sendNewMail', {
        sender = sender,
        subject = subject,
        message = message,
	})
end


local function casegps()
    if QBCore.Functions.GetPlayerData().job.name == 'police' then
        TriggerEvent('cw-boostjob:client:caseTheftCall')
        playerCase = AddBlipForEntity(PlayerPedId())
        SetBlipSprite(playerCase, 161)
        SetBlipScale(playerCase, 1.4)
        PulseBlip(playerCase)
        SetBlipColour(playerCase, 2)
        SetBlipAsShortRange(playerCase, true)
    end
end

local function Itemtimemsg()
    Citizen.Wait(2000)

	TriggerServerEvent('qb-phone:server:sendNewMail', {
    sender = Lang:t('mail.sender'),
	subject = Lang:t('mail.subject'),
	message = Lang:t('mail.message'),
	})
    casegps()
    QBCore.Functions.Notify(Lang:t("success.case_beep"), 'success')
    Citizen.Wait(Config.Jobs[currentJobId].Items.FetchItemTime)
    RemoveBlip(playerCase)
    QBCore.Functions.Notify(Lang:t("success.case_beep_stop"), 'success')

    local itemInPockets = QBCore.Functions.HasItem(Config.Jobs[currentJobId].Items.FetchItem)
    if itemInPockets then
        TriggerServerEvent('cw-raidjob:server:givecaseitems', currentJobId)
        QBCore.Functions.Notify(Lang:t("success.case_has_been_unlocked"), 'success')
    else
        QBCore.Functions.Notify(Lang:t("error.you_dont_have_the_case"), 'error')      
    end
    currentJobId = nil
end


---
RegisterNetEvent('cw-raidjob:client:start', function (data)
    if CurrentCops >= Config.Jobs[data.jobId].MinimumPolice then
        currentJobId = data.jobId
        QBCore.Functions.TriggerCallback("cw-raidjob:server:coolc",function(isCooldown)
            if not isCooldown then
                TriggerEvent('animations:client:EmoteCommandStart', {"idle11"})
                QBCore.Functions.Progressbar("start_job", Lang:t('info.talking_to_boss'), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() -- Done
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    TriggerServerEvent('cw-raidjob:server:startr', currentJobId)
                end, function() -- Cancel
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                end)
            else
                QBCore.Functions.Notify(Lang:t("error.someone_recently_did_this"), 'error')
            end
        end)    
    else
        QBCore.Functions.Notify(Lang:t("error.cannot_do_this_right_now"), 'error')
    end
end)

local function loadModel(model)
    if type(model) ~= 'number' then
        model = GetHashKey(model)
    end

    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

local function SpawnGuards()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npcguards')
    
    local listOfGuardPositions = nil
    if Config.Jobs[currentJobId].GuardPositions ~= nil then
        listOfGuardPositions = shallowCopy(Config.Jobs[currentJobId].GuardPositions) -- these are used if random positions
    end
    
    for k, v in pairs(Config.Jobs[currentJobId].Guards) do
        local guardPosition = v.coords
        if guardPosition == nil then
            if listOfGuardPositions == nil then
                print('Someone made an oopsie when making guard positions!')
            else
                local random = math.random(1,#listOfGuardPositions)
                guardPosition = listOfGuardPositions[random]
                table.remove(listOfGuardPositions,random)
            end
        end
        local accuracy = Config.DefaultValues.accuracy
        if v.accuracy then
            accuracy = v.accuracy
        end
        local armor =  Config.DefaultValues.armor
        if v.armor then
            armor = v.armor
        end
        -- print('Guard location: ', guardPosition)
        loadModel(v.model)
        npcs['npcguards'][k] = CreatePed(26, GetHashKey(v.model), guardPosition, true, true)
        NetworkRegisterEntityAsNetworked(npcs['npcguards'][k])
        local networkID = NetworkGetNetworkIdFromEntity(npcs['npcguards'][k])
        if Config.Debug then
            print('networkid: ', networkID)
        end
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(npcs['npcguards'][k], 0)
        SetPedRandomProps(npcs['npcguards'][k])
        SetEntityAsMissionEntity(npcs['npcguards'][k])
        SetEntityVisible(npcs['npcguards'][k], true)
        SetPedRelationshipGroupHash(npcs['npcguards'][k], 'npcguards')
        SetPedAccuracy(npcs['npcguards'][k], accuracy)
        SetPedArmour(npcs['npcguards'][k], armor)
        SetPedCanSwitchWeapon(npcs['npcguards'][k], true)
        SetPedDropsWeaponsWhenDead(npcs['npcguards'][k], false)
        SetPedFleeAttributes(npcs['npcguards'][k], 0, false)
        local weapon = 'WEAPON_PISTOL'
        if v.weapon then
            weapon = v.weapon
        end
        GiveWeaponToPed(npcs['npcguards'][k], v.weapon, 255, false, false)
        local random = math.random(1, 2)
        if random == 2 then
            TaskGuardCurrentPosition(npcs['npcguards'][k], 10.0, 10.0, 1)
        end
        Wait(1000) -- cheap way to fix npcs not spawning
    end

    SetRelationshipBetweenGroups(0, 'npcguards', 'npcguards')
    SetRelationshipBetweenGroups(5, 'npcguards', 'PLAYER')
    SetRelationshipBetweenGroups(5, 'PLAYER', 'npcguards')
end

local function SpawnCivilians()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npccivilians')
    
    if Config.Jobs[currentJobId].Civilians then

        local listOfCivilianPositions = nil
        if Config.Jobs[currentJobId].CivilianPositions ~= nil then
            listOfCivilianPositions = shallowCopy(Config.Jobs[currentJobId].CivilianPositions) -- these are used if random positions
        end
        
        for k, v in pairs(Config.Jobs[currentJobId].Civilians) do
            local civPosition = v.coords
            if civPosition == nil then
                if listOfCivilianPositions == nil then
                    print('Someone made an oopsie when making civilian positions!')
                else
                    local random = math.random(1,#listOfCivilianPositions)
                    civPosition = listOfCivilianPositions[random]
                    table.remove(listOfCivilianPositions,random)
                end
            end
            -- print('Civ location: ', civPosition)
            loadModel(v.model)
            npcs['npccivilians'][k] = CreatePed(26, GetHashKey(v.model), civPosition, true, true)
            NetworkRegisterEntityAsNetworked(npcs['npccivilians'][k])
            local networkID = NetworkGetNetworkIdFromEntity(npcs['npccivilians'][k])
            SetNetworkIdCanMigrate(networkID, true)
            SetNetworkIdExistsOnAllMachines(networkID, true)
            SetPedRandomComponentVariation(npcs['npccivilians'][k], 0)
            SetPedRandomProps(npcs['npccivilians'][k])
            SetEntityAsMissionEntity(npcs['npccivilians'][k])
            SetEntityVisible(npcs['npccivilians'][k], true)
            SetPedRelationshipGroupHash(npcs['npccivilians'][k], 'npccivilians')
            SetPedArmour(npcs['npccivilians'][k], 10)
            SetPedFleeAttributes(npcs['npccivilians'][k], 0, true)

            local animation = "CODE_HUMAN_COWER"
            if v.animation then
                animation = v.animation
            end
            TaskStartScenarioInPlace(npcs['npccivilians'][k],  animation, 0, true)
            Wait(1000) -- cheap way to fix npcs not spawning
        end

        SetRelationshipBetweenGroups(3, 'npccivilians', 'npccivilians')
        SetRelationshipBetweenGroups(3, 'npccivilians', 'PLAYER')
        SetRelationshipBetweenGroups(3, 'PLAYER', 'npccivilians')
    end
end

local function SpawnCase()
    local FetchItemRandom = Config.Jobs[currentJobId].Items.FetchItemRandom

    local prop = 'prop_security_case_01'
    if Config.Jobs[currentJobId].Items.FetchItemProp then
        prop = Config.Jobs[currentJobId].Items.FetchItemProp
    end

    if FetchItemRandom ~= nil then
        if Config.Debug then
            print('has random case location')
        end
        local caseLocation = FetchItemRandom.Locations[math.random(1,#FetchItemRandom.Locations)]
        case = CreateObject(prop, caseLocation.x, caseLocation.y, caseLocation.z, true,  true, true)
        SetEntityHeading(case, caseLocation.w)
        CreateObject(case)
        FreezeEntityPosition(case, true)
        SetEntityAsMissionEntity(case)
        
        local circleCenter = FetchItemRandom.CircleCenter
        blipCircle = AddBlipForRadius(circleCenter.x, circleCenter.y, circleCenter.z , 60.0) -- you can use a higher number for a bigger zone 
        SetBlipHighDetail(blipCircle, true) 
        SetBlipColour(blipCircle, 1) 
        SetBlipAlpha (blipCircle, 128) 
        SetNewWaypoint(circleCenter.x, circleCenter.y)
     
    else
        if Config.Debug then
            print('does NOT have random case location')
        end
        local caseLocation = Config.Jobs[currentJobId].Items.FetchItemLocation
        case = CreateObject(prop, caseLocation.x, caseLocation.y, caseLocation.z, true,  true, true)
        SetNewWaypoint(caseLocation.x, caseLocation.y)
        SetEntityHeading(case, caseLocation.w)
        CreateObject(case)
        FreezeEntityPosition(case, true)
        SetEntityAsMissionEntity(case)
        caseBlip = AddBlipForEntity(case)
        SetBlipSprite(caseBlip, 457)
        SetBlipColour(caseBlip, 2)
        SetBlipFlashes(caseBlip, false)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString('Case')
        EndTextCommandSetBlipName(caseBlip)
    end
    CreateCaseInteraction()
end

RegisterNetEvent('cw-raidjob:client:runactivate', function()
    RunStart()
    Citizen.Wait(4)
    local vehicles = Config.Jobs[currentJobId].Vehicles
    if vehicles then 
        for i,v in pairs(Config.Jobs[currentJobId].Vehicles) do
            local DrawCoord = 1
            if DrawCoord == 1 then
                VehicleCoords = v.coords
            end
        
            RequestModel(v.model)
            while not HasModelLoaded(v.model) do
                Citizen.Wait(0)
            end

            ClearAreaOfVehicles(VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 15.0, false, false, false, false, false)
            transport = CreateVehicle(v.model, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, VehicleCoords.w, true, true)   
    end
    end
    SpawnGuards()
    SpawnCivilians()
    SpawnCase()
    FirstMessages()
end)



local function MinigameSuccess()
    TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
    QBCore.Functions.Progressbar("grab_case", "Unlocking case", 10000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
    }, {}, {}, function() -- Done
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        RemoveBlip(case)
        if blipCircle ~= nil then
            RemoveBlip(blipCircle)
        end
        DeleteEntity(case)
        TriggerServerEvent('cw-raidjob:server:unlock', currentJobId)

        local playerPedPos = GetEntityCoords(PlayerPedId(), true)
        if (IsPedActiveInScenario(PlayerPedId()) == false) then
        SetEntityAsMissionEntity(case, 1, 1)
        QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
        Itemtimemsg()
        case = nil
        blipCircle = nil
        caseBlip = nil
        onRun = false
    end
    end, function()
        TriggerEvent('animations:client:EmoteCommandStart', {"c"})
        QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
    end)  
end

local function MinigameFailiure()
    QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
end

local function StartMinigame()
    if Config.Jobs[currentJobId].Items.FetchItemMinigame then
        local type = Config.Jobs[currentJobId].Items.FetchItemMinigame.Type
        local variables = Config.Jobs[currentJobId].Items.FetchItemMinigame.Variables
        if type == "Circle" then
            exports['ps-ui']:Circle(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2]) -- NumberOfCircles, MS
        elseif type == "Maze" then
            exports['ps-ui']:Maze(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1]) -- Hack Time Limit
        elseif type == "VarHack" then
            exports['ps-ui']:VarHack(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
             end, variables[1], variables[2]) -- Number of Blocks, Time (seconds)
        elseif type == "Thermite" then 
            exports["ps-ui"]:Thermite(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Time, Gridsize (5, 6, 7, 8, 9, 10), IncorrectBlocks
        elseif type == "Scrambler" then
            exports['ps-ui']:Scrambler(function(success)
                if success then
                    MinigameSuccess()
                else
                    MinigameFailiure()
                end
            end, variables[1], variables[2], variables[3]) -- Type (alphabet, numeric, alphanumeric, greek, braille, runes), Time (Seconds), Mirrored (0: Normal, 1: Normal + Mirrored 2: Mirrored only )
        end
    else
        exports["ps-ui"]:Thermite(function(success)
            if success then
                MinigameSuccess()
            else
                MinigameFailiure()
            end
        end, 8, 5, 3) -- Success       
    end
end

RegisterNetEvent('cw-raidjob:client:items', function()
    if QBCore.Functions.HasItem("casekey") then
        TriggerEvent("qb-dispatch:raidJob")
        StartMinigame()
    else
        QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
    end
end)

RegisterNetEvent('cw-raidjob:client:reward', function(data)
    local jobId = data.jobId
    local items = Config.Jobs[jobId].Items
    if Config.Debug then
        print('checking pockets for ', QBCore.Shared.Items[items.FetchItemContents].name)
    end
    if QBCore.Functions.HasItem(QBCore.Shared.Items[items.FetchItemContents].name , items.FetchItemContentsAmount) then
        TriggerEvent('animations:client:EmoteCommandStart', {"suitcase2"})
        QBCore.Functions.Progressbar("product_check", Lang:t('info.checking_quality'), 7000, false, true, {
            disableMovement = true,
            disableCarMovement = true,
            disableMouse = false,
            disableCombat = true,
        }, {
        }, {}, {}, function() -- Done
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            ClearPedTasks(PlayerPedId())
            TriggerServerEvent('cw-raidjob:server:rewardpayout', jobId)

            QBCore.Functions.Notify(Lang:t("success.you_got_paid"), 'success')
            onRun = false
            currentJobId = nil
        end, function()
            TriggerEvent('animations:client:EmoteCommandStart', {"c"})
            QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
        end)
    else
        QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
    end
end)

RegisterCommand('raid', function (input)
    TriggerEvent('cw-raidjob:client:start', input)
end)

RegisterNetEvent('cw-boostjob:client:caseTheftCall', function()
    if not isLoggedIn then return end
    local PlayerJob = QBCore.Functions.GetPlayerData().job
    if PlayerJob.name == "police" and PlayerJob.onduty then
        local bank
        bank = "Fleeca"
        PlaySound(-1, "Lose_1st", "GTAO_FM_Events_Soundset", 0, 0, 1)
        local vehicleCoords = GetEntityCoords(MissionVehicle)
        local s1, s2 = GetStreetNameAtCoord(vehicleCoords.x, vehicleCoords.y, vehicleCoords.z)
        local street1 = GetStreetNameFromHashKey(s1)
        local street2 = GetStreetNameFromHashKey(s2)
        local streetLabel = street1
        if street2 then streetLabel = streetLabel .. " " .. street2 end
        local plate = GetVehicleNumberPlateText(MissionVehicle)
        TriggerServerEvent('police:server:policeAlert', "Theft (Tracker active)")
    end
end)