-- -------------------------
-- Author: SouD
-- Date: 04/11/2012
-- Version: 1.0
-- -------------------------

-- Using setmetatable with __call to cache 
-- CombatLogClearEntries for performance.
local CLF = setmetatable({
	version = "1.0",
	utime = 10.0,
	inCombat = false,
}, {
	__call = function(self)
		CombatLogClearEntries()
	end
})

local CLF_DB_defaults = {
	options = {
		utime = "10.0"
	}
}

local hook = CreateFrame("Frame")

-- Note: Possible bug with zoning, needs investigation ingame.

local events = {}
function events:PLAYER_ENTERING_WORLD(...)
	CLF()
end

function events:PLAYER_REGEN_DISABLED(...)
	CLF.inCombat = true
	CLF()
end

function events:PLAYER_REGEN_ENABLED(...)
	CLF.inCombat = false
end

function events:PLAYER_DEAD(...)
	CLF.inCombat = false
	CLF()
end

function events:ADDON_LOADED(...)
	args = {...}
	if ( args[1] == "CLF" ) then
		if ( not CLF_DB ) then
			CLF_DB = CLF_DB_defaults.options
		else
			CLF.utime = tonumber(CLF_DB.utime)
		end
		hook:UnregisterEvent("ADDON_LOADED")
	end
end

function events:PLAYER_LOGOUT(...)
	CLF_DB.utime = tostring(CLF.utime)
end

local lastUpdate
local function init()
	-- Hook events to handler
	hook:SetScript("OnEvent", function(self, event, ...)
		events[event](self, ...)
	end)
	
	-- Setup OnUpdate
	lastUpdate = 0
	hook:SetScript("OnUpdate", function(self, elapsed)
		lastUpdate = lastUpdate + elapsed
		
		if ( lastUpdate > CLF.utime ) then
			if ( CLF.inCombat ) then
				CLF()
			end
			
			lastUpdate = 0
		end
	end)
	
	-- Register events
	for k, v in pairs(events) do
		hook:RegisterEvent(k)
	end
	
	-- Register for slash commands
	-- /clf [number] - Sets OnUpdate interval
	SLASH_CLF1 = "/clf"
	SLASH_CLF2 = "/CLF"
	SlashCmdList["CLF"] = function(msg, editbox)
		if ( msg ~= "" ) then
			local val = tonumber(msg)
			if (val and val >= 0.0) then
				CLF.utime = val
				DEFAULT_CHAT_FRAME:AddMessage("|cff55aaeeCLF|r: Timer set to: " .. val)
			else
				DEFAULT_CHAT_FRAME:AddMessage("|cff55aaeeCLF|r: Failed explicit cast string to number or number was signed.")
			end
		else
			DEFAULT_CHAT_FRAME:AddMessage("|cff55aaeeCLF|r: Usage: /clf number -- Set the timer interval to number.")
		end
	end
end

--Start it!
init()
