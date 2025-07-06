if not lib then error("ox_lib is not loaded. Please ensure ox_lib is started before this resource.") end

Shared = {
    Blips = {},
}

require "modules.utils.shared"
require "client.prompts"
require "client.vendors"
require "client.menu"
require "client.hunt"
require "client.notifications"

Citizen.CreateThread(function()
    repeat Wait(2000) until LocalPlayer.state.IsInSession -- VORP Only, fix this!

    SetupPrompts()

    for i=1, #Config.MapVendors do
        RegisterVendor(i, Config.MapVendors[i])

        if Config.Blips.Show then
            Shared.Blips[i] = BlipAddForCoords(
                1664425300,
                Config.MapVendors[i].Coords.x,
                Config.MapVendors[i].Coords.y,
                Config.MapVendors[i].Coords.z
            )
            SetBlipSprite(Shared.Blips[i], Config.Blips.Sprite or `blip_mp_game_treasure_hunt`)
            SetBlipScale(Shared.Blips[i], Config.Blips.Scale or 0.2)
            SetBlipName(Shared.Blips[i], Config.Blips.Name or "Treasure Map Vendor")
            SetBlipModifier(Shared.Blips[i], Config.Blips.Color or `BLIP_MODIFIED_MP_COLOR_32`)
        end
    end
end)
