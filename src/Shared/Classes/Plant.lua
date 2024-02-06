local Plant = {}
Plant.__index = {}

local Event = require(script.Parent.Event)

export type PlantData = {
    Name: string,
    GrowthTime: number?,
    Yield: number?,
    Stages: number?,
    Models: { [number]: Model }?,
}

export type Plant = {} & PlantData & typeof(Plant)

function Plant.new(data: PlantData)
    local self = setmetatable({}, Plant)

    self.Name = data.Name
    self.GrowthTime = data.GrowthTime or 5
    self.Yield = data.Yield or 1
    self.Stages = data.Stages or 1
    self.Stage = 1
    self.Models = data.Models

    self.Model = self.Models[self.Stage]

    self.CanBeHarvested = false

    self.OnGrowth = Event.new()

    self._elapsedTime = 0

    return self
end

function Plant:Update(deltaTime: number)
    if self.Stage >= self.Stages then
        self.Stage = self.Stages
        self.CanBeHarvested = true
        return
    end
    local timeBetweenGrowth = self.GrowthTime / self.Stages

    self._elapsedTime += deltaTime
    if self._elapsedTime >= timeBetweenGrowth then
        self._elapsedTime = 0
        self:Grow()
    end
end

function Plant:Grow()
    if self.Stage >= self.Stages then
        return
    end

    self.Stage += 1

    if self.Stage == self.Stages then
        self.CanBeHarvested = true
    end

    self.OnGrowth:Fire(self.Stage)
end

return Plant