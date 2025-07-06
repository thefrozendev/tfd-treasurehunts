function NotifyTop(title, message, duration)
    if Config.Framework == "VORP" then
        Shared.FrameworkCore.NotifySimpleTop(title, message, duration)
    else
        exports.rNotify:ShowTopNotification(title, message, duration)
    end
end

function NotifyLeft(title, message, dict, icon, duration, color)
    if Config.Framework == "VORP" then
        Shared.FrameworkCore.NotifyLeft(title, message, dict, icon, duration, color)
    else
        exports.rNotify:ShowAdvancedNotification(title, message, dict, icon, duration, color)
    end
end

function NotifyTip(message, duration)
    if Config.Framework == "VORP" then
        Shared.FrameworkCore.NotifyTip(message, duration)
    else
        exports.rNotify:ShowTooltip(message, duration)
    end
end

function ShowSimpleRightText(message, duration)
    if Config.Framework == "VORP" then
        Shared.FrameworkCore.NotifyRightTip(message, duration)
    else
        exports.rNotify:ShowSimpleRightText(message, duration)
    end
end

RegisterNetEvent("tfd-treasurehunts:Client:NotifyRight", function(message, duration)
    ShowSimpleRightText(message, duration or 5000)
end)

RegisterNetEvent("tfd-treasurehunts:Client:NotifyLeft", function(title, message, dict, icon, duration, color)
    NotifyLeft(title, message, dict, icon, duration, color)
end)
