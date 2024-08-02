return function()
	local Watchdog = require(script.Parent)

	local watchdog = Watchdog.new()

	it("should observe subjects", function()
		local MAX_SUBJECTS = 5
		local numberOfSubjectsBeingObserved = 0

		for _ = 1, MAX_SUBJECTS do
			watchdog:Observe(function()
				numberOfSubjectsBeingObserved += 1
			end)
		end

		watchdog:Bark()

		expect(numberOfSubjectsBeingObserved).to.equal(MAX_SUBJECTS)
	end)

	it("should observe a subject only once", function()
		local observeCount = 0
		watchdog:ObserveOnce(function()
			observeCount += 1
		end)

		watchdog:Bark()
		watchdog:Bark()
		watchdog:Bark()

		expect(observeCount).to.equal(1)
	end)

	it("should stop observing a subject", function() 
		local hasStoppedObserving = false

		local stopObserving
		stopObserving = watchdog:Observe(function() 
			if hasStoppedObserving then
				return
			end

			hasStoppedObserving = true

			stopObserving()
		end) 

		expect(stopObserving).to.be.ok()
		expect(stopObserving).to.be.a("function")
		
		watchdog:Bark()
		
		expect(hasStoppedObserving).to.equal(true)
	end)

	it("should scare subjects off with acidic saliva", function()
		local salivaContents: { any }

		watchdog:Observe(function(...: any)
			salivaContents = { ... }
		end)

		watchdog:Bark("Hey", "You", "Stink", 9000, false)

		expect(salivaContents).to.be.ok()
		expect(salivaContents).to.be.a("table")

		expect(salivaContents[1]).to.equal("Hey")
		expect(salivaContents[2]).to.equal("You")
		expect(salivaContents[3]).to.equal("Stink")
		expect(salivaContents[4]).to.equal(9000)
		expect(salivaContents[5]).to.equal(false)
	end)

	it("shouldn't bark at non-subjects", function()
		local wasGuyAScared = false
		local wasGirlBScared = false
		local wasBabyCScared = false

		watchdog:Observe(function()
			wasGuyAScared = true
		end)

		watchdog:Observe(function()
			wasGirlBScared = true
		end)()

		watchdog:ObserveOnce(function()
			wasBabyCScared = true
		end)()

		watchdog:Bark()

		expect(wasGuyAScared).to.equal(true)
		expect(wasGirlBScared).to.equal(false)
		expect(wasBabyCScared).to.equal(false)
	end)

	it("shouldn't bark after being destroyed", function()
		local isDestroyed = false
		watchdog:Observe(function()
			if isDestroyed then
				return
			end

			isDestroyed = true
		end)

		watchdog:Bark()
		watchdog:Destroy()
		watchdog:Bark()

		expect(isDestroyed).to.equal(true)
	end)
end
