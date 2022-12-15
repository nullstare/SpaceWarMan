Player = {}
Player.__index = Player

function Player:new()
	local object = setmetatable( {}, self )

	object.MAXSPEED = 1.3
	object.ACCELL = 8
	object.DEACCELL = 8
	object.GRAVITY = 6
	object.JUMP_STR = 3
	object.WALK_ANIM_SPEED = 12

	object.BULLET_SPEED = 200
	object.BULLET_RANGE = 100

	object.ready = false
	object.position = Vec2:new()
	object.sprite = nil

	object.facing = 1
	object.velocity = Vec2:new( 0, -0.01 ) -- Tiny push upwards to get out of floor if put right onto it.
	object.colRect = Rect:new( 0, 0, 12, 17 )
	object.onFloor = false

	object.gunPosition = Vec2:new( 4, -8 )

    return object
end

function Player:init( pos )
	self:setPosition( pos )
	self.sprite = Sprite:new( Resources.textures.player, nil, nil, { 18, 24 }, 0.0, WHITE )
	
	-- Set animations.
	self.sprite.animations.idle = { { source = Rect:new( 1, 1, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } }
	self.sprite.animations.walk = {}

	for i = 0, 7 do
		table.insert( self.sprite.animations.walk, { source = Rect:new( 1 + i * 36, 53, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } )
	end

	self.sprite.animation = "idle"

	-- Enable draw and process.
	self.ready = true
end

function Player:setPosition( pos )
	self.position.x = pos.x
	self.position.y = pos.y
	self.colRect.x = pos.x - self.colRect.width / 2
	self.colRect.y = pos.y - self.colRect.height
end

function Player:process( delta )
	local moving = { false, false }

	if RL_IsKeyDown( Settings.keys.right ) then
		self.velocity.x = self.velocity.x + self.ACCELL * delta
		moving[1] = true

		if 0 < self.velocity.x then
			self.facing = 1
			self.sprite.HFlipped = false
		end
	elseif RL_IsKeyDown( Settings.keys.left ) then
		self.velocity.x = self.velocity.x - self.ACCELL * delta
		moving[1] = true

		if self.velocity.x < 0 then
			self.facing = -1
			self.sprite.HFlipped = true
		end
	end

	if RL_IsKeyPressed( Settings.keys.jump ) and self.onFloor then
		self.velocity.y = -self.JUMP_STR
		self.onFloor = false
	end

	-- Deaccelerate.

	if not moving[1] then
		if delta * self.DEACCELL < self.velocity.x then
			self.velocity.x = self.velocity.x - self.DEACCELL * delta
		elseif self.velocity.x < -delta * self.DEACCELL then
			self.velocity.x = self.velocity.x + self.DEACCELL * delta
		else
			self.velocity.x = 0.0
		end
	end

	self.velocity.x = util.clamp( self.velocity.x, -self.MAXSPEED, self.MAXSPEED )
	self.velocity.y = self.velocity.y + self.GRAVITY * delta

	-- Drop from platform.
	if self.onFloor and 0.5 < self.velocity.y then
		self.onFloor = false
	end

	Room:tileCollision( self )
	self.sprite.HFacing = self.facing
	self:setPosition( self.position + self.velocity )
	
	if self.onFloor and ( self.velocity.x < -0.1 or 0.1 < self.velocity.x ) then
		self.sprite.animation = "walk"
		self.sprite:playAnimation( math.abs( self.velocity.x ) * self.WALK_ANIM_SPEED * delta )
	elseif not self.onFloor then
		self.sprite.animation = "walk"
		self.sprite.animationPos = 2.0
	else
		self.sprite.animation = "idle"
		self.animationPos = 0.0
	end

	Camera:setPosition( self.position )

	-- Shoot.

	if RL_IsKeyPressed( Settings.keys.shoot ) then
		local pos = self.position + Vec2:new( self.gunPosition.x * self.facing, self.gunPosition.y )
		local vel = Vec2:new( self.BULLET_SPEED * self.facing, 0 )

		-- Bullets:add( Bullet:new( pos, vel, Resources.textures.effects, Rect:new( 1, 1, 8, 8 ) ) )
		Bullets:add( Bullet:new( pos, vel, Resources.textures.effects, { 1, 1, 8, 8 }, self.BULLET_RANGE ) )
	end
end

function Player:draw()
	if self.ready and self.sprite ~= nil then
		self.sprite:draw( self.position )
	end
end

Player = Player:new()
