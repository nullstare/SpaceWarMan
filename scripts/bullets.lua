Bullets = {}
Bullets.__index = Bullets

function Bullets:new()
	local object = setmetatable( {}, self )

	object.FREE = 0

	object.bullets = {}

    return object
end

function Bullets:add( bullet )
	for i, b in ipairs( self.bullets ) do
		-- Put bullet to free slot.
		if b == self.FREE then
			self.bullets[i] = bullet
			return
		end
	end
	-- Add new bullet.
	table.insert( self.bullets, bullet )
end

function Bullets:process( delta )
	for i, bullet in ipairs( self.bullets ) do
		if bullet ~= self.FREE and bullet.process ~= nil then
			if not bullet:process( delta ) then
				-- bullet = self.FREE
				self.bullets[i] = self.FREE
			end
		end
	end
end

function Bullets:draw()
	for _, bullet in ipairs( self.bullets ) do
		if bullet ~= self.FREE and bullet.draw ~= nil then
			bullet:draw()
		end
	end
end

Bullets = Bullets:new()
