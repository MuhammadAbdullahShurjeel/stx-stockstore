Config = {}


--- Core 
Config.Core = "RSG" -- VORP, RSG
Config.Notify = "ox_lib" -- jo_libs (MAKE SURE TO CHANGE FOLLOW JO_LIBS INSTRUCTIONS INSIDE fxmanifest.lua), ox_lib, VORP, RSG  ||| USE "ox_lib" Recommended

Config.InventoryURL = "rsg-inventory/html/images/" -- FOR VORP -> "vorp_inventory/html/img/items/" | FOR RSG -> "rsg-inventory/html/images/"
Config.PromptKey = 0xF3830D8E -- J
-- NPC
Config.DistanceSpawn = 30.0
Config.FadeIn = true
Config.Debug = false

-- BLIP 
Config.Blip = {
    blipName = 'Stock Store',            -- Config.Blip.blipName
    blipSprite = 'blip_ambient_delivery', -- Config.Blip.blipSprite
    blipScale = 0.2                       -- Config.Blip.blipScale
}

-- MENU 
Config.Sell = true
Config.Buy = true
Config.Jobs = { --  These jobs restriction is for Buy Option
    'blacksmith',
    'gunsmith',
}

Config.Locations = {
    vector4(-886.2733, -1399.7213, 44.7713, 327.9537),
}

Config.Items = {
    {
        itemname = 'bread',
        label = 'Bread',
        price = 0.05,
    },
}

---- Needs to be added WIP
Config.Locale = "en"
Config.Locales = {
    ["en"] = {
        client_menu_price_label = "Price : ",
        client_menu_stock_label = "Stock : ",
        client_menu_title = "Stock Store",
        client_notify_title = "Stock Store",
        client_menu_input_askforamountsell = "Amount You Want To Sell",
        client_notify_stockempty = "Stock is empty",
        client_menu_input_askforamountbuy = "Amount You Want To Buy",
        client_notify_notenoughstock = "Not enough stock!",
        client_prompt_label = "Open Stock Store",
        client_menu_buy_title = "Buy Available Stock",
        client_menu_sell_title = "Sell Available Stock",

        ---
        server_item_sold = "You sold ", 
        server_notenoughitem = "You don't have enough of that item.",
        server_item_bought = "You bought ",
        server_notenoughcash = "You don't have enough cash.",
        server_ped_error = "I don't know you, get lost!",
        


    },
}
