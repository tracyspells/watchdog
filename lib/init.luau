type Callback = (...any?) -> ()
type Entity = {
	getScared: Callback,
	getsScaredOnce: boolean?,
}

type ObserveTable = { [Entity]: Callback }

type ValueObject = {
	Value: any,
	Changed: RBXScriptSignal<any>,
}

type WatchdogObject = {
	Observe: (self: WatchdogObject, subject: Callback) -> Callback?,
	ObserveOnce: (self: WatchdogObject, subject: Callback) -> Callback?,
	Bark: (self: WatchdogObject, ...any) -> (),
	Sleep: (self: WatchdogObject) -> (),
}

export type Watchdog = {
	new: () -> WatchdogObject,
	fromValueObject: (valueObject: ValueObject, subject: Callback) -> Callback,
}


local function new()
	local observing: ObserveTable = {}
	local isSleeping = false

	local function observe(subject: Callback, observeOnce: boolean?)
		local entity = {
			getScared = subject,
			getsScaredOnce = observeOnce,
		}

		local function stopObserving()
			observing[entity] = nil
		end

		observing[entity] = stopObserving

		return stopObserving
	end

	local watchdog = {}
	function watchdog:Observe(subject: Callback)
		if isSleeping then
			return
		end

		return observe(subject)
	end

	function watchdog:ObserveOnce(subject: Callback)
		if isSleeping then
			return
		end

		return observe(subject, true)
	end

	function watchdog:Bark(...: any)
		if isSleeping then
			return
		end

		for entity, stopObserving in observing do
			task.spawn(entity.getScared, ...)

			if entity.getsScaredOnce then
				stopObserving()
			end
		end
	end

	function watchdog:Sleep()
		if isSleeping then
			return
		end

		for _, stopObserving in observing do
			stopObserving()
		end

		observing = {}
		isSleeping = true
	end

	return watchdog
end

local function fromValueObject(valueObject: ValueObject, subject: Callback)
	local connection: RBXScriptConnection
	local watchdog = new()
	
	local function stopObserving()
		connection:Disconnect()
		watchdog:Sleep()
	end

	watchdog:Observe(subject)
	watchdog:Bark(valueObject.Value)

	connection = valueObject.Changed:Connect(function(newValue)
		watchdog:Bark(newValue)
	end)

	return stopObserving 
end



return table.freeze {
	new = new,

	fromValueObject = fromValueObject,
} :: Watchdog
