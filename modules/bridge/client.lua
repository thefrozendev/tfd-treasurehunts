if GetResourceState("vorp_core") ~= "missing" then
    Config.Framework = "VORP"
    Shared.FrameworkCore = exports.vorp_core:GetCore()
elseif GetResourceState("rsg-core") ~= "missing" then
    Config.Framework = "RSG"
else
    error("No supported framework found. Please ensure either vorp_core or rsg-core is running.")
end
