local CharacterController = {}
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)

local Player = Players.LocalPlayer



CharacterController.Modules = {}
CharacterController.Connections = {} :: {RBXScriptConnection | Types.Event}

function CharacterAdded(character: Types.Character)
	for _, connection in CharacterController.Connections do
		connection:Disconnect()
	end

	for _, module in CharacterController.Modules do
		local connections = module(character)

		if not connections then continue end

		for _, connection in connections do
			table.insert(CharacterController.Connections, connection)
		end
	end
end

function CharacterController.Init()
	Player.CharacterAdded:Connect(CharacterAdded)

	for _, module in script:GetChildren() do
		if not module:IsA("ModuleScript") then continue end
		
		table.insert(CharacterController.Modules, require(module))
	end
end

return CharacterController

