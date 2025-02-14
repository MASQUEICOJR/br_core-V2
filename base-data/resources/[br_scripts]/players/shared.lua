require '@br_core.lib.utils'
local Proxy = require '@br_core.lib.Proxy'
BR = Proxy.getInterface('BR')

--config
Config = {
    Stress = {
        Enable = true,
        AnimFxEffect = "",
        CameraShake = "",
        DamageTime = 3000, 
        ApplyDamageAbove = 80, -- aplicar dano acima da porcentagem
        DamageInfo = {
                BlackScreen = true,
                BlackScreenTime = 2000,
                Damage = 0.05                        
        },
        ByPassJobs = {}
    }
}
