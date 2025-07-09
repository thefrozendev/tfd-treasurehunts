Shared.Framework = {}

if GetResourceState("vorp_core") ~= "missing" then
    Config.Framework = "VORP"
    Shared.FrameworkCore = exports.vorp_core:GetCore()
    Shared.Framework.WaitUntilLoaded = function()
        repeat Wait(2000) until LocalPlayer.state.IsInSession
    end
elseif GetResourceState("rsg-core") ~= "missing" then
    warn("RSG is not yet supported.")
    -- Config.Framework = "RSG"
    -- Shared.FrameworkCore = exports.rsg_core:GetCore()
    -- Shared.Framework.WaitUntilLoaded = function()
    --     repeat Wait(2000) until LocalPlayer.state.IsInSession
    -- end
else
    error("No supported framework found. Please ensure either vorp_core or rsg-core is running.")
end
