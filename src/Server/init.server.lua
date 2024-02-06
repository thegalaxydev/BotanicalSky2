local Modules : typeof(script:GetDescendants())

Modules = {}
for _,mod in script:GetDescendants() do
	if not mod:IsA("ModuleScript") then continue end

	local succ, err = pcall(function()
		Modules[mod.Name] = require(mod)
	end)

	if not succ then warn("[GalaxyFramework] Error loading module " ..mod.Name .. " - "..err) continue end

	print("[GalaxyFramework] Successfully loaded server module: " .. mod.Name)

	if Modules[mod.Name] then
		if Modules[mod.Name].Init then
			succ, err = pcall(Modules[mod.Name].Init)

			if not succ then warn("[GalaxyFramework] Error initializing server module "..mod.Name.." - "..err) continue end
			
			if succ then print("[GalaxyFramework] Successfully initialized server module ".. mod.Name) end

		end
	end
end