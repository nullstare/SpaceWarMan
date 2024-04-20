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

function Particle:update( delta )
	self.position = self.position + self.velocity:scale( delta )
	self.velocity = self.velocity + self.deltaVel:scale( delta )
	self.lifetime = self.lifetime - delta
end

function Particle:draw()
	RL.DrawTexturePro(
		self.texture,
		self.source,
		Rect:temp( self.position.x, self.position.y, self.source.width, self.source.height ),
		Vec2:temp( self.source.width / 2, self.source.height / 2 ),
		0.0,
		self.tint
	)
end
