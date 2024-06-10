--!nocheck

local Watchdog = require(script.Parent)

return function()
	describe("Watchdog.new()", function()
		local watchdog 

		beforeEach(function()
			watchdog = Watchdog.new()
		end)

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
			local count = 0
			watchdog:ObserveOnce(function()
				count += 1
			end)

			watchdog:Bark()
			watchdog:Bark()
			watchdog:Bark()

			expect(count).to.equal(1)
		end)

		it("should scare subjects off with acidic saliva", function()
			local salivaContents: { any }

			watchdog:Observe(function(...: any)
				salivaContents = { ... }
			end)

			watchdog:Bark("Hey", "You", "Stink", 9000, false)

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

		it("shouldn't bark while sleeping", function()
			local sleepCount = 0
			watchdog:Observe(function()
				sleepCount += 1
			end) 

			watchdog:Bark()
			watchdog:Sleep()
			watchdog:Bark()

			expect(sleepCount).to.equal(1)
		end)
	end)
end
