Shared.Framework = {}
local Core = exports.vorp_core:GetCore()
Shared.ItemCache = {}
local players = {}
local registeredItems = {}

local function getCharacter(playerId)
    return Core.getUser(playerId).getUsedCharacter
end

function Shared.Framework.AddMoney(playerId, amount, _)
    getCharacter(playerId).addCurrency(0, amount)
end

function Shared.Framework.RemoveMoney(playerId, amount, _)
    getCharacter(playerId).removeCurrency(0, amount)
end

function Shared.Framework.GetMoney(playerId)
    return getCharacter(playerId).money
end

function Shared.Framework.AddItem(playerId, itemName, amount, _)
    exports.vorp_inventory:addItem(playerId, itemName, amount)
end

function Shared.Framework.RemoveItem(playerId, itemName, amount, _)
    exports.vorp_inventory:removeItem(playerId, itemName, amount)
end

function Shared.Framework.GetItem(playerId, itemName)
    return exports.vorp_inventory:getItem(playerId, itemName)
end

function Shared.Framework.GetItemCount(playerId, itemName)
    return Shared.Framework.GetItem(playerId, itemName).count or 0
end

function Shared.Framework.GetItemLabel(itemName)
    if Shared.ItemCache[itemName] then return Shared.ItemCache[itemName] end

    local item = exports.vorp_inventory:getItemDB(itemName)
    if not item then
        print("Item not found: " .. itemName)
        return "Unknown"
    end

    Shared.ItemCache[itemName] = item.label or item.name or "Unknown"
    return Shared.ItemCache[itemName]
end

function Shared.Framework.RegisterUsableItem(itemName, f)
    Utils.PrintDebug("Registering usable item: " .. itemName)
    exports.vorp_inventory:registerUsableItem(itemName, function(data)
        pcall(f, data.source, data.item.name)
    end, "tfd-treasurehunts")
    registeredItems[itemName] = true
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        Utils.PrintDebug("Unregistering all usable items")
        for itemName, _ in pairs(registeredItems) do
            exports.vorp_inventory:unRegisterUsableItem(itemName)
            Utils.PrintDebug("Unregistered item: " .. itemName)
        end
        registeredItems = {}
    end
end)

AddEventHandler("vorp:SelectedCharacter", function(source)
    local _source = source
    players[_source] = Core.getUser(_source)
end)

AddEventHandler("playerDropped", function(source)
    local _source = source
    if players[_source] then players[_source] = nil end
end)

local p = Core.getUsers()
for _, player in pairs(p) do
    -- Seems that getUsers() does not always have getUsedCharacter set... so let's set it ourselves if not set
    -- We rely on this!
    if not player.getUsedCharacter then
        Utils.PrintDebug("Player " .. player.source .. " does not have getUsedCharacter method, setting...")
        player.getUsedCharacter = player.UsedCharacter()
    end
    Utils.PrintDebug("Adding player to players table: " .. player.source)
    players[player.source] = player
end
