config = {}

config.creator = {
    spawloc = vector3( -1662.219849,-951.799194,7.708001 ), -- Local que o player spawnará quando terminar a criação  
    spawloc2 = vector3( -1662.219849,-951.799194,7.708001 ), -- Local que o player spawnará quando terminar a criação2  
    cutsine = false, -- Se true, irá aparecer a cutscene de entrada (Cena do aviao)
    preset = {
        ['masculino'] = {
            ['1'] = {
                ['mascara'] = 1,0,0,2, --MASCARA
                ['maos'] = 3,0,0,2, --MAOS
                ['calca'] = 4,165,0,1, --CALCA
                ['sapatos'] = 6,16,0,1, --SAPATOS
                ['acessorios'] = 7,0,0,2, --ACESSORIOS
                ['blusa'] = 8,15,0,2, --BLUSA
                ['colete'] = 9,-1,0,1, --COLETE
                ['jaqueta'] = 11,458,0,1, --JAQUETA
            },
        },

        ['feminino'] = {
            ['1'] = {
                ['mascara'] = 1,0,0,2, --MASCARA
                ['maos'] = 3,14,0,1, --MAOS
                ['calca'] = 4,173,0,1, --CALCA
                ['sapatos'] = 6,5,1,1, --SAPATOS
                ['acessorios'] = 7,0,0,0, --ACESSORIOS
                ['blusa'] = 8,7,0,1, --BLUSA
                ['colete'] = 9,-1,0,2, --COLETE
                ['jaqueta'] = 11,525,0,1, --JAQUETA
            },
        },
    }
}

return config