local PlayerManager = {}
local Players = game:GetService("Players")

local GameManager = require(script.Parent.GameManager)

function PlayerManager.Init()
	Players.PlayerAdded:Connect(function(player: Player)

		player.CharacterAdded:Connect(function(character)
			local humanoidDescription = Players:GetHumanoidDescriptionFromUserId(player.UserId)
			humanoidDescription.HeadScale = 0.7
			humanoidDescription.DepthScale = 0.5
			humanoidDescription.WidthScale = 0.5
			humanoidDescription.HeightScale = 0.5
			character.Humanoid:ApplyDescription(humanoidDescription)
		end)

		GameManager.AssignFarmToPlayer(player)
		GameManager.PlayerData:Load(player.UserId)

		local data = GameManager.PlayerData.Data[player.UserId]
		GameManager.SetupFarmForPlayer(player)
	end)

	Players.PlayerRemoving:Connect(function(player: Player)
		GameManager.PlayerData:Save(player.UserId)
		GameManager.PlayerData:Unload(player.UserId)

		for i = 1, #GameManager.Grid do
			local gridPoint = GameManager.Grid[i]
			if gridPoint.Owner == player then
				gridPoint.Owner = nil
				break
			end
		end

		if workspace.Maps:FindFirstChild(player.Name) then
			workspace.Maps[player.Name]:Destroy()
		end
	end)
end

return PlayerManager