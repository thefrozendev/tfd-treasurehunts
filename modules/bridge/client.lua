if GetResourceState("vorp_core") ~= "missing" then
    Config.Framework = "VORP"
    Shared.FrameworkCore = exports.vorp_core:GetCore()
    Shared.Framework.WaitUntilLoaded = function()
        repeat Wait(2000) until LocalPlayer.state.IsInSession
    end
elseif GetResourceState("rsg-core") ~= "missing" then
    Config.Framework = "RSG"
    Shared.Framework.WaitUntilLoaded = function()
        repeat Wait(2000) until LocalPlayer.state.isLoggedIn
    end
else
    error("No supported framework found. Please ensure either vorp_core or rsg-core is running.")
end
