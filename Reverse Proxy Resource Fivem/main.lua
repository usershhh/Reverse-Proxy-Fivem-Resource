-- Protection Configuration

local portProxy = (GetConvar("reverseproxyPort", "false"))
local ProxyList = {
    "1.1.1.1"
}

-- Systeme Reverse Proxy Protection

local LastProxyPlayer = {}
local reverseproxyLoaded = false
AddEventHandler('playerConnecting', function(name, setCallback, deferrals)
	deferrals.defer()
	local _source = source
	local PlayerName = name
	local playerId, identifier = source

	for k,v in ipairs(GetPlayerIdentifiers(playerId)) do
		if string.match(v, 'license:') then
			identifier = string.sub(v, 9)
			break
		end
	end
    if not reverseproxyLoaded then
        deferrals.done('ReverseProxy protection not yet loaded !')
		return
    end
	if identifier then
        if not LastProxyPlayer[identifier] then
            local randomProxy = ProxyList[math.random(#ProxyList)]
            LastProxyPlayer[identifier] = randomProxy
		    ExecuteCommand('set sv_endpoints "' .. LastProxyPlayer[identifier] .. ':' .. portProxy .. '"')
        else
            ExecuteCommand('set sv_endpoints "' .. LastProxyPlayer[identifier] .. ':' .. portProxy .. '"')
        end
        print(PlayerName .. " (" .. identifier .. ")" .. " connects to the proxy " .. LastProxyPlayer[identifier])
        deferrals.done()
	else
		deferrals.done('There was an error loading your character!\nError code: identifier-missing\n\nThe cause of this error is not known, your identifier could not be found. Please come back later or report this problem to the server administration team.')
		return
	end
end)

RegisterCommand("resetproxycache", function(source, args, rawCommand)
    if source ~= 0 then return end
    LastProxyPlayer = {}
    print("Cache proxy has been reset!")
end, false)

Citizen.CreateThread(function()
    Wait(3000)
    if portProxy == "false" then
        while true do
            print("[ReverseProxy] /!\\ ERROR /!\\: ReverseProxy protection port not defined! (set reverseproxyPort \"\" in server.cfg)")
            Wait(3000)
        end
    end
    print("[ReverseProxy] Proxy Manager has Loaded")
    reverseproxyLoaded = true
    while true do
        Wait(15*60*1000)
        LastProxyPlayer = {}
    end
end)
