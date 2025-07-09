lib.callback.register("tfd-treasurehunts:Server:BuyMap", function(source, vendorIdx, stockIdx, quantity)
    local item = Config.MapVendors[vendorIdx].Stock[stockIdx]
    if not item then
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "Item " .. tostring(Config.MapVendors[vendorIdx].Stock[stockIdx].Item) .. " not found.", 5000)
        return false, "item_not_found"
    end

    local total = item.Price * quantity

    if Shared.Framework.GetMoney(source) < total then
        return false, "low_money"
    end

    Shared.Framework.RemoveMoney(source, total)
    Shared.Framework.AddItem(source, item.Item, quantity)
    TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You bought " .. quantity .. " " .. item.Label .. "(s) for " .. Utils.FormatMoney(total), 5000)
    return true, ""
end)

lib.callback.register("tfd-treasurehunts:Server:HasItems", function(source, items)
    for i=1, #items do
        if Shared.Framework.GetItemCount(source, items[i]) > 0 then
            return true
        end
    end

    return false
end)

lib.callback.register("tfd-treasurehunts:Server:DugTreasure", function(source, coords)
    local coords = GetEntityCoords(GetPlayerPed(source))

    if not Shared.PlayerDigs[source] then
        warn("Player " .. source .. " attempted to dig without an active hunt.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You are not currently on a treasure hunt.", 5000)
        return false
    end

    if #(coords - Shared.PlayerDigs[source].digLocation.xyz) > 3.0 then
        warn("Player " .. source .. " attempted to dig too far from the dig location.")
        TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You are too far from the dig location.", 5000)
        return false
    end

    local chest = Shared.PlayerDigs[source].map.Chest
    local label = Shared.Framework.GetItemLabel(chest)
    Shared.Framework.AddItem(source, chest, 1)

    Shared.PlayerDigs[source] = nil

    TriggerClientEvent("tfd-treasurehunts:Client:NotifyRight", source, "You dug up a " .. label .. "!", 5000)
    return true
end)
