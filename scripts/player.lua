Player = {}
Player.__index = Player

Player.MAXSPEED = 1.1
Player.ACCELL = 8
Player.DEACCELL = 8
Player.AIR_ACCELL = 4
Player.AIR_DEACCELL = 4
Player.JUMP_SPEED = 2
Player.JUMP_SUSTAIN_FORCE = 5
Player.JUMP_SUSTAIN_MAX = 1.3
Player.WALK_ANIM_SPEED = 12

Player.BULLET_SPEED = 200
Player.BULLET_RANGE = 70

Player.TANK_HEALTH = 5
Player.INV_TIME = 1.0
Player.INV_BLINK_TIME = 0.1

Player.AIM = {
	FRONT = 0,
	UP = 1,
	DIAGONAL = 2,
}

function Player:new()
	local object = setmetatable( {}, self )

	object.inited = false
	object.position = Vec2:new()
	object.sprite = nil

	object.facing = 1
	object.velocity = Vec2:new()
	object.colRect = Rect:new( 0, 0, 10, 15 )
	object.onFloor = false
	object.jumpSustain = object.JUMP_SUSTAIN_MAX
	object.gunPosition = Vec2:new( 4, -8 )
	object.energyTanks = 1
	object.health = object.TANK_HEALTH * object.energyTanks
	object.invTimer = 0.0
	object.aim = object.AIM.FRONT

	object.collectedEnergyTanks = {}
	object.doubleJump = false
	object.usedDoubleJump = false

    return object
end

function Player:init( pos )
	pos.y = pos.y - 0.1 -- Tiny gap upwards to get out of floor if put right onto it.

	self:setPosition( pos )
	self.sprite = Sprite:new( Resources.textures.player, Rect:new(), Rect:new(), Vec2:new( 17, 24 ), 0.0, WHITE )
	
	-- Set animations.
	self.sprite.animations.idle = { { source = Rect:new( 1, 1, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } }
	self.sprite.animations.aimUp = { { source = Rect:new( 1, 313, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } }
	self.sprite.animations.aimDiagonal = { { source = Rect:new( 1, 235, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } }
	self.sprite.animations.walk = {}

	for i = 0, 7 do
		table.insert( self.sprite.animations.walk, { source = Rect:new( 1 + i * 36, 53, 34, 24 ), dest = Rect:new( 0, 0, 34, 24 ) } )
	end

	self.sprite.animation = "idle"
	self.inited = true
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
	RL_PlaySound( Resources.sounds.hit3 )

	if self.health <= 0 then
		self:destroy()
	end
end

function Player:destroy()
	RL_PlaySound( Resources.sounds.exlosion )

	ParticleEmitters:add( ParticleEmitter:new(
		self.position:clone(),
		Resources.textures.effects,
		Rect:new( 2, 36, 10, 10 ),
		WHITE,
		{ -- Emit.
			count = 16,
			interval = 0.02,
			pos = { min = Vec2:new( -6, -16 ), max = Vec2:new( 6, -1 ) },
			vel = { min = Vec2:new( -80, -80 ), max = Vec2:new( 80, 80 ) },
			deltaVel = { min = Vec2:new( 0, -40 ), max = Vec2:new( 0, -30 ) },
			lifetime = { min = 0.25, max = 0.45 },
		}
	) )
end

function Player:heal( amount )
	self.health = math.min( self.health + 1, self.energyTanks * self.TANK_HEALTH )
end

function Player:process( delta )
	if self.health <= 0 then
		return
	end

	local moving = { false, false }
	local rightDown = RL_IsKeyDown( Settings.keys.right ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.right ) )
	local leftDown = RL_IsKeyDown( Settings.keys.left ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.left ) )
	local upDown = RL_IsKeyDown( Settings.keys.up ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.up ) )
	local diagonalDown = RL_IsKeyDown( Settings.keys.diagonal ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.diagonal ) )
	local jumpPressed = RL_IsKeyPressed( Settings.keys.jump ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.jump ) )
	local jumpDown = RL_IsKeyDown( Settings.keys.jump ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonDown( Settings.gamepad, Settings.buttons.jump ) )
	local shootPressed = RL_IsKeyPressed( Settings.keys.shoot ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

	self.aim = self.AIM.FRONT

	local accell = self.ACCELL
	local deaccell = self.DEACCELL

	if not self.onFloor then
		accell = self.AIR_ACCELL
		deaccell = self.AIR_DEACCELL
	end

	if rightDown then
		self.velocity.x = self.velocity.x + accell * delta
		moving[1] = true

		if 0 < self.velocity.x then
			if self.onFloor then
				self.facing = 1
			end
			self.sprite.HFlipped = false
		end
	elseif leftDown then
		self.velocity.x = self.velocity.x - accell * delta
		moving[1] = true

		if self.velocity.x < 0 then
			if self.onFloor then
				self.facing = -1
			end
			self.sprite.HFlipped = true
		end
	elseif upDown and self.onFloor then
		self.aim = self.AIM.UP
	elseif diagonalDown and self.onFloor then
		self.aim = self.AIM.DIAGONAL
	end

	-- Jump sustain.
	if jumpDown and 0 < self.jumpSustain and self.velocity.y < 0.0 then
		local force = math.min( self.JUMP_SUSTAIN_FORCE * delta, self.jumpSustain )

		self.velocity.y = self.velocity.y - force
		self.jumpSustain = self.jumpSustain - force
	end

	-- Double jump.
	if jumpPressed and not self.onFloor and self.doubleJump and not self.usedDoubleJump then
		self.velocity.y = -self.JUMP_SPEED
		self.onFloor = false
		self.usedDoubleJump = true
		self.jumpSustain = self.JUMP_SUSTAIN_MAX / 2
		RL_PlaySound( Resources.sounds.jump )
	end

	-- Main jump.
	if jumpPressed and self.onFloor then
		self.velocity.y = -self.JUMP_SPEED
		self.onFloor = false
		RL_PlaySound( Resources.sounds.jump )
	end

	-- Deaccelerate.
	if not moving[1] then
		if delta * deaccell < self.velocity.x then
			self.velocity.x = self.velocity.x - deaccell * delta
		elseif self.velocity.x < -delta * deaccell then
			self.velocity.x = self.velocity.x + deaccell * delta
		else
			self.velocity.x = 0.0
		end
	end

	self.velocity.x = util.clamp( self.velocity.x, -self.MAXSPEED, self.MAXSPEED )
	self.velocity.y = self.velocity.y + Room.GRAVITY * delta

	-- Drop from platform.
	if self.onFloor and 0.5 < self.velocity.y then
		self.onFloor = false
	end

	local landVel = self.velocity.y

	-- Stop on ceiling.
	if self.position.y <= 1 then
		self.position.y = 1
	end

	local landed = Room:tileCollision( self )

	-- Returns true if landed.
	if landed then
		self.jumpSustain = self.JUMP_SUSTAIN_MAX
		self.usedDoubleJump = false

		if 1.5 < landVel then
			RL_SetSoundVolume( Resources.sounds.land, 0.2 )
			RL_PlaySound( Resources.sounds.land )
		end
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
		if self.aim == self.AIM.UP then
			self.sprite.animation = "aimUp"
			self.animationPos = 0.0
		elseif self.aim == self.AIM.DIAGONAL then
			self.sprite.animation = "aimDiagonal"
			self.animationPos = 0.0
		else
			self.sprite.animation = "idle"
			self.animationPos = 0.0
		end
	end

	Camera:setPosition( self.position )

	-- Shoot.

	if shootPressed then
		local pos
		local vel

		if self.aim == self.AIM.UP then
			pos = self.position + Vec2:new( 0, self.gunPosition.y )
			vel = Vec2:new( 0, -self.BULLET_SPEED )
		elseif self.aim == self.AIM.DIAGONAL then
			pos = self.position + Vec2:new( self.gunPosition.x * self.facing, self.gunPosition.y )
			vel = Vec2:new( self.facing, -1 ):normalize():scale( self.BULLET_SPEED )
		else
			pos = self.position + Vec2:new( self.gunPosition.x * self.facing, self.gunPosition.y )
			vel = Vec2:new( self.BULLET_SPEED * self.facing, 0 )
		end

		Bullets:add( Bullet:new( pos, vel, Resources.textures.effects, Rect:new( 1, 1, 8, 8 ), Vec2:new( 4, 4 ), self.BULLET_RANGE ) )
		RL_SetSoundPitch( Resources.sounds.shoot, 0.9 + math.random() * 0.2 )
		RL_PlaySound( Resources.sounds.shoot )
	end

	-- Inv timer.
	if 0 < self.invTimer then
		self.invTimer = self.invTimer - delta
	end

	-- Check room transitions.
	if Room.data.width * TILE_SIZE <= self.position.x then
		Room:transition( "right" )
	elseif self.position.x <= 0 then
		Room:transition( "left" )
	end
end

function Player:draw()
	if 0 < self.health and self.sprite ~= nil then
		if self.invTimer <= 0 or math.floor( self.invTimer / self.INV_BLINK_TIME % 2 ) == 1 then
			self.sprite:draw( self.position )
		end
	end

	-- RL_DrawRectangle( self.colRect, { 255, 100, 100, 200 } )
end

Player = Player:new()
