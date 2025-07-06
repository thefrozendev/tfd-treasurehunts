local function useMap(source, item)
    if not Config.Maps[item] then
        Utils.PrintDebug("Attempted to use an unconfigured map: " .. item)
        return
    end

    if Shared.PlayerDigs[source] ~= nil then
        Utils.PrintDebug("Player " .. source .. " is already using a map.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You already have an active treasure hunt.", 5000)
        return
    end

    local map = Config.Maps[item]

    if #map.DigLocations == 0 then
        warn("Map " .. item .. " has no dig locations configured.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "This map has no dig locations configured.", 5000)
        return
    end

    local digIndex = math.random(1, #map.DigLocations)

    TriggerClientEvent("tfd-treasurehunts:Client:StartHunt", source, {
        digLocation = map.DigLocations[digIndex]
    })

    Shared.PlayerDigs[source] = {
        map = map,
        digIndex = digIndex,
        digLocation = map.DigLocations[digIndex]
    }

    Shared.Framework.RemoveItem(source, item, 1)
end

local function getRandomLootFromTable(lootTable, count)
    local rewards = {}

    local totalProb = 0
    for _, item in pairs(lootTable) do
        totalProb = totalProb + item.Probability
    end

    for i=1, count do
        local roll = math.random()
        local cumulative = 0

        for _, item in ipairs(lootTable) do
            cumulative = cumulative + (item.probably / totalProb)
            if roll <= cumulative then
                table.insert(rewards, {
                    item = item.item,
                    amount = item.amount or 1
                })
                break
            end
        end
    end

    return rewards
end

local function useChest(source, item)
    if not Config.Dig.Chests[item] then
        Utils.PrintDebug("Attempted to use an unconfigured chest: " .. item)
        return
    end

    local chest = Config.Dig.Chests[item]

    if #chest.LootTable == 0 then
        warn("Chest " .. item .. " has no loot configured.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "This chest has no loot configured.", 5000)
        return
    end

    local rewards = getRandomLootFromTable(chest.LootTable, chest.Amount or 1)

    local label
    for _, reward in ipairs(rewards) do
        if label ~= nil then
            label = label .. ", "
        end
        label = label .. reward.amount .. "x " .. Shared.Framework.GetItemLabel(reward.item)
        Shared.Framework.AddItem(source, reward.item, reward.amount)
    end

    TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You found: " .. label, 5000)

    Shared.Framework.RemoveItem(source, item, 1)
    for i=1, #rewards do
        if rewards[i].item == "money" then
            Shared.Framework.AddMoney(source, rewards[i].amount)
        else
            Shared.Framework.AddItem(source, rewards[i].item, rewards[i].amount, "from treasure hunting")
        end
    end
end

function RegisterItems()
    -- Register maps
    for _, item in pairs(Config.Maps) do
        Shared.Framework.RegisterUsableItem(item.Name, useMap)
    end

    -- Register treasure chests
    for _, item in pairs(Config.Dig.Chests) do
        Shared.Framework.RegisterUsableItem(item.Name, useChest)
    end
end
