-- thegalaxydev

local Event = {}
Event.__index = Event
Event.__class = "Event"

export type Event = {
	Callbacks : {};
	Waiting : {};
	Connect : (Event, func : () -> nil) -> Connection,
	Fire : (Event, ...any) -> nil,
	Wait : (Event) -> any
}
export type Connection = {
	Connected : boolean,
	Disconnect: () -> nil
}

function Event.new() : Event
	local self = setmetatable({}, Event)
	self.Callbacks = {}
	self.Waiting = {}

	return self
end

function Event:Connect(func: (any)->any) : Connection?
	local connection = {}
	connection.Connected = true

	function connection:Disconnect()
		self.Callbacks[func] = nil
		connection.Connected = false
	end
	
	self.Callbacks[func] = newproxy()

	return connection
end

function Event:Once(func: (any)->any) : Connection?
	local connection
	local called = false
	connection.Connected = true

	connection = self:Connect(function(...)
		if not called then
			called = true
			connection:Disconnect()
			func(...)
		end
	end)

	return connection
end

function Event:Fire(...:any)
	for func in pairs(self.Callbacks) do
		coroutine.wrap(func)(...)
	end

	for _, thread in pairs(self.Waiting) do
		table.remove(self.Waiting, thread)
		coroutine.resume(thread , ...)
	end
end

function Event:DisconnectAll()
	for func in pairs(self.Callbacks) do
		self.Callbacks[func] = nil
	end
end

function Event:Wait(timeout: number?)
	local thread = coroutine.running()
	table.insert(self.Waiting, thread)

	if timeout then
		task.delay(timeout, function()
			if coroutine.status(thread) == "suspended" then
				table.remove(self.Waiting, thread)
				coroutine.resume(thread)
			end
		end)
	end

	return coroutine.yield()
end

return Event