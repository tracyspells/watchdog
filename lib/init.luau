type Callback = (...any) -> ()

type Entity = {
	getScared: Callback,
	getsScaredOnce: boolean?,
}

type Set<T> = { [T]: boolean }

type Entities = Set<Entity>

export type Watchdog = {
	Observe: (self: Watchdog, entity: Callback) -> Callback,
	ObserveOnce: (self: Watchdog, entity: Callback) -> Callback,
	Bark: (self: Watchdog, ...any) -> (),
	Destroy: (self: Watchdog) -> (),
}

local Watchdog = {}

function Watchdog.new(): Watchdog
	local entitiesToObserve: Entities = {}

	local watchdog = {}
	function watchdog:Observe(callback)
		local observing = true
		local entity = { getScared = callback }

		entitiesToObserve[entity] = true

		return function()
			if not observing then
				return
			end

			observing = false
			entitiesToObserve[entity] = nil
		end
	end

	function watchdog:ObserveOnce(callback)
		local entity = { getScared = callback, getsScaredOnce = true }
		local observing = true

		entitiesToObserve[entity] = true

		return function()
			if not observing then
				return
			end

			observing = false
			entitiesToObserve[entity] = nil
		end
	end

	function watchdog:Bark(...: any)
		for entity in entitiesToObserve do
			task.spawn(entity.getScared, ...)

			if entity.getsScaredOnce then
				entitiesToObserve[entity] = nil

				continue
			end
		end
	end

	function watchdog:Destroy()
		for entity in entitiesToObserve do
			entitiesToObserve[entity] = nil
		end
	end

	return watchdog :: any
end

return Watchdog
