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
        DigUpTreasure(point)
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
    Wait(1)
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

RegisterNetEvent("tfd-treasurehunts:Client:StartHunt", function(item, digIndex)
    Utils.PrintDebug("Starting treasure hunt for item: " .. tostring(item) .. ", digIndex: " .. tostring(digIndex))
    huntData.digLocation = Config.Maps[item].DigLocations[digIndex].Coords
    -- Get an offset that is 3.9-30.9 so that they look around a bit, gives it a little bit of a challenge
    local blipOffsetX = math.random(39, 309) / 10.0
    local blipOffsetY = math.random(39, 309) / 10.0
    huntData.blip = Citizen.InvokeNative(
        0x45F13B7E0A15C880,
        `BLIP_STYLE_AREA`,
        huntData.digLocation.x + blipOffsetX,
        huntData.digLocation.y + blipOffsetY,
        huntData.digLocation.z,
        50.0
    )
    Citizen.InvokeNative(0x662D364ABF16DE2F, huntData.blip, `BLIP_MODIFIER_AREA`)
    Citizen.InvokeNative(0x9CB1A1623062F402, huntData.blip, "Treasure")
    SetBlipSprite(huntData.blip, `blip_deadeye_cross`)
    SetBlipScale(blip, 75.0)

    huntPoints["draw"] = lib.points.new({
        coords = huntData.digLocation,
        digLocation = huntData.digLocation,
        distance = 50.0,
        onEnter = onEnterTreasureSpot,
        onExit = onExitTreasureSpot,
        removed = false,
    })
    huntPoints["blip"] = lib.points.new({
        coords = huntData.digLocation,
        distance = 5.0,
        onEnter = onEnterBlipSpot,
        removed = false,
    })
end)

function DigUpTreasure(point)
    local coords = point.coords
    local digItems = Config.Dig.Items
    if type(digItems) == "string" then digItems = { digItems } end

    if not lib.callback.await("tfd-treasurehunts:Server:HasItems", 200, digItems) then
        ShowSimpleRightText("You don't have the required items to dig here.", 5000)
        return
    end

    --[[
    ox_lib does support props and animations, but it seemed to be spotty... so let's just do it ourselves and
    only use it for the progress bar.

    Use ox_lib over, say, VORP's because we want the ability to cancel the digging action.
    ]]
    local shovelModel = `p_shovel02x`
    if not HasModelLoaded(shovelModel) then
        RequestModel(shovelModel)
        while not HasModelLoaded(shovelModel) do
            Wait(100)
        end
    end

    local shovelObject = CreateObject(
        shovelModel,
        cache.coords.x,
        cache.coords.y,
        cache.coords.z,
        true,
        true,
        true
    )
    local boneIndex = GetEntityBoneIndexByName(cache.ped, "skel_r_hand")
    AttachEntityToEntity(shovelObject, cache.ped, boneIndex, 0.06, -0.06, -0.03, 270.0, 165.0, 17.0, false, false, true, false, true, true, false, false)
    SetModelAsNoLongerNeeded(shovelModel)

    local animDict = "amb_work@world_human_gravedig@working@male_b@idle_a"
    local animClip = "idle_a"
    if not HasAnimDictLoaded(animDict) then
        RequestAnimDict(animDict)
        while not HasAnimDictLoaded(animDict) do
            Wait(100)
        end
    end

    TaskPlayAnim(cache.ped, animDict, animClip, 8.0, 8.0, -1, 31, 0, false, false, false)
    RemoveAnimDict(animDict)

    local completed = lib.progressBar({
        label = "Digging up treasure...",
        duration = Config.Dig.Duration or 15000,
        canCancel = true,
        disable = {
            move = true,
            combat = true,
        }
    })

    DeleteObject(shovelObject)
    StopAnimTask(cache.ped, animDict, animClip, 1.0)
    Wait(0)

    if completed then
        lib.callback.await("tfd-treasurehunts:Server:DugTreasure", 200, coords)
        ClearPedTasks(cache.ped)
        if huntData.mound and DoesEntityExist(huntData.mound) then
            SetEntityAsMissionEntity(huntData.mound, false, true)
            DeleteObject(huntData.mound)
            huntData.mound = nil
        end
        point.removed = true
        cleanup()
    end
end
