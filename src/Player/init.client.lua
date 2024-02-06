local ClientModules = script:WaitForChild("Modules")

local Modules : typeof(ClientModules:GetChildren())

Modules = {}
local warnings = {}
for _,mod in ClientModules:GetChildren() do
	if not mod:IsA("ModuleScript") then continue end

	local succ, err = pcall(function()
		Modules[mod.Name] = require(mod)
	end)

	if not succ then table.insert(warnings, err) continue end

	print("[GalaxyFramework] Successfully loaded client module: " .. mod.Name)

	if Modules[mod.Name] and Modules[mod.Name].Init then
		local succ, err = pcall(Modules[mod.Name].Init)
		
		if not succ then table.insert(warnings, err) continue end
	end
end

print([[

█▀▀ ▄▀█ █░░ ▄▀█ ▀▄▀ █▄█
█▄█ █▀█ █▄▄ █▀█ █░█ ░█░

█▀▀ █▀█ ▄▀█ █▀▄▀█ █▀▀ █░█░█ █▀█ █▀█ █▄▀
█▀░ █▀▄ █▀█ █░▀░█ ██▄ ▀▄▀▄▀ █▄█ █▀▄ █░█

Loaded all client modules. Please report any errors below this line.
----------------------------------------------------------------------
]])

for _, err in warnings do
	warn(err)
end