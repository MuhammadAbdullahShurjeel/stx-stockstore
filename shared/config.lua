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

Config.Locale = "en" -- en (ENGLISH) | de (German) | fr (French) | es (Spanish) | ar (Arabic) ||||| if any language has an issue kindly let me know ill update it.
Config.Locales = {
    ["en"] = { -- English
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
        server_item_sold = "You sold ", 
        server_notenoughitem = "You don't have enough of that item.",
        server_item_bought = "You bought ",
        server_notenoughcash = "You don't have enough cash.",
        server_ped_error = "I don't know you, get lost!",
    },

    ["es"] = { -- Spanish
        client_menu_price_label = "Precio : ",
        client_menu_stock_label = "Inventario : ",
        client_menu_title = "Tienda de Stock",
        client_notify_title = "Tienda de Stock",
        client_menu_input_askforamountsell = "Cantidad que quieres vender",
        client_notify_stockempty = "¡El inventario está vacío!",
        client_menu_input_askforamountbuy = "Cantidad que quieres comprar",
        client_notify_notenoughstock = "¡No hay suficiente inventario!",
        client_prompt_label = "Abrir Tienda de Stock",
        client_menu_buy_title = "Comprar Inventario Disponible",
        client_menu_sell_title = "Vender al Inventario",
        server_item_sold = "Has vendido ",
        server_notenoughitem = "No tienes suficiente de ese artículo.",
        server_item_bought = "Has comprado ",
        server_notenoughcash = "No tienes suficiente dinero.",
        server_ped_error = "¡No te conozco, lárgate!",
    },

    ["de"] = { -- German
        client_menu_price_label = "Preis : ",
        client_menu_stock_label = "Bestand : ",
        client_menu_title = "Lagerladen",
        client_notify_title = "Lagerladen",
        client_menu_input_askforamountsell = "Menge, die du verkaufen willst",
        client_notify_stockempty = "Bestand ist leer",
        client_menu_input_askforamountbuy = "Menge, die du kaufen willst",
        client_notify_notenoughstock = "Nicht genug Bestand!",
        client_prompt_label = "Lagerladen öffnen",
        client_menu_buy_title = "Verfügbaren Bestand kaufen",
        client_menu_sell_title = "Bestand verkaufen",
        server_item_sold = "Du hast verkauft ",
        server_notenoughitem = "Du hast nicht genug von diesem Artikel.",
        server_item_bought = "Du hast gekauft ",
        server_notenoughcash = "Du hast nicht genug Geld.",
        server_ped_error = "Ich kenne dich nicht, verschwinde!",
    },

    ["fr"] = { -- French
        client_menu_price_label = "Prix : ",
        client_menu_stock_label = "Stock : ",
        client_menu_title = "Magasin de Stock",
        client_notify_title = "Magasin de Stock",
        client_menu_input_askforamountsell = "Quantité à vendre",
        client_notify_stockempty = "Le stock est vide",
        client_menu_input_askforamountbuy = "Quantité à acheter",
        client_notify_notenoughstock = "Pas assez de stock !",
        client_prompt_label = "Ouvrir le Magasin de Stock",
        client_menu_buy_title = "Acheter le Stock Disponible",
        client_menu_sell_title = "Vendre au Stock",
        server_item_sold = "Vous avez vendu ",
        server_notenoughitem = "Vous n'avez pas assez de cet objet.",
        server_item_bought = "Vous avez acheté ",
        server_notenoughcash = "Vous n'avez pas assez d'argent.",
        server_ped_error = "Je ne te connais pas, dégage !",
    },
    ["ar"] = { -- Arabic
        client_menu_price_label = "السعر : ",
        client_menu_stock_label = "المخزون : ",
        client_menu_title = "متجر المخزون",
        client_notify_title = "متجر المخزون",
        client_menu_input_askforamountsell = "الكمية التي تريد بيعها",
        client_notify_stockempty = "المخزون فارغ",
        client_menu_input_askforamountbuy = "الكمية التي تريد شراءها",
        client_notify_notenoughstock = "لا يوجد مخزون كافٍ!",
        client_prompt_label = "فتح متجر المخزون",
        client_menu_buy_title = "شراء المخزون المتاح",
        client_menu_sell_title = "بيع إلى المخزون",

        server_item_sold = "لقد بعت ",
        server_notenoughitem = "ليس لديك ما يكفي من هذا العنصر.",
        server_item_bought = "لقد اشتريت ",
        server_notenoughcash = "ليس لديك ما يكفي من المال.",
        server_ped_error = "لا أعرفك، ابتعد من هنا!",
    }
}
