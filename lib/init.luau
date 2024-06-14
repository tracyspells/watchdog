type Callback = (...any?) -> ()

type Entity = {
	getScared: Callback,
	getsScaredOnce: boolean?,
}

type ObserveTable = { [Entity]: Callback }

type WatchdogObject = {
	Observe: (self: WatchdogObject, subject: Callback) -> Callback,
	ObserveOnce: (self: WatchdogObject, subject: Callback) -> Callback,
	Bark: (self: WatchdogObject, ...any) -> (),
	Sleep: (self: WatchdogObject) -> (),
}

export type Watchdog = {
	new: () -> WatchdogObject,
}

local Watchdog = {}

function Watchdog.new(): WatchdogObject
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

	return watchdog :: any
end

return Watchdog
