Pickups = {}
Pickups.__index = Pickups

Pickups.FREE = 0

require( "scripts/health" )

function Pickups:new()
	local object = setmetatable( {}, self )

	object.pickups = {}

    return object
end

function Pickups:add( pickup )
	pickup.id = 1

	for i, b in ipairs( self.pickups ) do
		-- Put pickup to free slot.
		if b == self.FREE then
			self.pickups[i] = pickup
			return
		end

		pickup.id = pickup.id + 1
	end
	-- Add new pickup.
	table.insert( self.pickups, pickup )
end

function Pickups:process( delta )
	for i, pickup in ipairs( self.pickups ) do
		if pickup ~= self.FREE and pickup.process ~= nil then
			pickup:process( delta )
		end
	end
end

function Pickups:draw()
	for _, pickup in ipairs( self.pickups ) do
		if pickup ~= self.FREE and pickup.draw ~= nil then
			pickup:draw()
		end
	end
end

Pickups = Pickups:new()
