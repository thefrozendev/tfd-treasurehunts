local huntData = {}
local huntPoints = {}

local function cleanup()
    for k, v in pairs(huntPoints) do
        v.removed = true
        v:remove()
        huntPoints[k] = nil
    end
end

local function nearbyDigSpot(point)
    if point.removed then return end

    if ShowPrompt("dig", "dig") == "dig" then
        DigUpTreasure(point.coords)
        point.removed = true
        cleanup()
    end
end

local function onEnterTreasureSpot(point)
    if point.removed then return end

    if huntData.entity and DoesEntityExist(huntData.entity) then
        return
    end

    local model = `mp005_p_dirtpile_gen_buried`
    if not HasModelLoaded(model) then
        RequestModel(model)
        while not HasModelLoaded(model) do
            Wait(100)
        end
    end

    huntData.mound = CreateObject(
        model,
        point.digLocation.x,
        point.digLocation.y,
        point.digLocation.z,
        false,
        false,
        false
    )

    SetEntityAsMissionEntity(huntData.mound, true, true)

    Wait(50)

    PlaceObjectOnGroundProperly(huntData.mound)
    FreezeEntityPosition(huntData.mound, true)

    huntPoints["dig"] = lib.points.new({
        coords = point.digLocation,
        distance = 2.0,
        nearby = nearbyDigSpot,
        removed = false,
    })

    SetModelAsNoLongerNeeded(model)
end

local function onExitTreasureSpot(point)
    if point.removed then return end

    if huntData.mound and DoesEntityExist(huntData.mound) then
        SetEntityAsMissionEntity(huntData.mound, false, true)
        DeleteObject(huntData.mound)
        huntData.mound = nil
    end
end

-- Cleanup blip
local function onEnterBlipSpot(point)
    if point.removed then return end

    point.removed = true
    if huntData.blip then
        RemoveBlip(huntData.blip)
        huntData.blip = nil
    end

    point:remove()
    huntPoints["blip"] = nil
end

RegisterNetEvent("tfd-treasurehunts:Client:StartHunt", function(data)
    huntData.digLocation = data.digLocation
    huntData.blip = Citizen.InvokeNative(
        0x45F13B7E0A15C880,
        `BLIP_STYLE_AREA`,
        data.digLocation.x,
        data.digLocation.y,
        data.digLocation.z,
        5.0
    )
    Citizen.InvokeNative(0x662D364ABF16DE2F, huntData.blip, `BLIP_MODIFIER_AREA`)
    Citizen.InvokeNative(0x9CB1A1623062F402, huntData.blip, "Treasure")
    SetBlipSprite(huntData.blip, `blip_deadeye_cross`)
    SetBlipScale(blip, 75.0)

    huntPoints["draw"] = lib.points.new({
        coords = data.digLocation,
        digLocation = data.digLocation,
        distance = 50.0,
        onEnter = onEnterTreasureSpot,
        onExit = onExitTreasureSpot,
        removed = false,
    })
    huntPoints["blip"] = lib.points.new({
        coords = data.digLocation,
        distance = 5.0,
        onEnter = onEnterBlipSpot,
        removed = false,
    })
end)

function DigUpTreasure(coords)
    local digItems = Config.Dig.Items
    if type(digItems) == "string" then digItems = { digItems } end

    if not lib.callback.await("tfd-treasurehunts:Server:HasItems", 200, digItems) then
        ShowSimpleRightText("You don't have the required items to dig here.", 5000)
        return
    end

    local completed = lib.progressBar({
        label = "Digging up treasure...",
        duration = Config.Dig.Duration or 15000,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
        },
        anim = {
            dict = "amb_work@world_human_gravedig@working@male_b@idle_a",
            clip = "idle_a",
        },
        prop = {
            model = `p_shovel02x`,
            bone = `SKEL_R_HAND`,
            pos = vector3(0.06, -0.06, -0.03),
            rot = vector3(270.0, 165.0, 17.0),
        }
    })

    if completed then
        lib.callback.await("tfd-treasurehunts:Server:DugTreasure", 200, coords)
        ClearPedTasks(cache.ped)
        if huntData.mound and DoesEntityExist(huntData.mound) then
            SetEntityAsMissionEntity(huntData.mound, false, true)
            DeleteObject(huntData.mound)
            huntData.mound = nil
        end
        cleanup()
    end
end
