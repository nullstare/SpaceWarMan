ParticleEmitter = {}
ParticleEmitter.__index = ParticleEmitter

ParticleEmitter.FREE = 0

require( "scripts/particle" )

function ParticleEmitter:new( position, texture, source, tint, emit )
	local object = setmetatable( {}, self )

	object.particles = {}
	object.position = position
	object.texture = texture
	object.source = source
	object.tint = tint

	object.emitCount = emit.count
	object.emitInterval = emit.interval
	object.emitPos = emit.pos
	object.emitVel = emit.vel -- Initial velocity.
	object.emitDeltaVel = emit.deltaVel -- Velocity change over time.
	object.emitRot = emit.rot -- Initila rotation,
	object.emitDeltaRot = emit.deltaRot	-- Rotation over time.
	object.emitLifetime = emit.lifetime

	object.emitted = 0 -- Count of emitted particles.
	object.timer = 0
	object.emitTime = 0 -- Time when last particle was emitted.

    return object
end

function ParticleEmitter:add( particle )
	-- particle.id = 1

	-- for i, b in ipairs( self.particles ) do
	-- 	-- Put particle to free slot.
	-- 	if b == self.FREE then
	-- 		self.ParticleEmitter[i] = particle
	-- 		return
	-- 	end

	-- 	particle.id = particle.id + 1
	-- end
	-- Add new particle.
	table.insert( self.particles, particle )
end

function ParticleEmitter:process( delta )
	local hasParticlesLeft = false

	for i, particle in ipairs( self.particles ) do
		if 0 < particle.lifetime then
			particle:process( delta )
			hasParticlesLeft = true
		end
	end

	if not hasParticlesLeft and self.emitCount <= self.emitted then
		self:destroy()
		return
	end

	-- Check emitting.

	while self.emitted < self.emitCount and self.emitTime <= self.timer do
		self:add( Particle:new(
			self.position + Vec2:new(
				util.randomFloat( self.emitPos.min.x, self.emitPos.max.x ),
				util.randomFloat( self.emitPos.min.y, self.emitPos.max.y )
			),
			Vec2:new(
				util.randomFloat( self.emitVel.min.x, self.emitVel.max.x ),
				util.randomFloat( self.emitVel.min.y, self.emitVel.max.y )
			),
			Vec2:new(
				util.randomFloat( self.emitDeltaVel.min.x, self.emitDeltaVel.max.x ),
				util.randomFloat( self.emitDeltaVel.min.y, self.emitDeltaVel.max.y )
			),
			util.randomFloat( self.emitLifetime.min, self.emitLifetime.max ),
			self.texture,
			self.source:clone(),
			self.tint
		) )
		self.emitTime = self.emitTime + self.emitInterval
		self.emitted = self.emitted + 1
	end

	self.timer = self.timer + delta
end

function ParticleEmitter:destroy()
	ParticleEmitters.emitters[ self.id ] = ParticleEmitters.FREE
end

function ParticleEmitter:draw()
	for _, particle in ipairs( self.particles ) do
		if 0 < particle.lifetime then
			particle:draw()
		end
		-- if particle ~= self.FREE and particle.draw ~= nil then
			-- particle:draw()
		-- end
	end
end
