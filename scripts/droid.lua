Droid = {}
Droid.__index = Droid

Droid.WALK_SPEED = 30
Droid.WALK_ANIM_SPEED = 12
Droid.JUMP_SPEED = Vec2:new( 80, 3 )
Droid.ACTIONS = {
	WALK = 0,
	JUMP = 1,
}
Droid.ANIMATIONS = {}
Droid.ANIMATIONS.idle = { { source = Rect:new( 1, 31, 16, 14 ), dest = Rect:new( 0, 0, 16, 14 ) } }
Droid.ANIMATIONS.walk = {}

for i = 0, 2 do
	table.insert( Droid.ANIMATIONS.walk, { source = Rect:new( 73 + i * 18, 31, 16, 14 ), dest = Rect:new( 0, 0, 16, 14 ) } )
end

function Droid:new( pos, facing )
	local object = setmetatable( {}, self )

	pos.y = pos.y - 0.1 -- Tiny gap upwards to get out of floor if put right onto it.

	object.id = 1
	object.position = pos
	object.velocity = Vec2:new()
	object.facing = facing
	object.onFloor = false
	object.colRect = Rect:new( pos.x, pos.y, 10, 13 )

	object.sprite = Sprite:new( Resources.textures.ObjectsAndEnemies, Rect:new(), Rect:new(), Vec2:new( 16 / 2, 14 ), 0.0, RL.WHITE )
	object.sprite.animations = object.ANIMATIONS
	object.sprite.animation = "idle"

	object.timer = 4.0
	object.action = object.ACTIONS.WALK
	object.health = 4
	object.hurtFrames = 0

	object:setPosition( pos )

    return object
end

function Droid:setPosition( pos )
	self.position.x = pos.x
	self.position.y = pos.y
	self.colRect.x = pos.x - self.colRect.width / 2
	self.colRect.y = pos.y - self.colRect.height
end

function Droid:destroy()
	Entities.enemies[ self.id ] = Entities.FREE
	RL.PlaySound( Resources.sounds.exlosion )

	Entities:add( Entities.emitters, ParticleEmitter:new(
		self.position:clone(),
		Resources.textures.effects,
		Rect:new( 2, 36, 10, 10 ),
		RL.WHITE,
		{ -- Emit.
			count = 8,
			interval = 0.01,
			pos = { min = Vec2:new( -6, -16 ), max = Vec2:new( 6, -1 ) },
			vel = { min = Vec2:new( -50, -50 ), max = Vec2:new( 50, 50 ) },
			deltaVel = { min = Vec2:new( 0, -40 ), max = Vec2:new( 0, -30 ) },
			lifetime = { min = 0.15, max = 0.25 },
		}
	) )
	local dropRoll = math.random()

	if dropRoll < 0.3 then
		Entities:add( Entities.pickups, Health:new( self.position ) )
	end
end

function Droid:takeDamage( damage )
	self.health = self.health - damage
	self.hurtFrames = 3

	if self.health < 0 then
		self:destroy()
	end
end

function Droid:update( delta )
	self.sprite.HFacing = self.facing

	-- Drop from platform.
	if self.onFloor and 0.5 < self.velocity.y then
		self.onFloor = false
	end

	if self.onFloor then
		if 0.1 < math.abs( self.velocity.x ) then
			self.sprite.animation = "walk"
			self.sprite:playAnimation( math.abs( self.velocity.x ) * self.WALK_ANIM_SPEED * delta )
		else
			self.sprite.animation = "idle"
			self.animationPos = 0.0
		end
	elseif not self.onFloor then
		self.sprite.animation = "walk"
		self.sprite.animationPos = 0.0
	end

	if RL.CheckCollisionRecs( self.colRect, Player.colRect ) then
		Player:takeDamage( 1 )
	end
end

function Droid:physicsUpdate( delta, step )
	if self.action == self.ACTIONS.WALK then
		self.velocity.x = self.facing * self.WALK_SPEED * delta
	elseif self.action == self.ACTIONS.JUMP then
		if self.onFloor then
			self.velocity.x = 0.0
		else
			self.velocity.x = self.facing * self.JUMP_SPEED.x * delta
		end
	end

	if self.onFloor then
		self.timer = self.timer - delta

		if self.timer <= 0.0 then
			self.action = 1 - self.action

			if self.action == self.ACTIONS.JUMP then
				self.velocity.y = -self.JUMP_SPEED.y
				self.onFloor = false
				self.timer = 1.0
			elseif self.action == self.ACTIONS.WALK then
				self.facing = self.facing * -1.0
				self.timer = 1.0 + math.random() * 3.0
			end
		end
	end

	self.velocity.y = self.velocity.y + Room.GRAVITY * delta

	-- On map edge.

	if self.position.x < 8 then
		self.position.x = 8
		self.facing = 1
	elseif Room.data.width * TILE_SIZE - 8 < self.position.x then
		self.position.x = Room.data.width * TILE_SIZE - 8
		self.facing = -1
	end

	Room:tileCollision( self )

	if self.onFloor and self.velocity.x ~= 0.0 and math.abs( self.velocity.x ) < 0.001 then
		self.facing = self.facing * -1.0
	end

	self:setPosition( self.position + self.velocity )
end

function Droid:draw()
	if self.sprite ~= nil then
		if 0 < self.hurtFrames then
			self.sprite.tint = RL.RED
			self.hurtFrames = self.hurtFrames - 1
		end

		self.sprite:draw( self.position )

		self.sprite.tint = RL.WHITE
	end
	if Settings.debug.showHitboxes then
		RL.DrawRectangleLines( self.colRect, RL.GREEN )
	end
end
