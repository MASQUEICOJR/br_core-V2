local cfg = {
    pause_menu_text = '~g~~h~SU\'EL~h~ ~b~VRPEX~y~ 3.1',
    loggin_system = '', --discord, print or database
    fristspawn = vec3(0, 0, 0),
    save_interval = GetConvarInt('br_core:save_interval', 60),
    enable_allowlist = GetConvarInt('br_core:enable_allowlist', 1) == 1, -- enable/disable whitelist     
    inventory_weight_per_strength = GetConvarInt('br_core:inventory_weight', 10),
    thirst_per_minute = tonumber(GetConvar('br_core:thirst_per_minute', '2.5')) or 2.5,
    hunger_per_minute = tonumber(GetConvar('br_core:hunger_per_minute', '1.25')) or 1.25,
    overflow_damage_factor = GetConvarInt('br_core:overflow_damage_factor', 2),
    allow_audio_player_from_client = GetConvarInt('br_core:allow_audio_player_from_client', 1) == 1,
    sound_default_distance = GetConvarInt('br_core:sound_default_distance', 100),
    pvp = GetConvarInt('br_core:pvp', 1) == 1,
    phone_format = "DDD-DDD",
    registration_format = 'DDAALAAL',
    coma_duration = 0.2,
    load_duration = 30,
    load_delay = 60,
    global_delay = 0,
    ping_timeout = 5,
    clear_inventory_on_death = GetConvarInt('br_core:clear_inventory', 1) == 1,
    -- illegal items (seize)
    -- specify list of "idname" or "*idname" to seize all parametric items
    money_type = {
        cash = 1000,
        bank = 10000
    },
   
    discord = {
        enabled = false,
        showPlayerCount = true,
        appId = "",
        iconLarge = "",
        iconLargeHoverText = "",
        iconSmall = "",
        iconSmallHoverText = "",
        buttons = {
            { text = "BUTTON 1", url = "" },
            { text = "BUTTON 2", url = "" },
        },
        updateRate = 15000 -- 15 segundos
    },
    disables = {
        driverby = true,
        idlecam = true,
        disable_auto_swap_weapon = GetConvarInt('br_core:disable_auto_swap_weapon', 0) == 1,
        disable_auto_reload = GetConvarInt('br_core:disable_auto_reload', 0) == 1,
    },
    initial_items = {
        ['phone'] = 1,        
        ['bandage'] = 3,
        ['burger'] = 10,
        ['water'] = 10,
    }
}

return cfg
