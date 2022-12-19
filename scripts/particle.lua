Particle = {}
Particle.__index = Particle

function Particle:new( pos, vel, deltaVel, lifetime, texture, source, tint )
	local object = setmetatable( {}, self )

	object.position = pos
	object.velocity = vel
	object.deltaVel = deltaVel
	object.lifetime = lifetime
	object.texture = texture
	object.source = source
	object.tint = tint

    return object
end

function Particle:process( delta )
	self.position = self.position + self.velocity:scale( delta )
	self.velocity = self.velocity + self.deltaVel:scale( delta )
	self.lifetime = self.lifetime - delta

	-- print( self.lifetime )
end

function Particle:draw()
	RL_DrawTexturePro(
		self.texture,
		self.source,
		Rect:new( self.position.x, self.position.y, self.source.width, self.source.height ),
		Vec2:new( self.source.width / 2, self.source.height / 2 ),
		0.0,
		self.tint
	)
end