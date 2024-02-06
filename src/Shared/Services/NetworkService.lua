-- this is literally just a BridgeNet wrapper
-- - Galaxy
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Packages = ReplicatedStorage.Packages

local Network = {
	['BridgeNet2'] = require(Packages["bridgenet2"])
}
local Callbacks = {}

local RunService = game:GetService("RunService")

function Network.Invoke(callback: string, ...: any)
	if not RunService:IsClient() then return end

	return script.Remote:InvokeServer(callback, ...)
end

function Network.AddCallback(name: string, func: (Player, ...any)->any)
	if not RunService:IsServer() then return end

	Callbacks[name] = func
end

function Network.Init()
	if not RunService:IsServer() then return end

	script.Remote.OnServerInvoke = function(player: Player, callback: string, ...: any)
		if not Callbacks[callback] then
			warn("Callback " .. callback .. " is not connected. Did you forget to add it on the server?")

			return
		end

		return Callbacks[callback](player, ...)
	end
end

return Network