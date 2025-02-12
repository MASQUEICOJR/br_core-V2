Tunnel = module("br_core", "lib/Tunnel")
Proxy = module("br_core", "lib/Proxy")
Tools = module("br_core","lib/Tools")
Resource = GetCurrentResourceName()
SERVER = IsDuplicityVersion()

if SERVER then
    BR = Proxy.getInterface("BR")
    BRclient = Tunnel.getInterface("BR")

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource, RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
else
    BR = Proxy.getInterface("BR")

    RegisterTunnel = {}
    Tunnel.bindInterface(Resource, RegisterTunnel)

    vTunnel = Tunnel.getInterface(Resource)
end