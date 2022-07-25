local QBCore = exports['qb-core']:GetCoreObject() 

local VehicleCoords = nil
local CurrentCops = 0
local currentJobId = nil
local onRun = false
local hasPackage = false
local hasKey = false
local case = nil

RegisterNetEvent('QBCore:Client:OnPlayerLoaded', function()
    QBCore.Functions.GetPlayerData(function(PlayerData)
        PlayerJob = PlayerData.job
    end)
end)

RegisterNetEvent('QBCore:Client:OnJobUpdate', function(JobInfo)
    PlayerJob = JobInfo
end)

RegisterNetEvent('police:SetCopCount', function(amount)
    CurrentCops = amount
end)

--- Create bosses
CreateThread(function()
    for i,v in pairs(Config.Jobs) do
        -- print('creating data for job: '..v.JobName.. ' with id: '..i.. ' with boss: '.. v.Boss.model)
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
                        label = v.Boss.missionTitle.. ' $'..v.RunCost,
                        canInteract = function()    
                             if v.Boss.available then
                                 if v.Boss.available.from > v.Boss.available.to then
                                     if GetClockHours() >= v.Boss.available.from or GetClockHours() < v.Boss.available.to then return true else return false end
                                 else
                                     if GetClockHours() >= v.Boss.available.from and GetClockHours() < v.Boss.available.to then return true else return false end
                                 end
                             end
    
                            if onRun then return false else return true end
                        end
                    },
                    { 
                        type = "client",
                        event = "cw-raidjob:client:reward",
                        icon = "fas fa-circle",
                        label = "Check Product",
        
                        canInteract = function()
                            local playerCoords = GetEntityCoords(PlayerPedId())
                            if GetDistanceBetweenCoords(playerCoords,v.Boss.coords) > 3 then return false end
                            if onRun and hasPackage then return true else return false end 
                        end
                    },       
                },
                distance = 3.0 
            },
            spawnNow = true,
        })

        local prop = 'prop_security_case_01'
        if v.Items.FetchItemProp then
            prop = v.Items.FetchItemProp
        end
            ---
        exports['qb-target']:AddTargetModel(prop, {
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

---Phone msgs
function RunStart()
	Citizen.Wait(2000)

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
	Citizen.Wait(3000)
end

function Itemtimemsg()
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
    TriggerServerEvent('cw-raidjob:server:givecaseitems')
    QBCore.Functions.Notify(Lang:t("success.case_has_been_unlocked"), 'success')
end

function casegps()
    if QBCore.Functions.GetPlayerData().job.name == 'police' then
        playerCase = AddBlipForEntity(PlayerPedId())
        SetBlipSprite(playerCase, 161)
        SetBlipScale(playerCase, 1.4)
        PulseBlip(playerCase)
        SetBlipColour(playerCase, 2)
        SetBlipAsShortRange(playerCase, true)
    end
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
                    onRun = true
                    hasKey = true
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
            transport = CreateVehicle(v.model, VehicleCoords.x, VehicleCoords.y, VehicleCoords.z, 52.0, true, true)   
    end
    end
    SpawnGuards()
    SpawnCivilians()
    SpawnCase()
end)

function SpawnCase()
    local caseLocation = Config.Jobs[currentJobId].Items.FetchItemLocation
    case = CreateObject(Config.Jobs[currentJobId].Items.FetchItemProp, caseLocation.x, caseLocation.y, caseLocation.z, true,  true, true)
    SetNewWaypoint(caseLocation.x, caseLocation.y)
    SetEntityHeading(case, caseLocation.w)
    CreateObject(case)
    FreezeEntityPosition(case, true)
    SetEntityAsMissionEntity(case)
    case = AddBlipForEntity(case)
    SetBlipSprite(case, 457)
    SetBlipColour(case, 2)
    SetBlipFlashes(case, false)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString('Case')
    EndTextCommandSetBlipName(case)
end

npcs = {
    ['npcguards'] = {},
    ['npccivilians'] = {}
}


function loadModel(model)
    if type(model) ~= 'number' then
        model = GetHashKey(model)
    end

    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(0)
    end
end

function SpawnGuards()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npcguards')
    
    local listOfGuardPositions = Config.Jobs[currentJobId].GuardPositions -- these are used if random positions
    for k, v in pairs(Config.Jobs[currentJobId].Guards) do
        local guardPosition = v.coords
        if guardPosition == nil then
            local random = math.random(1,#listOfGuardPositions)
            guardPosition = listOfGuardPositions[random]
            table.remove(listOfGuardPositions,random)
        end
        -- print('Guard location: ', guardPosition)
        loadModel(v.model)
        npcs['npcguards'][k] = CreatePed(26, GetHashKey(v.model), guardPosition, true, true)
        NetworkRegisterEntityAsNetworked(npcs['npcguards'][k])
        networkID = NetworkGetNetworkIdFromEntity(npcs['npcguards'][k])
        SetNetworkIdCanMigrate(networkID, true)
        SetNetworkIdExistsOnAllMachines(networkID, true)
        SetPedRandomComponentVariation(npcs['npcguards'][k], 0)
        SetPedRandomProps(npcs['npcguards'][k])
        SetEntityAsMissionEntity(npcs['npcguards'][k])
        SetEntityVisible(npcs['npcguards'][k], true)
        SetPedRelationshipGroupHash(npcs['npcguards'][k], 'npcguards')
        SetPedAccuracy(npcs['npcguards'][k], 75)
        SetPedArmour(npcs['npcguards'][k], 100)
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
    end

    SetRelationshipBetweenGroups(0, 'npcguards', 'npcguards')
    SetRelationshipBetweenGroups(5, 'npcguards', 'PLAYER')
    SetRelationshipBetweenGroups(5, 'PLAYER', 'npcguards')
end

function SpawnCivilians()
    local ped = PlayerPedId()
    SetPedRelationshipGroupHash(ped, 'PLAYER')
    AddRelationshipGroup('npccivilians')
    
    if Config.Jobs[currentJobId].Civilians then 
        local listOfCivilianPositions = Config.Jobs[currentJobId].CivilianPositions -- these are used if random positions
        for k, v in pairs(Config.Jobs[currentJobId].Civilians) do
            local civPosition = v.coords
            if civPosition == nil then
                local random = math.random(1,#listOfCivilianPositions)
                civPosition = listOfCivilianPositions[random]
                table.remove(listOfCivilianPositions,random)
            end
            -- print('Civ location: ', civPosition)
            loadModel(v.model)
            npcs['npccivilians'][k] = CreatePed(26, GetHashKey(v.model), civPosition, true, true)
            NetworkRegisterEntityAsNetworked(npcs['npccivilians'][k])
            networkID = NetworkGetNetworkIdFromEntity(npcs['npccivilians'][k])
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
        end

        SetRelationshipBetweenGroups(3, 'npccivilians', 'npccivilians')
        SetRelationshipBetweenGroups(3, 'npccivilians', 'PLAYER')
        SetRelationshipBetweenGroups(3, 'PLAYER', 'npccivilians')
    end
end

RegisterNetEvent('cw-raidjob:client:items', function()
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
            TriggerEvent("qb-dispatch:raidJob")
            exports["memorygame_2"]:thermiteminigame(8, 3, 2, 20,
            function() -- Success
                TriggerEvent('animations:client:EmoteCommandStart', {"type3"})
                QBCore.Functions.Progressbar("grab_case", Lang:t('info.unlocking_case'), 10000, false, true, {
                    disableMovement = true,
                    disableCarMovement = true,
                    disableMouse = false,
                    disableCombat = true,
                }, {
                }, {}, {}, function() -- Done
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    RemoveBlip(case)
                    TriggerServerEvent('cw-raidjob:server:unlock')

                    local playerPedPos = GetEntityCoords(PlayerPedId(), true)
                    local case = GetClosestObjectOfType(playerPedPos, 10.0, Config.Jobs[currentJobId].Items.FetchItemProp, false, false, false)
                    if (IsPedActiveInScenario(PlayerPedId()) == false) then
                    SetEntityAsMissionEntity(case, 1, 1)
                    DeleteEntity(case)
                    QBCore.Functions.Notify(Lang:t("success.you_removed_first_security_case"), 'success')
                    Itemtimemsg()
                    hasPackage = true
                    case = nil
                end
                end, function()
                    TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                    QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
                end)
            end,
            function() -- Fail thermite game
                QBCore.Functions.Notify(Lang:t("error.you_failed"), 'error')
            end)
        else
            QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
        end

    end, "casekey")
end)

RegisterNetEvent('cw-raidjob:client:reward', function()
    local items = Config.Jobs[currentJobId].Items
    print('checking pockets for ', QBCore.Shared.Items[items.FetchItemContents].name)
    QBCore.Functions.TriggerCallback('QBCore:HasItem', function(result)
        if result then
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
                TriggerServerEvent('cw-raidjob:server:rewardpayout')

                QBCore.Functions.Notify(Lang:t("success.you_got_paid"), 'success')
                onRun = false
                hasPackage = false
                currentJobId = nil
            end, function()
                TriggerEvent('animations:client:EmoteCommandStart', {"c"})
                QBCore.Functions.Notify(Lang:t("error.canceled"), 'error')
            end)
        else
            QBCore.Functions.Notify(Lang:t("error.you_cannot_do_this"), 'error')
        end
    end, QBCore.Shared.Items[items.FetchItemContents].name , items.FetchItemContentsAmount)
end)

RegisterCommand('raid', function (input)
    TriggerEvent('cw-raidjob:client:start', input)
end)