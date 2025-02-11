local ICS = [[^2
        ██████╗ ██████╗      ██████╗ ██████╗ ██████╗ ███████╗
        ██╔══██╗██╔══██╗    ██╔════╝██╔═══██╗██╔══██╗██╔════╝
        ██████╔╝██████╔╝    ██║     ██║   ██║██████╔╝█████╗  
        ██╔══██╗██╔══██╗    ██║     ██║   ██║██╔══██╗██╔══╝  
        ██████╔╝██║  ██║    ╚██████╗╚██████╔╝██║  ██║███████╗
        ╚═════╝ ╚═╝  ╚═╝     ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝
                    ^0Eu posso, ^4Eu quero, ^3Eu consigo^0
                        Inicializacao Concluida
        
^0]]
AddEventHandler("onResourceStart", function(resourceName)
    if GetCurrentResourceName() == resourceName then
        Wait(3000)
        io.write("\027[H\027[2J")
        print(ICS)
    end
end)