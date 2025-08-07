

if Config.Core == "VORP" then
    VORPcore = exports.vorp_core:GetCore()
elseif Config.Core == "RSG" then
    RSGCore = exports['rsg-core']:GetCoreObject()
else
    print("ERROR : CORE ISNT SELECTED")
end


local function NotifyHandler(title, text, notitype, duration)
    local src = id
    if Config.Notify == "RSG" then
        --- Needs to be added
        RSGCore.Functions.Notify(text, notitype, duration)
    elseif Config.Notify == "ox_lib" then
        lib.notify({
            title = title,
            description = text,
            type = notitype,
            duration = duration,
            position = "center-right"
        })
    elseif Config.Notify == "jo_libs" then
        if notitype == "success" then
            jo.notif.rightSuccess(text)
        elseif notitype == "error" then
            jo.notif.rightError(text)
        end
    elseif Config.Notify == "VORP" then
        TriggerClientEvent('vorp:TipBottom', text, duration)
    else
        --- Add your custom
    end

end

local function getItemLabel(itemname)
    for _, item in pairs(Config.Items) do
        if item.itemname == itemname then
            return item.label
        end
    end
    return nil
end

local function SellMenu()
    local menu = {}

    if Config.Core == "VORP" then
        for k, v in pairs (Config.Items) do
            imglnk = "nui://" ..Config.InventoryURL.. "" ..v.itemname .. ".png"
            menu[#menu + 1] = {
                title = v.label,
                description = Config.Locales[Config.Locale].client_menu_price_label .. "" ..v.price,
                image = imglnk,
                onSelect = function()
                    local input = lib.inputDialog(Config.Locales[Config.Locale].client_menu_title, {Config.Locales[Config.Locale].client_menu_input_askforamountsell})
                    if input then
                        if input[1] then
                            TriggerServerEvent('stx-stockstore:server:sellitem', v.itemname, input[1])
                        end
                    end
                end
            }
        end
        lib.registerContext({
            id = 'stx_stockstore_',
            title = Config.Locales[Config.Locale].client_menu_title,
            options = menu
        })
        lib.showContext('stx_stockstore_')

    elseif Config.Core == "RSG" then
        for k, v in pairs (Config.Items) do
            imglnk = "nui://" ..Config.InventoryURL.. "" ..RSGCore.Shared.Items[tostring(v.itemname)].image
            menu[#menu + 1] = {
                title = v.label,
                description = Config.Locales[Config.Locale].client_menu_price_label .. "" ..v.price,
                image = imglnk,
                onSelect = function()
                    local input = lib.inputDialog(Config.Locales[Config.Locale].client_menu_title, {Config.Locales[Config.Locale].client_menu_input_askforamountsell})
                    if input then
                        if input[1] then
                            TriggerServerEvent('stx-stockstore:server:sellitem', v.itemname, input[1])
                        end
                    end
                end
            }
        end
        lib.registerContext({
            id = 'stx_stockstore_',
            title = Config.Locales[Config.Locale].client_menu_title,
            options = menu
        })
        lib.showContext('stx_stockstore_')
    end
end



local function BuyMenu()
    if Config.Core == "VORP" then
        VORPcore.Callback.TriggerAsync("stx-stockstore:createcallback:getstock", function(result)
            local menus = {}
            if result == nil then
                return
            end

            for _, v in pairs(result) do
                local name = getItemLabel(v.itemname)
                menus[#menus + 1] = {
                    title = name or v.itemname,
                    description =  Config.Locales[Config.Locale].client_menu_stock_label .. "".. v.stock,
                    onSelect = function()
                        if v.stock <= 0 then
                            NotifyHandler(Config.Locales[Config.Locale].client_notify_title, Config.Locales[Config.Locale].client_notify_stockempty, "error", 4000)
                            return
                        end

                        local input = lib.inputDialog(Config.Locales[Config.Locale].client_menu_title, {Config.Locales[Config.Locale].client_menu_input_askforamountbuy})
                        if input and input[1] then
                            local amount = tonumber(input[1])
                            if not amount or amount <= 0 then return end

                            if amount > v.stock then
                                NotifyHandler(Config.Locales[Config.Locale].client_notify_title, Config.Locales[Config.Locale].client_notify_notenoughstock, "error", 4000)
                                return
                            end

                            TriggerServerEvent('stx-stockstore:server:buyitem', v.itemname, amount)
                        end
                    end
                }
            end
            lib.registerContext({
                id = 'stx_stockstore_buy_',
                title = Config.Locales[Config.Locale].client_menu_title,
                options = menus
            })
            lib.showContext('stx_stockstore_buy_')
        end)
    elseif Config.Core == "RSG" then
        RSGCore.Functions.TriggerCallback("stx-stockstore:createcallback:getstock", function(result)
            if result == nil then
                return
            end
            for k, v in pairs (result) do
                local name = getItemLabel(v.itemname)                
                menus[#menus + 1] = {
                    title = ''..name,
                    description = Config.Locales[Config.Locale].client_menu_stock_label .. "".. v.stock,
                    onSelect = function()
                        if v.stock == 0 then 
                            NotifyHandler(Config.Locales[Config.Locale].client_notify_title, Config.Locales[Config.Locale].client_notify_stockempty, "error", 4000)
                            return 
                        end
                        local input = lib.inputDialog(Config.Locales[Config.Locale].client_menu_title, {Config.Locales[Config.Locale].client_menu_input_askforamountbuy})
                        if input then
                            if input[1] then
                                if tonumber(input[1]) > v.stock then 
                                    NotifyHandler(Config.Locales[Config.Locale].client_notify_title, Config.Locales[Config.Locale].client_notify_notenoughstock, "error", 4000)
                                    return 
                                end
                                TriggerServerEvent('stx-stockstore:server:buyitem', v.itemname, input[1], v.stock)
                            end
                        end
                    end
                }
            end
            lib.registerContext({
                id = 'stx_stockstore_buy_',
                title = Config.Locales[Config.Locale].client_menu_title,
                options = menus
            })
            lib.showContext('stx_stockstore_buy_')
        end)

    end

end


----

RegisterNetEvent('stx-stockstore:client:openbuymenu', function()
    local menuOptions = {}

    if Config.Buy then
        table.insert(menuOptions, {
            title = Config.Locales[Config.Locale].client_menu_buy_title,
            onSelect = function()
                BuyMenu()
            end,
        })
    end

    if Config.Sell then
        table.insert(menuOptions, {
            title = Config.Locales[Config.Locale].client_menu_sell_title,
            onSelect = function()
                SellMenu()
            end,
        })
    end

    lib.registerContext({
        id = 'stx_stockstore_mainmenu_',
        title = Config.Locales[Config.Locale].client_menu_title,
        options = menuOptions
    })

    lib.showContext('stx_stockstore_mainmenu_')
end)




-------------- PROMPT
local promptGroup = GetRandomIntInRange(0, 0x7FFFFFFF)
local prompt
local promptKey = Config.PromptKey -- 'J' key
local labelText = Config.Locales[Config.Locale].client_prompt_label
local promptRadius = 2.0

local function registerPrompts()
    local newPrompt = PromptRegisterBegin()
    PromptSetControlAction(newPrompt, promptKey)
    PromptSetText(newPrompt, CreateVarString(10, 'LITERAL_STRING', labelText))
    PromptSetEnabled(newPrompt, true)
    PromptSetVisible(newPrompt, true)
    PromptSetHoldMode(newPrompt, true)
    PromptSetGroup(newPrompt, promptGroup)
    PromptRegisterEnd(newPrompt)
    return newPrompt
end

CreateThread(function()
    prompt = registerPrompts()

    while true do
        Wait(0)

        local ped = PlayerPedId()
        local coords = GetEntityCoords(ped)
        local showPrompt = false

        for _, loc in pairs(Config.Locations) do
            if #(coords - loc.xyz) < promptRadius then
                showPrompt = true
                break
            end
        end

        if showPrompt then
            local label = CreateVarString(10, 'LITERAL_STRING', labelText)
            UiPromptSetActiveGroupThisFrame(promptGroup, label)
            if UiPromptHasHoldModeCompleted(prompt) then
                TriggerEvent('stx-stockstore:client:openbuymenu')
                Wait(1000) -- prevent spamming
            end
        end
    end
end)

