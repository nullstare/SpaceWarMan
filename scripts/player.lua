Player = {}
Player.__index = Player

Player.MAXSPEED = 1.1
Player.ACCELL = 8
Player.DEACCELL = 8
Player.GRAVITY = 6
Player.JUMP_SPEED = 2
Player.JUMP_SUSTAIN_FORCE = 5
Player.JUMP_SUSTAIN_MAX = 1.3
Player.WALK_ANIM_SPEED = 12

Player.BULLET_SPEED = 200
Player.BULLET_RANGE = 70

Player.CONTAINER_HEALTH = 5
Player.INV_TIME = 1.0
Player.INV_BLINK_TIME = 0.1

function Player:new()
	local object = setmetatable( {}, self )

	object.ready = false
	object.position = Vec2:new()
	object.sprite = nil

	object.facing = 1
	object.velocity = Vec2:new( 0, -0.01 ) -- Tiny push upwards to get out of floor if put right onto it.
	object.colRect = Rect:new( 0, 0, 12, 15 )
	object.onFloor = false
	object.jumpSustain = object.JUMP_SUSTAIN_MAX
	object.gunPosition = Vec2:new( 4, -8 )
	object.healthContainers = 1
	object.health = object.CONTAINER_HEALTH * object.healthContainers
	object.invTimer = 0.0

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

function Player:takeDamage( damage )
	if 0 < self.invTimer then
		return
	end

	self.health = self.health - damage
	self.invTimer = self.INV_TIME
	RL_PlaySound( Resources.sounds.hit )

	if self.health <= 0 then
		self.ready = false
		RL_PlaySound( Resources.sounds.exlosion )
	end
end

function Player:process( delta )
	local moving = { false, false }
	local rightDown = RL_IsKeyDown( Settings.keys.right ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.right ) )
	local leftDown = RL_IsKeyDown( Settings.keys.left ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.left ) )
	local jumpPressed = RL_IsKeyPressed( Settings.keys.jump ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.jump ) )
	local jumpDown = RL_IsKeyDown( Settings.keys.jump ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.jump ) )
	local shootPressed = RL_IsKeyPressed( Settings.keys.shoot ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

	if rightDown then
		self.velocity.x = self.velocity.x + self.ACCELL * delta
		moving[1] = true

		if 0 < self.velocity.x then
			self.facing = 1
			self.sprite.HFlipped = false
		end
	elseif leftDown then
		self.velocity.x = self.velocity.x - self.ACCELL * delta
		moving[1] = true

		if self.velocity.x < 0 then
			self.facing = -1
			self.sprite.HFlipped = true
		end
	end

	-- Jump sustain.
	if jumpDown and 0 < self.jumpSustain and self.velocity.y < 0.0 then
		local force = math.min( self.JUMP_SUSTAIN_FORCE * delta, self.jumpSustain )

		self.velocity.y = self.velocity.y - force
		self.jumpSustain = self.jumpSustain - force
	end

	-- Main jump.
	if jumpPressed and self.onFloor then
		self.velocity.y = -self.JUMP_SPEED
		self.onFloor = false
		RL_PlaySound( Resources.sounds.jump )
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

	local landVel = self.velocity.y

	-- Returns true if landed.
	if Room:tileCollision( self ) and 1.5 < landVel then
		RL_SetSoundVolume( Resources.sounds.land, 0.2 )
		RL_PlaySound( Resources.sounds.land )
	end

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

	if shootPressed then
		local pos = self.position + Vec2:new( self.gunPosition.x * self.facing, self.gunPosition.y )
		local vel = Vec2:new( self.BULLET_SPEED * self.facing, 0 )

		Bullets:add( Bullet:new( pos, vel, Resources.textures.effects, { 1, 1, 8, 8 }, self.BULLET_RANGE ) )
		RL_SetSoundPitch( Resources.sounds.shoot, 0.9 + math.random() * 0.2 )
		RL_PlaySound( Resources.sounds.shoot )
	end

	-- Inv timer.
	if 0 < self.invTimer then
		self.invTimer = self.invTimer - delta
	end
end

function Player:draw()
	if self.ready and self.sprite ~= nil then
		self.sprite.tint = WHITE

		if 0 < self.invTimer and math.floor( self.invTimer / self.INV_BLINK_TIME % 2 ) == 1 then
			self.sprite.tint = RED
		end

		self.sprite:draw( self.position )
	end

	-- RL_DrawRectangleLines( self.colRect, RED )
end

Player = Player:new()
