ParticleEmitters = {}
ParticleEmitters.__index = ParticleEmitters

ParticleEmitters.FREE = 0

require( "scripts/particle_emitter" )

function ParticleEmitters:new()
	local object = setmetatable( {}, self )

	object.emitters = {}

    return object
end

function ParticleEmitters:add( emitter )
	emitter.id = 1

	for i, e in ipairs( self.emitters ) do
		-- Put emitter to free slot.
		if e == self.FREE then
			self.emitters[i] = emitter
			return
		end

		emitter.id = emitter.id + 1
	end
	-- Add new emitter.
	table.insert( self.emitters, emitter )
end

function ParticleEmitters:process( delta )
	for i, emitter in ipairs( self.emitters ) do
		if emitter ~= self.FREE and emitter.process ~= nil then
			emitter:process( delta )
		end
	end
end

function ParticleEmitters:draw()
	for _, emitter in ipairs( self.emitters ) do
		if emitter ~= self.FREE and emitter.draw ~= nil then
			emitter:draw()
		end
	end
end

ParticleEmitters = ParticleEmitters:new()
