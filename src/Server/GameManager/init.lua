local GameManager = {}
local DataService = require(script.Parent.DataService)

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Assets = ReplicatedStorage.Assets
local Prefabs = Assets.Prefabs

local Services = ReplicatedStorage.Shared.Services
local Classes = ReplicatedStorage.Shared.Classes
local Network = require(Services.NetworkService)

local Plot = require(Classes.Plot)
local Plant = require(Classes.Plant)
local Plants = Classes.Plants

-- Remotes
local PlotSetupForPlayer = Network.BridgeNet2.ReferenceBridge("PlotSetupForPlayer")

GameManager.PLAYER_DATA_KEY = 5

GameManager.PlayerData = DataService.CreateDataStoreInstance({
	Name = "PlayerData"..GameManager.PLAYER_DATA_KEY,
	AutoSaveInterval = 60,
	ShouldAutoSave = true,

	DefaultData = {
		FarmSize = 2,

		Farm = {"TestPlant"}
	},
})

GameManager.Settings = {
	FarmSpawnPosition = Vector3.new(0, 0, 0),
	GridSpace = 5,
	GridSize = Vector3.new(100,1,100),
	GridCount = 16,
}

GameManager.Grid = {}

function GenerateGridPoints(gridSize: Vector3, centerPosition: Vector3, spacer: number, gridSide: number)
    local totalWidth = (gridSize.X * gridSide) + (spacer * (gridSide - 1))
    local totalHeight = (gridSize.Z * gridSide) + (spacer * (gridSide - 1))

    local startX = centerPosition.X - (totalWidth / 2) + (gridSize.X / 2)
    local startZ = centerPosition.Z - (totalHeight / 2) + (gridSize.Z / 2)
    
	local gridPoints = {}

    for x = 1, gridSide do
        for z = 1, gridSide do
            local partPosition = Vector3.new(
                startX + (x - 1) * (gridSize.X + spacer),
                centerPosition.Y,
                startZ + (z - 1) * (gridSize.Z + spacer)
            )
            
			gridPoints[#gridPoints + 1] = partPosition
        end
    end

	return gridPoints
end

function GameManager.AssignFarmToPlayer(player: Player)
	local playerData = GameManager.PlayerData:GetData(player.UserId)

	for i = 1, #GameManager.Grid do
		local gridPoint = GameManager.Grid[i]
		if gridPoint.Owner then continue end

		gridPoint.Owner = player

		break
	end
end

function GameManager.SetupFarmForPlayer(player: Player)
	local gridPoint

	for _, point in GameManager.Grid do
		if point.Owner == player then
			gridPoint = point
			break
		end
	end

	assert(gridPoint, "Tried to setup a farm before it was assigned.")

	local test = Prefabs.Test:Clone()
	test.Parent = workspace.Maps
	test.Name = player.Name
	test:PivotTo(CFrame.new(gridPoint.Position))

	local character = player.Character or player.CharacterAdded:Wait()
	character.HumanoidRootPart.CFrame = test:GetPivot() + Vector3.new(0, 3, 0)

	local playerData = GameManager.PlayerData:GetData(player.UserId)
	local plotGrid = GenerateGridPoints(Vector3.new(4,0.5,4), gridPoint.Position + Vector3.new(0,0.5,0), 0, playerData.FarmSize or 3)

    local farm = script.Farm:Clone()
    farm.Parent = player
    farm = require(farm)

	for i = 1, #plotGrid do
		local part = Assets.Plot:Clone()
		part.Size = Vector3.new(4,0.5,4)
		part.Anchored = true
		part.Position = plotGrid[i]
		part.Name = i
		part.Parent = test.Farm

		local farmData = playerData.Farm[i]
        local plantModule = nil
		if farmData then
			plantModule = Plants:FindFirstChild(farmData)
		end
        local plant = nil
        if plantModule then
            plant = Plant.new(require(plantModule))
        end
        farm.Plots[i] = Plot.new(plant, i)
	end


    print(farm)

	PlotSetupForPlayer:Fire(player)
end

function GameManager.Init()
	local grid = GenerateGridPoints(
		GameManager.Settings.GridSize,
		GameManager.Settings.FarmSpawnPosition,
		GameManager.Settings.GridSpace,
		math.round(math.sqrt(GameManager.Settings.GridCount))
	)

	for index, position in grid do
		table.insert(GameManager.Grid, {
			Position = position
		})
	end
end

return GameManager
