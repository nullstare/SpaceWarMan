DoubleJump = {}
DoubleJump.__index = DoubleJump

DoubleJump.ANIM_SPEED = 5
DoubleJump.ANIMATIONS = {}
DoubleJump.ANIMATIONS.idle = { { source = Rect:new( 17, 447, 14, 8 ), dest = Rect:new( 0, 0, 14, 8 ) } }

for i = 0, 5 do
	table.insert( DoubleJump.ANIMATIONS.idle, { source = Rect:new( 1, 447, 14, 8 ), dest = Rect:new( 0, 0, 14, 8 ) } )
end

function DoubleJump:new( pos )
	local object = setmetatable( {}, self )

	object.id = 1
	object.position = Vec2:new( pos.x + 4, pos.y )
	object.colRect = Rect:new( pos.x, pos.y - 8, 14, 8 )

	object.sprite = Sprite:new( Resources.textures.objectsAndEnemies, Rect:new(), Rect:new(), Vec2:new( 4, 8 ), 0.0, WHITE )
	object.sprite.animations = object.ANIMATIONS
	object.sprite.animation = "idle"

    return object
end

function DoubleJump:destroy()
	Pickups.pickups[ self.id ] = Pickups.FREE
end

function DoubleJump:process( delta )
	if RL_CheckCollisionRecs( self.colRect, Player.colRect ) then
		Player.doubleJump = true
		self:destroy()
		RL_PlaySound( Resources.sounds.powerUp )
		Game:setMessage( Resources.locale.doubleJumpAcquired )
	end

	self.sprite:playAnimation( self.ANIM_SPEED * delta )
end

function DoubleJump:draw()
	if self.sprite ~= nil then
		self.sprite:draw( self.position )
	end
end
