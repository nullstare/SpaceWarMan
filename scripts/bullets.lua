Bullets = {}
Bullets.__index = Bullets

Bullets.FREE = 0
Bullets.HIT = {
	ENEMIES = 0,
	PLAYER = 1,
}

require( "scripts/bullet" )

function Bullets:new()
	local object = setmetatable( {}, self )

	object.bullets = {}

    return object
end

function Bullets:add( bullet )
	bullet.id = 1

	for i, b in ipairs( self.bullets ) do
		-- Put bullet to free slot.
		if b == self.FREE then
			self.bullets[i] = bullet
			return
		end

		bullet.id = bullet.id + 1
	end
	-- Add new bullet.
	table.insert( self.bullets, bullet )
end

function Bullets:process( delta )
	for i, bullet in ipairs( self.bullets ) do
		if bullet ~= self.FREE and bullet.process ~= nil then
			bullet:process( delta )
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
