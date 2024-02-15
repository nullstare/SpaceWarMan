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

function Entities:processTable( t, delta )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.process ~= nil then
			obj:process( delta )
		end
	end
end

function Entities:processPhysicsTable( t, delta, step )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.physicsProcess ~= nil then
			obj:physicsProcess( delta, step )
		end
	end
end

function Entities:process( delta )
	self:processTable( self.enemies, delta )
	self:processTable( self.emitters, delta )
	self:processTable( self.pickups, delta )
end

function Entities:physicsProcess( delta, step )
	self:processPhysicsTable( self.bullets, delta, step )
	self:processPhysicsTable( self.enemies, delta, step )
	self:processPhysicsTable( self.pickups, delta, step )
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
