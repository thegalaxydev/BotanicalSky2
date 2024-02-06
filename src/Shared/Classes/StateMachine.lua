-- thegalaxydev

local StateMachine = {}
StateMachine.__index = StateMachine

-- dependencies
local Event = require(script.Parent.Event)
type Event = Event.Event

type State = {
	Name: string,
	Start: ((previousState: string?) -> nil)?,
	Step: (() -> State?)?,
	Finish: (() -> nil)?,
}

type MachineSettings = {
	defaultState: string?,
	debugMode: boolean?,
}

export type StateMachine = {
	Step: () -> nil,
	OnStateChanged: Event,
	ForceState: (self: StateMachine, state: string) -> nil,
}

function StateMachine.new(machine)
	local self = setmetatable({}, StateMachine)

	self.states = {}
	for _, state in machine.States do
		self.states[state.Name] = state
	end
	self.debugMode = machine.Settings and machine.Settings.debugMode or false

	self.forceStateCache = nil
	self.startStateCache = nil

	local defaultState = nil
	if machine.Settings and machine.Settings.defaultState then
		defaultState = machine.Settings.defaultState
	end

	self.currentState = defaultState or machine.States[1].Name
	self.previousState = nil

	if self.states[self.currentState].Start then
		self.states[self.currentState].Start()
	end

	self.OnStateChanged = Event.new()

	return self
end

function StateMachine:Step(dt)
	local oldState = self.currentState
	local newState

	local forced = false
	if self.startStateCache then
		newState = self.startStateCache
		self.startStateCache = nil
	elseif self.forceStateCache then
		newState = self.forceStateCache
		if self.debugMode then
			warn("State changed from " .. oldState .. " to " .. newState .. " (forced).")
		end
		self.forceStateCache = nil

		forced = true
	elseif self.states[self.currentState].Step then
		newState = self.states[self.currentState].Step(dt)
	end

	if newState and newState ~= oldState then
		self.previousState = oldState
		self.currentState = newState

		self.OnStateChanged:Fire(self.currentState, self.previousState)

		if self.debugMode and not forced then
			warn("State changed from " .. oldState .. " to " .. newState)
		end

		if self.states[oldState].Finish then
			self.states[oldState].Finish()
		end

		if self.states[self.currentState].Start then
			self.startStateCache = self.states[self.currentState].Start(oldState)
		end
	end
end

function StateMachine:ForceState(state: string)
	self.forceStateCache = state
end

return StateMachine