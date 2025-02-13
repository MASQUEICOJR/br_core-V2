Tunnel = module("br_core", "lib/Tunnel")
Proxy = module("br_core", "lib/Proxy")
Tools = module("br_core","lib/Tools")
Resource = GetCurrentResourceName()
SERVER = IsDuplicityVersion()

if SERVER then
    BR = Proxy.getInterface("BR")
    BRclient = Tunnel.getInterface("BR")

    CreateTunnel = {}
    Tunnel.bindInterface(Resource, CreateTunnel)

    Execute = Tunnel.getInterface(Resource)
else
    BR = Proxy.getInterface("BR")

    CreateTunnel = {}
    Tunnel.bindInterface(Resource, CreateTunnel)

    Execute = Tunnel.getInterface(Resource)
end