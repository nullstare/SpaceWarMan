Bullet = {}
Bullet.__index = Bullet

function Bullet:new( pos, vel, tex, source, range )
	local object = setmetatable( {}, self )

	object.id = 1
	object.position = pos:clone()
	object.velocity = vel:clone()
	object.sprite = Sprite:new( Resources.textures.effects, source, { pos.x, pos.y, source[3], source[4] }, { 4, 4 }, 0.0, WHITE )
	object.range = range
	object.colRect = Rect:new( pos.x + 1, pos.y + 1, source[3] - 2, source[4] - 2 )
	object.damage = 1
	object.hit = Bullets.HIT.ENEMIES

    return object
end

function Bullet:destroy()
	Bullets.bullets[ self.id ] = Bullets.FREE
end

function Bullet:process( delta )
	local range = self.velocity:scale( delta )

	self.position = self.position + range
	self.colRect.x = self.position.x - self.colRect.width / 2 + 1
	self.colRect.y = self.position.y - self.colRect.height / 2 + 1
	self.range = self.range - range:length()

	if self.range <= 0.0 or Room:ifBulletCollide( self ) then
		self:destroy()
	end

	if self.hit == Bullets.HIT.ENEMIES then
		for _, enemy in ipairs( Enemies.enemies ) do
			if enemy ~= Bullets.FREE and RL_CheckCollisionRecs( self.colRect, enemy.colRect ) then
				self:destroy()
				enemy:takeDamage( self.damage )
				RL_SetSoundPitch( Resources.sounds.hit, 0.7 + math.random() * 0.4 )
				RL_PlaySound( Resources.sounds.hit )
			end
		end
	end
end

function Bullet:draw()
	if self.sprite ~= nil then
		self.sprite:draw( self.position )
	end

	-- RL_DrawRectangleLines( self.colRect, RED )
end
