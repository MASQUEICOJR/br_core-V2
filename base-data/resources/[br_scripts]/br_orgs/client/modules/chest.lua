RegisterNuiCallback('GetRegisters', function(data, cb)
    print("TESTE")
    cb(vTunnel.getLogs())
end)