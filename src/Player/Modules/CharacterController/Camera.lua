local Players = game:GetService("Players")
local Player = Players.LocalPlayer

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Types = require(ReplicatedStorage.Shared.Types)



return function(character: Types.Character)
	local camera = workspace.CurrentCamera
	camera.CameraType = Enum.CameraType.Scriptable
	local HumanoidRootPart = character.HumanoidRootPart
	camera.CameraSubject = HumanoidRootPart
	local Zoom = 0

	local cameraTarget = nil

 	return {
		RunService.PostSimulation:Connect(function()

			local targetCFrame = CFrame.lookAt(HumanoidRootPart.Position + Vector3.new(0,10 + Zoom,10 + Zoom), HumanoidRootPart.CFrame.Position)

			if not cameraTarget then
				cameraTarget = targetCFrame
			end

			cameraTarget = cameraTarget:Lerp(targetCFrame, 0.1)
			camera.CFrame = cameraTarget
		end),

		UserInputService.InputChanged:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseWheel then return end

			Zoom = math.clamp(Zoom - input.Position.Z * 5, -5, 50)
		end)
	}
end