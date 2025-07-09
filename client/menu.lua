local featherMenu = exports['feather-menu'].initiate()
local menus = {}

local function openMenu(menu, firstPage)
    menu:Open({
        cursorFocus = true,
        menuFocus = true,
        startupPage = firstPage,
        sound = {
            action = "SELECT",
            soundset = "RDRO_Character_Creator_sounds"
        }
    })
end

function OpenVendorMenu(vendorIdx)
    local vendor = Config.MapVendors[vendorIdx]
    if not vendor then
        print("Vendor not found: " .. vendorIdx)
        return
    end

    menus["vendor"] = featherMenu:RegisterMenu('feather:treasurehunts:vendor:menu', {
        top = '12rem',
        left = '70%',
        width = '700px',
        style = {},
        contentslot = {
            style = {
                ['height'] = '45vh',
            }
        },
        footerslot = {
            style = {
                ['margin-top'] = '2rem',
                ['padding-bottom'] = '2rem'
            }
        },
        draggable = true,
        canClose = false
    })

    local firstPage = menus["vendor"]:RegisterPage('intro:page')

    firstPage:RegisterElement('header', {
        value = "Treasure Hunt Vendor",
        slot = "header",
    })
    firstPage:RegisterElement("line", { slot = "header" })

    firstPage:RegisterElement("line", {
        slot = "footer",
        style = {
            ["padding-bottom"] = "1rem",
        }
    })
    firstPage:RegisterElement("button", {
        slot = "footer",
        label = "Close",
        sound = {
            action = "CLOSE",
            soundset = "RDRO_Character_Creator_sounds"
        }
    }, function()
        menus["vendor"]:Close()
    end)

    for i=1, #vendor.Stock do
        firstPage:RegisterElement("button", {
            label = "Buy " .. vendor.Stock[i].Label .. " - " .. Utils.FormatMoney(vendor.Stock[i].Price),
            slot = "content",
            sound = {
                action = "SELECT",
                soundset = "RDRO_Character_Creator_sounds"
            }
        }, function()
            menus["vendor"]:Close()

            local input = lib.inputDialog("How many maps would you like to buy?", {
                { type = "number", label = "Quantity", required = true, min = 1, max = 10 }
            })
            local ok, msg = lib.callback.await("tfd-treasurehunts:Server:BuyMap", 200, vendorIdx, i, input[1])
            if not ok then
                if msg == "low_money" then
                    ShowSimpleRightText("You don't have enough money to buy this map.", 5000)
                else
                    ShowSimpleRightText("An error occurred while trying to buy the map.", 5000)
                end
                return
            end
        end)
    end

    openMenu(menus["vendor"], firstPage)
end

AddEventHandler("onResourceStop", function(resourceName)
    if resourceName == GetCurrentResourceName() then
        for _, menu in pairs(menus) do
            menu:Close()
        end
    end
end)
