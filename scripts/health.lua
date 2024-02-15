Health = {}
Health.__index = Health

Health.ANIM_SPEED = 12
Health.DEACCELL = 0.5
Health.LIFETIME = 10
Health.BLINK_LIFETIME = 4
Health.BLINK_INTERVAL = 0.2

Health.ANIMATIONS = {}
Health.ANIMATIONS.idle = {}

for i = 0, 6 do
	table.insert( Health.ANIMATIONS.idle, { source = Rect:new( 1 + i * 10, 1, 8, 8 ), dest = Rect:new( 0, 0, 8, 8 ) } )
end

function Health:new( pos )
	local object = setmetatable( {}, self )

	object.id = 1
	object.position = pos
	object.velocity = Vec2:new( Util.randomFloat( -1.0, 1.0 ), -2 )
	object.onFloor = false
	object.colRect = Rect:new( pos.x - 4, pos.y - 8, 8, 8 )
	object.lifetime = object.LIFETIME

	object.sprite = Sprite:new( Resources.textures.ObjectsAndEnemies, Rect:new(), Rect:new(), Vec2:new( 4, 8 ), 0.0, RL.WHITE )
	object.sprite.animations = object.ANIMATIONS
	object.sprite.animation = "idle"

    return object
end

function Health:setPosition( pos )
	self.position.x = pos.x
	self.position.y = pos.y
	self.colRect.x = pos.x - self.colRect.width / 2
	self.colRect.y = pos.y - self.colRect.height
end

function Health:destroy()
	Entities.pickups[ self.id ] = Entities.FREE
end

function Health:process( delta )
	self.sprite:playAnimation( self.ANIM_SPEED * delta )

	self.lifetime = self.lifetime - delta

	if self.lifetime <= 0 then
		self:destroy()
	end
end

function Health:physicsProcess( delta, step )
	self.velocity.y = self.velocity.y + Room.GRAVITY * delta

	if self.onFloor then
		self.velocity.x = 0.0
	else
		if delta * self.DEACCELL < self.velocity.x then
			self.velocity.x = self.velocity.x - self.DEACCELL * delta
		elseif self.velocity.x < -delta * self.DEACCELL then
			self.velocity.x = self.velocity.x + self.DEACCELL * delta
		else
			self.velocity.x = 0.0
		end
	end

	Room:tileCollision( self )
	self:setPosition( self.position + self.velocity )

	if RL.CheckCollisionRecs( self.colRect, Player.colRect ) then
		self:destroy()
		RL.PlaySound( Resources.sounds.pickup )
		Player:heal( 1 )
	end
end

function Health:draw()
	if self.sprite ~= nil then
		if self.BLINK_LIFETIME < self.lifetime or math.floor( self.lifetime / self.BLINK_INTERVAL % 2 ) == 1 then
			self.sprite:draw( self.position )
		end
	end
end
