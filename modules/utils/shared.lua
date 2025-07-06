Utils = {}

function Utils.PrintDebug(message)
    if Config.Debug then
        print("[tfd-treasurehunts] " .. message)
    end
end

function Utils.FormatMoney(amount)
    return string.format("$%.2f", amount)
end
