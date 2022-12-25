local Chopped = false

RegisterNetEvent('esx-lumberjack:sellItems', function()
    local source = source
    local price = 0
    local xPlayer = ESX.GetPlayerFromId(source)
    for k,v in pairs(Config.Sell) do 
        local item = xPlayer.getInventoryItem(k)
        if item and item.count >= 1 then
            price = price + (v * item.count)
            xPlayer.removeInventoryItem(k, item.count)
        end
    end
    if price > 0 then
        xPlayer.addMoney(price)
        --xPlayer.showNotification(Config.Alerts["successfully_sold"], true, false, 140)
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts["successfully_sold"], 'success')

    else
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts["no_item"], 'error')
        --xPlayer.showNotification(Config.Alerts["no_item"])
    end
end)

RegisterNetEvent('esx-lumberjack:BuyAxe', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local TRAxeClassicPrice = LumberJob.AxePrice
    local axe = xPlayer.hasWeapon('WEAPON_BATTLEAXE')
    if not axe then
        xPlayer.addWeapon('WEAPON_BATTLEAXE', ammo)
        xPlayer.removeMoney("money", TRAxeClassicPrice)
        --xPlayer.showNotification(Config.Alerts["axe_bought"], true, false, 140)
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts["axe_bought"], 'success')
    elseif axe then
        --xPlayer.showNotification(Config.Alerts["axe_check"], true, false, 140)
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts["axe_check"], 'error')
    end
end)

ESX.RegisterServerCallback('esx-lumberjack:axe', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.hasWeapon('WEAPON_BATTLEAXE') then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterNetEvent('esx-lumberjack:setLumberStage', function(stage, state, k)
    Config.TreeLocations[k][stage] = state
    TriggerClientEvent('esx-lumberjack:getLumberStage', -1, stage, state, k)
end)

RegisterNetEvent('esx-lumberjack:setChoppedTimer', function()
    if not Chopped then
        Chopped = true
        CreateThread(function()
            Wait(Config.Timeout)
            for k, v in pairs(Config.TreeLocations) do
                Config.TreeLocations[k]["isChopped"] = false
                TriggerClientEvent('esx-lumberjack:getLumberStage', -1, 'isChopped', false, k)
            end
            Chopped = false
        end)
    end
end)

RegisterServerEvent('esx-lumberjack:recivelumber', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local lumber = math.random(LumberJob.LumberAmount_Min, LumberJob.LumberAmount_Max)
    local bark = math.random(LumberJob.TreeBarkAmount_Min, LumberJob.TreeBarkAmount_Max)
    xPlayer.addInventoryItem('tree_lumber', lumber)
    xPlayer.addInventoryItem('tree_bark', bark)
end)

ESX.RegisterServerCallback('esx-lumberjack:lumber', function(source, cb)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        if xPlayer.getInventoryItem("tree_lumber").count >= 1 then
            cb(true)
        else
            cb(false)
        end
    end
end)

RegisterServerEvent('esx-lumberjack:lumberprocessed', function()
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local lumber = xPlayer.getInventoryItem('tree_lumber')
    local TradeAmount = math.random(LumberJob.TradeAmount_Min, LumberJob.TradeAmount_Max)
    local TradeRecevied = math.random(LumberJob.TradeRecevied_Min, LumberJob.TradeRecevied_Max)
    if lumber.count < 1 then 
        --xPlayer.showNotification(Config.Alerts['error_lumber'])
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts['error_lumber'], 'error')
        
        return false
    end

    local amount = lumber.count
    if amount >= 1 then
        amount = TradeAmount
    else
      return false
    end
    if lumber.count >= amount then 
        xPlayer.removeInventoryItem('tree_lumber', amount)
        --xPlayer.showNotification(Config.Alerts["lumber_processed_trade"] ..TradeAmount.. Config.Alerts["lumber_processed_lumberamount"] ..TradeRecevied.. Config.Alerts["lumber_processed_received"])
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', 'Igor andis kauba üle', 'success')
        Wait(750)
        xPlayer.addInventoryItem('wood_plank', TradeRecevied)
    else 
        --xPlayer.showNotification(Config.Alerts['itemamount'])
        TriggerClientEvent('atu_puuraidur:notify', source, 'Puuraidur', Config.Alerts['itemamount'], 'error')
        return false
    end
end)
