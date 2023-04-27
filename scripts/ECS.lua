ECS = {}
ECS.__index = ECS

ECS.FREE = 0
ECS.HIT = {
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

function ECS:new()
	local object = setmetatable( {}, self )

	object.bullets = {}
	object.enemies = {}
	object.emitters = {} -- Particle emitters.
	object.pickups = {}

    return object
end

function ECS:add( t, obj )
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

function ECS:clear()
	self.bullets = {}
	self.enemies = {}
	self.emitters = {}
	self.pickups = {}
end

function ECS:processTable( t, delta )
	for i, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.process ~= nil then
			obj:process( delta )
		end
	end
end

function ECS:processPhysicsTable( t, delta, step )
	for i, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.physicsProcess ~= nil then
			obj:physicsProcess( delta, step )
		end
	end
end

function ECS:process( delta )
	self:processTable( self.enemies, delta )
	self:processTable( self.emitters, delta )
	self:processTable( self.pickups, delta )
end

function ECS:physicsProcess( delta, step )
	self:processPhysicsTable( self.bullets, delta, step )
	self:processPhysicsTable( self.enemies, delta, step )
	self:processPhysicsTable( self.pickups, delta, step )
end

function ECS:drawTable( t )
	for _, obj in ipairs( t ) do
		if obj ~= self.FREE and obj.draw ~= nil then
			obj:draw()
		end
	end
end

function ECS:draw()
	self:drawTable( self.enemies )
	self:drawTable( self.pickups )
	self:drawTable( self.bullets )
	self:drawTable( self.emitters )
end

ECS = ECS:new()
