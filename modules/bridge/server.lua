if GetResourceState("vorp_core") ~= "missing" then
    require "modules.bridge.vorp.server"
elseif GetResourceState("rsg-core") ~= "missing" then
    warn("RSG is not yet supported.")
    --require "modules.bridge.rsg.server"
else
    error("No supported framework found. Please ensure either vorp_core or rsg-core is running.")
end
