local Player = game.Players.LocalPlayer

local PlayerGui = Player:WaitForChild("PlayerGui")

local UserInputService = game:GetService("UserInputService")

return {
	Init = function()
		for _, gui in PlayerGui:GetDescendants() do
			if not gui:GetAttribute("UIModule") then continue end
			local uiModule = gui:GetAttribute("UIModule")
			if script:FindFirstChild(uiModule) then

				require(script[uiModule])(gui)
			end
		end

		UserInputService.MouseIcon = "rbxassetid://15732653577"

		UserInputService.InputBegan:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

			UserInputService.MouseIcon = "rbxassetid://15732653688"
		end)

		UserInputService.InputEnded:Connect(function(input)
			if input.UserInputType ~= Enum.UserInputType.MouseButton1 then return end

			UserInputService.MouseIcon = "rbxassetid://15732653577"
		end)
		
	end,
}