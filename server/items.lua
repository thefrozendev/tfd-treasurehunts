local function useMap(source, item)
    Utils.PrintDebug("Player " .. source .. " is using map: " .. json.encode(item))
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

    TriggerClientEvent("tfd-treasurehunts:Client:StartHunt", source, item, digIndex)

    local digLocation = vector4(
        map.DigLocations[digIndex].Coords.x,
        map.DigLocations[digIndex].Coords.y,
        map.DigLocations[digIndex].Coords.z,
        math.random(0, 360) -- Random rotation
    )

    Shared.PlayerDigs[source] = {
        map = map,
        digIndex = digIndex,
        digLocation = digLocation
    }

    Shared.Framework.RemoveItem(source, item, 1)
end

local function getRandomLootFromTable(lootTable, count)
    local rewards = {}

    local totalProb = 0
    for i=1, #lootTable do
        totalProb = totalProb + lootTable[i].probability
    end

    for i=1, count do
        local roll = math.random()
        local cumulative = 0

        for _, item in ipairs(lootTable) do
            cumulative = cumulative + (item.probability / totalProb)
            if roll <= cumulative then
                if not item.amount then
                    local minAmount = item.minAmount or 1
                    local maxAmount = item.maxAmount or 1
                    item.amount = math.random(minAmount, maxAmount)
                end
                table.insert(rewards, {
                    item = item.item,
                    amount = item.amount or 1
                })
                break
            end
        end
    end

    local consolidatedRewards = {}
    for i=1, #rewards do
        local item = rewards[i].item
        local amount = rewards[i].amount

        if not consolidatedRewards[item] then
            consolidatedRewards[item] = 0
        end

        consolidatedRewards[item] = consolidatedRewards[item] + amount
    end
    Utils.PrintDebug("Consolidated rewards: " .. json.encode(consolidatedRewards))

    return consolidatedRewards
end

local function useChest(source, item)
    Utils.PrintDebug("Player " .. source .. " is using chest: " .. json.encode(item))
    if not Config.Dig.Chests[item] then
        warn("Attempted to use an unconfigured chest: " .. item)
        return
    end

    local chest = Config.Dig.Chests[item]

    if #chest.LootTable == 0 then
        warn("Chest " .. item .. " has no loot configured.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "This chest has no loot configured.", 5000)
        return
    end

    local rewards = getRandomLootFromTable(chest.LootTable, chest.Amount or 1)
    -- Because VORP breaks all of the gaming norms of stacks... let's loop through rewards
    -- and make sure we won't exceed the "limit" of an item
    for key, amount in pairs(rewards) do
        local frameworkItem = Shared.Framework.GetItem(source, key)
        if not frameworkItem then
            warn("Item not found: " .. key)
            TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You do not have the item: " .. key, 5000)
            return
        end
        if not Shared.Framework.CanHoldItem(source, key, amount) then
            Utils.PrintDebug("Player " .. source .. " cannot receive " .. amount .. "x " .. key .. ", they would exceed the limit.")
            TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "Your pockets are too full, you would disgard items if you do this.", 7500)
            TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "Instead, you close the treasure chest and place it back.", 7500)
            return
        end
    end

    local label = ""
    for key, amount in pairs(rewards) do
        if label ~= "" then label = label .. ", " end
        if key == "money" then
            Shared.Framework.AddMoney(source, amount, "from treasure chest")
            label = label .. Utils.FormatMoney(amount)
        else
            label = label .. amount .. "x " .. Shared.Framework.GetItemLabel(key)
            Shared.Framework.AddItem(source, key, amount, "from treasure chest")
        end
    end

    TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You found: " .. label, 5000)
    Shared.Framework.RemoveItem(source, item, 1)
end

function RegisterItems()
    -- Register maps
    for key, _ in pairs(Config.Maps) do
        Shared.Framework.RegisterUsableItem(key, useMap)
    end

    -- Register treasure chests
    for key, _ in pairs(Config.Dig.Chests) do
        Shared.Framework.RegisterUsableItem(key, useChest)
    end
end
