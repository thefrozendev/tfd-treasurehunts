local points = {}

local function onEnterVendor(point)
    if point.removed then return end
    if point.created or point.entity then return end

    point.created = true
    local model = point.vendor.PedModel or `s_m_m_blwdealer_01`
    if type(model) == "string" then model = joaat(model) end
    if not IsModelValid(model) then
        Utils.PrintDebug("Invalid model for vendor " .. point.name .. ": " .. tostring(model) .. " -- setting to default.")
        model = `s_m_m_blwdealer_01`
    end

    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
    end

    point.entity = CreatePed(
        model,
        point.vendor.Coords.x,
        point.vendor.Coords.y,
        point.vendor.Coords.z - 1.0,
        point.vendor.Coords.w,
        false,
        true
    )
    SetRandomOutfitVariation(point.entity, true)
    FreezeEntityPosition(point.entity, true)
    SetEntityInvincible(point.entity, true)
    SetBlockingOfNonTemporaryEvents(point.entity, true)

    SetModelAsNoLongerNeeded(model)
end

local function onExitVendor(point)
    if not point.entity or point.removed then return end

    if DoesEntityExist(point.entity) then
        SetEntityAsMissionEntity(point.entity, false, true)
        DeleteEntity(point.entity)
    end

    point.entity = nil
    point.created = false
end

local function nearbyVendor(point)
    if point.removed or point.vendorPoint.removed then return end

    if ShowPrompt("vendor", "open") == "open" then
        OpenVendorMenu(point.vendor)
    end
end

function RegisterVendor(key, vendor)
    points[key] = lib.points.new({
        name = "treasurehunt_vendor_" .. key,
        coords = vendor.Coords,
        vendor = vendor,
        shopKey = "shop_" .. key,
        distance = Config.DistanceToCreateVendor or 50.0,
        onEnter = onEnterVendor,
        onExit = onExitVendor,
        created = false,
        removed = false,
    })

    points["shop_" .. key] = lib.points.new({
        name = "treasurehunt_shop_" .. key,
        coords = vendor.Coords,
        vendor = vendor,
        vendorPoint = points[key],
        distance = 2.0,
        nearby = nearbyVendor,
        removed = false
    })
end

function WipePeds()
    for key, point in pairs(points) do
        if point.created then
            onExitVendor(point)
        end
        point.removed = true
        point:remove()
        shopKey = point.shopKey
        if shopKey and points[shopKey] then
            points[shopKey]:remove()
            points[shopKey] = nil
        end
        points[key] = nil
    end
end
