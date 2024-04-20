Entities = {}
Entities.__index = Entities

Entities.FREE = 0
Entities.HIT = {
	ENEMIES = 0,
	PLAYER = 1,
}

-- Bullets.
require( "scripts/bullet" )
-- Enemies.
require( "scripts/droid" )
-- Particles.
require( "scripts/particle_emitter" )
-- Pickups.
require( "scripts/health" )
require( "scripts/energy_tank" )
require( "scripts/double_jump" )

function Entities:new()
	local object = setmetatable( {}, self )

	object.bullets = {}
	object.enemies = {}
	object.emitters = {} -- Particle emitters.
	object.pickups = {}

    return object
end

function Entities:add( t, obj )
	obj.id = 1

	for i, b in ipairs( t ) do
		-- Put object to free slot.
		if b == self.FREE then
			t[i] = obj
			return
		end

		obj.id = obj.id + 1
	end
	-- Add new object.
	table.insert( t, obj )
end

function Entities:clear()
	self.bullets = {}
	self.enemies = {}
	self.emitters = {}
	self.pickups = {}
end

function Entities:updateTable( t, delta )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.update ~= nil then
			obj:update( delta )
		end
	end
end

function Entities:updatePhysicsTable( t, delta, step )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.physicsUpdate ~= nil then
			obj:physicsUpdate( delta, step )
		end
	end
end

function Entities:update( delta )
	self:updateTable( self.enemies, delta )
	self:updateTable( self.emitters, delta )
	self:updateTable( self.pickups, delta )
end

function Entities:physicsUpdate( delta, step )
	self:updatePhysicsTable( self.bullets, delta, step )
	self:updatePhysicsTable( self.enemies, delta, step )
	self:updatePhysicsTable( self.pickups, delta, step )
end

function Entities:drawTable( t )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.draw ~= nil then
			obj:draw()
		end
	end
end

function Entities:draw()
	self:drawTable( self.enemies )
	self:drawTable( self.pickups )
	self:drawTable( self.bullets )
	self:drawTable( self.emitters )
end

Entities = Entities:new()
