local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Types = require(ReplicatedStorage.Shared.Types)



return function(character: Types.Character)
	local Humanoid = character.Humanoid

	Humanoid.JumpHeight = 0
	Humanoid.JumpPower = 0
end