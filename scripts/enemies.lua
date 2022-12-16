Enemies = {}
Enemies.__index = Enemies

Enemies.FREE = 0

require( "scripts/droid" )

function Enemies:new()
	local object = setmetatable( {}, self )

	object.enemies = {}

    return object
end

function Enemies:add( enemy )
	enemy.id = 1

	for i, b in ipairs( self.enemies ) do
		-- Put enemy to free slot.
		if b == self.FREE then
			self.enemies[i] = enemy
			return
		end

		enemy.id = enemy.id + 1
	end
	-- Add new enemy.
	table.insert( self.enemies, enemy )
end

function Enemies:process( delta )
	for i, enemy in ipairs( self.enemies ) do
		if enemy ~= self.FREE and enemy.process ~= nil then
			enemy:process( delta )
		end
	end
end

function Enemies:draw()
	for _, enemy in ipairs( self.enemies ) do
		if enemy ~= self.FREE and enemy.draw ~= nil then
			enemy:draw()
		end
	end
end

Enemies = Enemies:new()
