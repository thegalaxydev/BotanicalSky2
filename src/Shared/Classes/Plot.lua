local Plot = {}
Plot.__index = Plot

local Plant = require(script.Parent.Plant)
type Plant = Plant.Plant

export type Plot = {
	Plant: Plant?,
	Position: number
} & typeof(Plot)

function Plot.new(plant: Plant?, position: number)
	local self = setmetatable({}, Plot)

	self.Plant = plant
	self.Position = position

	return self
end

function Plot:PlantSeed(plant: Plant)
	if self.Plant then return end

	self.Plant = plant
	plant.Stage = 1
end

function Plot:Harvest()
	if not self.Plant then return end
	if not self.Plant.CanBeHarvested then return end

	-- get yield
	local yield = self.Plant.Yield

	self.Plant.OnGrowth:DisconnectAll()
	self.Plant = nil
	
end

return Plot