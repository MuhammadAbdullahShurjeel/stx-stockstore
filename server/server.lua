
if Config.Core == "VORP" then
    VORPcore = exports.vorp_core:GetCore()
    VorpInv = exports.vorp_inventory:vorp_inventoryApi()
elseif Config.Core == "RSG" then
    RSGCore = exports['rsg-core']:GetCoreObject()
end

----------- FUNCTIONS 

local function NotifyHandler(id, title, text, notitype, duration)
    local src = id
    if Config.Notify == "RSG" then
        --- Needs to be added

    elseif Config.Notify == "ox_lib" then
        TriggerClientEvent('ox_lib:notify', src, {
            title = title,
            description = text,
            type = notitype,
            duration = duration,
            position = "center-right"
        })
    elseif Config.Notify == "jo_libs" then
        if notitype == "success" then
            jo.notif.rightSuccess(src, text)
        elseif notitype == "error" then
            jo.notif.rightError(src, text)
        end
    elseif Config.Notify == "VORP" then
        TriggerClientEvent('vorp:TipBottom', src, text, duration)
    else
        --- Add your custom
    end

end

local function getItemPrice(itemname)
    for _, item in pairs(Config.Items) do
        if item.itemname == itemname then
            return item.price
        end
    end
    return nil
end

local function updateItemStock(itemname, stock)
    local query = "UPDATE stx_stockvender SET stock =? WHERE itemname =?"
    MySQL.query(query, { stock, itemname })
end

local function isEmpty(table)
    for _, _ in pairs(table) do
        return false
    end
    return true
end

local function isItemInConfig(itemname)
    for _, item in pairs(Config.Items) do
        if item.itemname == itemname then
            return true
        end
    end
    return false
end

local function syncDatabase()
    local dbItems = MySQL.query.await("SELECT itemname FROM stx_stockvender")
    for _, v in pairs (Config.Items) do
        local result = MySQL.query.await("SELECT stock FROM stx_stockvender WHERE itemname = ?", {v.itemname})
        if not isEmpty(result) then
            print('This already exist : '..v.itemname)
        else
            print('Inserting '..v.itemname)
            MySQL.insert('INSERT INTO stx_stockvender (`itemname`, `stock`) VALUES (?, ?)', {
                v.itemname,
                0
            })
        end
    end
    -- Delete extra items that got removed from config
    if dbItems then
        for _, dbItem in pairs(dbItems) do
            if not isItemInConfig(tostring(dbItem.itemname)) then
                print('Removing obsolete item from database: ' .. dbItem.itemname)
                MySQL.query("DELETE FROM stx_stockvender WHERE itemname = ?", {dbItem.itemname})
            end
        end
    end
end

local function getJob(job)
    for k, v in pairs(Config.Jobs) do
        if v == job then
            return true
        end
    end
    return false
end

---------------------- EVENTS

RegisterServerEvent('stx-stockstore:server:sellitem')
AddEventHandler('stx-stockstore:server:sellitem', function(itemname, orgamt)
    local _source = source
    if Config.Core == "VORP" then
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter
            TriggerEvent("vorpCore:getUserInventory", _source, function(getInventory)
                local playerHas = 0
                for _, item in pairs(getInventory) do
                    if item.name == itemname then
                        playerHas = item.count
                        break
                    end
                end
                if tonumber(playerHas) >= tonumber(orgamt) then
                    -- Remove the item(s)
                    VorpInv.subItem(_source, itemname, orgamt)

                    -- Update stock table in database
                    local price = getItemPrice(itemname)
                    exports.ghmattimysql:execute('SELECT * FROM stx_stockvender', {}, function(result)
                        if result then
                            for _, v in pairs(result) do
                                if v.itemname == itemname then
                                    updateItemStock(itemname, v.stock + orgamt)
                                end
                            end
                        end
                    end)

                    Character.addCurrency(0, orgamt * price) -- 0 = cash
                    NotifyHandler(_source, "Stock Store", "You sold " .. orgamt .. "x " .. itemname .. "!", "success", 4000)
                else
                    NotifyHandler(_source, "Stock Store", "You don't have enough of that item.", "error", 4000)
                end
            end)
    elseif Config.Core == "RSG" then
        local Player = RSGCore.Functions.GetPlayer(_source)
        if Player.Functions.RemoveItem(itemname, orgamt) then
            local price = getItemPrice(itemname)
            MySQL.query('SELECT * FROM stx_stockvender', function(result)
                if result then
                    for k, v in pairs (result) do
                        if v.itemname == itemname then
                            --print(v.stock)
                            updateItemStock(itemname, v.stock + orgamt)
                        end
                    end
                else
                    --cb(nil)
                end
            end)
            Player.Functions.AddMoney('cash', orgamt*price)
            NotifyHandler(_source, "Stock Store", "You sold " .. orgamt .. "x " .. itemname .. "!", "success", 4000)
        else
            NotifyHandler(_source, "Stock Store", "You don't have enough of that item.", "error", 4000)
        end

    end
end)

RegisterServerEvent('stx-stockstore:server:buyitem')
AddEventHandler('stx-stockstore:server:buyitem', function(itemname, orgamt)
    local _source = source
    if Config.Core == "VORP" then
        local User = VORPcore.getUser(_source)
        local Character = User.getUsedCharacter
        local price = getItemPrice(itemname)
        local totalCost = orgamt * price
        local cash = Character.money

        if tonumber(cash) >= tonumber(totalCost) then
            Character.removeCurrency(0, totalCost)

            exports.ghmattimysql:execute('SELECT * FROM stx_stockvender', {}, function(result)
                if result then
                    for _, v in pairs(result) do
                        if v.itemname == itemname then
                            updateItemStock(itemname, v.stock - orgamt)
                        end
                    end
                end
            end)
            VorpInv.addItem(_source, itemname, orgamt)
            NotifyHandler(_source, "Stock Store", "You bought " .. orgamt .. "x " .. itemname .. "!", "success", 4000)

        else
            NotifyHandler(_source, "Stock Store", "You don't have enough cash.", "error", 4000)
        end
    elseif Config.Core == "RSG" then
        local Player = RSGCore.Functions.GetPlayer(_source)
        local price = getItemPrice(itemname)
        if Player.Functions.RemoveMoney('cash', orgamt*price) then
            local price = getItemPrice(itemname)
            local stock = getItemStock(tostring(itemname))
            MySQL.query('SELECT * FROM stockvenderr', function(result)
                if result then
                    for k, v in pairs (result) do
                        if v.itemname == itemname then
                            updateItemStock(itemname, v.stock - orgamt)
                        end
                    end
                else
                end
            end)
            Player.Functions.AddItem(itemname, orgamt)
            NotifyHandler(_source, "Stock Store", "You bought " .. orgamt .. "x " .. itemname .. "!", "success", 4000)
        end

    end
end)



-------------- CALL BACKS
if Config.Core == "VORP" then
    VORPcore.Callback.Register("stx-stockstore:createcallback:getstock", function(source, cb)
        local User = VORPcore.getUser(source)
        local Character = User.getUsedCharacter
        local job = Character.job

        if getJob(job) then
            exports.ghmattimysql:execute('SELECT * FROM stx_stockvender', {}, function(result)
                if result then
                    cb(result)
                else
                    cb(nil)
                end
            end)
        else
            NotifyHandler(source, "Stock Store", "I don't know you, get lost!", "error", 4000)
            cb(nil)
        end
    end)
elseif Config.Core == "RSG" then
    RSGCore.Functions.CreateCallback("stx-stockstore:createcallback:getstock", function(source, cb)
        local src = source
        local pData = RSGCore.Functions.GetPlayer(src)
        local PlayerJob = pData.PlayerData.job.name
        if getJob(PlayerJob) then
            MySQL.query('SELECT * FROM stockvenderr', function(result)
                if result then
                    cb(result)
                else
                    cb(nil)
                end
            end)
        else
            NotifyHandler(source, "Stock Store", "I don't know you, get lost!", "error", 4000)
            cb(nil)
        end
    end)

end



-----

syncDatabase()

