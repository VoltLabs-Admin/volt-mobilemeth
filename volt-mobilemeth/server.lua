QBCore = exports['qb-core']:GetCoreObject()

-- Auto-detect inventory
local function detectInventory()
    if GetResourceState('ox_inventory') == 'started' then
        return 'ox_inventory'
    elseif GetResourceState('qb-inventory') == 'started' then
        return 'qb-inventory'
    elseif GetResourceState('qs-inventory') == 'started' then
        return 'qs-inventory'
    end
    return nil
end

local inventoryType = detectInventory()

-- Check inventory for required items
local function hasRequiredItems(src)
    local Player = QBCore.Functions.GetPlayer(src)

    for _, item in ipairs(Config.RequiredItems) do
        local itemCount = 0
        if inventoryType == 'ox_inventory' then
            itemCount = exports.ox_inventory:GetItem(src, item.item).count or 0
        elseif inventoryType == 'qb-inventory' or inventoryType == 'qs-inventory' then
            local invItem = Player.Functions.GetItemByName(item.item)
            itemCount = invItem and invItem.amount or 0
        end
        if itemCount < item.amount then
            return false, item.item
        end
    end
    return true
end

-- Remove items from player inventory
local function removeItems(src)
    local Player = QBCore.Functions.GetPlayer(src)

    for _, item in ipairs(Config.RequiredItems) do
        if inventoryType == 'ox_inventory' then
            exports.ox_inventory:RemoveItem(src, item.item, item.amount)
        elseif inventoryType == 'qb-inventory' or inventoryType == 'qs-inventory' then
            Player.Functions.RemoveItem(item.item, item.amount)
        end
    end
end

-- Add meth reward
local function addReward(src)
    local Player = QBCore.Functions.GetPlayer(src)
    if inventoryType == 'ox_inventory' then
        exports.ox_inventory:AddItem(src, Config.Reward.item, Config.Reward.amount)
    elseif inventoryType == 'qb-inventory' or inventoryType == 'qs-inventory' then
        Player.Functions.AddItem(Config.Reward.item, Config.Reward.amount)
    end
end

-- Meth Cooking Event
RegisterNetEvent('mobilemethlab:startCooking', function()
    local src = source
    local hasItems, missingItem = hasRequiredItems(src)

    if not hasItems then
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Error',
            description = "Missing item: " .. missingItem,
            type = 'error'
        })
        return
    end

    removeItems(src)
    TriggerClientEvent('mobilemethlab:startMinigame', src)
end)

RegisterNetEvent('mobilemethlab:finishCooking', function(success)
    local src = source
    if success then
        addReward(src)
        TriggerClientEvent('ox_lib:notify', src, {
            title = 'Success',
            description = "You successfully cooked meth!",
            type = 'success'
        })
    end
end)

RegisterNetEvent('mobilemethlab:explodeVehicle', function()
    local src = source
    TriggerClientEvent('mobilemethlab:explodeVehicle', src)
end)
