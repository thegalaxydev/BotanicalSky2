-- thegalaxydev

-- Usual import stuff
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local ContextActionService = game:GetService("ContextActionService")
local UserInputService = game:GetService("UserInputService")
local Shared = ReplicatedStorage.Shared

local Classes = Shared.Classes
local Event = require(Classes.Event)
-----------------------


local Player = Players.LocalPlayer
local Controls = {}


type Control = {
	Keys: {Enum.KeyCode},
	Action: (name: string, state: Enum.UserInputState, input: InputObject) -> nil,
	TouchButton: boolean?,
}

Controls.Controls = {
	--[[
	["Example"] = {
		["Keys"] = {Enum.KeyCode.LeftShift},
		["Action"] = function(self, _, state, input)

		end,
		["TouchButton"] = true;
	};
	]]

	
} :: {[string]: Control}

local events = {}

Controls.OnControlActivated = function(name: string)
	if events[name] then
		return events[name]
	end

	warn("Connection for control named \""..name.."\" does not exist.")
end

Controls.Loaded = false
Controls.OnLoad = Event.new()

function Controls.Init()
	for name, control : Control in Controls.Controls do
		ContextActionService:UnbindAction(name)
		if events[name] then
			events[name]:DisconnectAll()
		end
		events[name] = Event.new()
		ContextActionService:BindAction(name, function(bind, state, input)
			events[name]:Fire(input.KeyCode or input.UserInputType, state)
			control:Action(name, state, input)
		end, control.TouchButton or false, unpack(control.Keys))
	end
	
	Controls.Loaded = true
	Controls.OnLoad:Fire()
end


return Controls