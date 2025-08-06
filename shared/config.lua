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
Config.Sell = false
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
        itemname = 'wood',
        label = 'Wood',
        price = 0.05,
    },
}

---- Needs to be added WIP
Config.Locale = "en"
Config.Locales = {
    ["en"] = {

    },
}