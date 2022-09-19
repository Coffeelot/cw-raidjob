local QBCore = exports['qb-core']:GetCoreObject() 
local Cooldown = false



RegisterServerEvent('cw-raidjob:server:startr', function(jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    
    
    if Config.UseTokens and Config.Jobs[jobId].Token then
        TriggerEvent('cw-tokens:server:TakeToken', src, Config.Jobs[jobId].Token)
        Player.Functions.AddItem("casekey", 1)
        print('current job - id:'..jobId..' name: '..Config.Jobs[jobId].JobName.. ' | using Tokens')
        TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "add")
        TriggerClientEvent("cw-raidjob:client:runactivate", src)
        TriggerClientEvent('QBCore:Notify', src, Lang:t("success.send_email_right_now"), 'success')
        TriggerEvent('cw-raidjob:server:coolout')
    else
        if Player.PlayerData.money['cash'] >= Config.Jobs[jobId].RunCost then
            Player.Functions.RemoveMoney('cash', Config.Jobs[jobId].RunCost, "Running Costs")
            Player.Functions.AddItem("casekey", 1)
            print('current job - id:'..jobId..' name: '..Config.Jobs[jobId].JobName)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "add")
            TriggerClientEvent("cw-raidjob:client:runactivate", src)
            TriggerClientEvent('QBCore:Notify', src, Lang:t("success.send_email_right_now"), 'success')
            TriggerEvent('cw-raidjob:server:coolout')
        else
            TriggerClientEvent('QBCore:Notify', source, Lang:t("error.you_dont_have_enough_money"), 'error')
        end
    end
end)

-- cool down for job
RegisterServerEvent('cw-raidjob:server:coolout', function()
    Cooldown = true
    local timer = Config.Cooldown * 1000
    while timer > 0 do
        Wait(1000)
        timer = timer - 1000
        if timer == 0 then
            Cooldown = false
        end
    end
end)

QBCore.Functions.CreateCallback("cw-raidjob:server:coolc",function(source, cb)
    
    if Cooldown then
        cb(true)
    else
        cb(false) 
    end
end)

RegisterServerEvent('cw-raidjob:server:unlock', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Jobs[jobId].Items

	Player.Functions.AddItem(items.FetchItem, 1)
    Player.Functions.RemoveItem("casekey", 1)
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItem], "add")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "remove")
end)

RegisterServerEvent('cw-raidjob:server:rewardpayout', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Jobs[jobId].Items

    Player.Functions.RemoveItem(items.FetchItemContents, items.FetchItemContentsAmount)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItemContents], "remove")

    Player.Functions.AddMoney('cash', Config.Jobs[jobId].Payout)

    for k, v in pairs(Config.Jobs[jobId].SpecialRewards) do
        local chance = math.random(0,100)
        print('chance for '..v.Item..': '..chance)
        if chance < v.Chance then 
            Player.Functions.AddItem(v.Item, v.Amount)
            TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[v.Item], "add")
        end
    end
end)

RegisterServerEvent('cw-raidjob:server:givecaseitems', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Jobs[jobId].Items

    Player.Functions.AddItem(items.FetchItemContents, items.FetchItemContentsAmount)
    Player.Functions.RemoveItem(items.FetchItem, 1)
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItemContents], "add")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItem], "remove")
end)

RegisterServerEvent('cw-raidjob:server:cleanUp', function (jobId)
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local items = Config.Jobs[jobId].Items

    Player.Functions.RemoveItem(items.FetchItem, 1)
    Player.Functions.RemoveItem("casekey", 1)
    
	TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items[items.FetchItem], "add")
    TriggerClientEvent('inventory:client:ItemBox', src, QBCore.Shared.Items["casekey"], "remove")

    TriggerClientEvent('QBCore:Notify', src, "The items seem to have broken", 'error')
end)
