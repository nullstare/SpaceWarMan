Bullet = {}
Bullet.__index = Bullet

function Bullet:new( pos, vel, tex, source, origin, range )
	local object = setmetatable( {}, self )

	object.id = 1
	object.position = pos
	object.velocity = vel
	object.sprite = Sprite:new( Resources.textures.effects, source, Rect:new( pos.x, pos.y, source.width, source.height ), origin, 0.0, WHITE )
	object.range = range
	object.colRect = Rect:new( pos.x + 1, pos.y + 1, source.width - 2, source.height - 2 )
	object.damage = 1
	object.hit = Objects.HIT.ENEMIES

    return object
end

function Bullet:destroy()
	Objects.bullets[ self.id ] = Objects.FREE
end

function Bullet:spawnParticles( source )
	Objects:add( Objects.emitters, ParticleEmitter:new(
		self.position:clone(),
		Resources.textures.effects,
		source,
		WHITE,
		{ -- Emit.
			count = 4,
			interval = 0.03,
			pos = { min = Vec2:new( -2, -2 ), max = Vec2:new( 2, 2 ) },
			vel = { min = Vec2:new( -self.velocity.x * 0.1, -30 ), max = Vec2:new( -self.velocity.x * 0.2, 30 ) },
			deltaVel = { min = Vec2:new( 0, 80 ), max = Vec2:new( 0, 100 ) },
			lifetime = { min = 0.1, max = 0.4 },
		}
	) )
end

function Bullet:physicsProcess( delta )
	local range = self.velocity:scale( delta )

	self.position = self.position + range
	self.colRect.x = self.position.x - self.colRect.width / 2 + 1
	self.colRect.y = self.position.y - self.colRect.height / 2 + 1
	self.range = self.range - range:length()

	if self.range <= 0.0 then
		self:destroy()
	elseif Room:ifBulletCollide( self ) then
		self:destroy()
		self:spawnParticles( Rect:new( 3, 2, 1, 1 ) )
	elseif self.hit == Objects.HIT.ENEMIES then
		for _, enemy in ipairs( Objects.enemies ) do
			if enemy ~= Objects.FREE and RL_CheckCollisionRecs( self.colRect, enemy.colRect ) then
				self:destroy()
				enemy:takeDamage( self.damage )
				RL_SetSoundPitch( Resources.sounds.hit, 0.7 + math.random() * 0.4 )
				RL_PlaySound( Resources.sounds.hit )

				self:spawnParticles( Rect:new( 4, 25, 1, 1 ) )
			end
		end
	end
end

function Bullet:draw()
	if self.sprite ~= nil then
		self.sprite:draw( self.position )
	end
end
