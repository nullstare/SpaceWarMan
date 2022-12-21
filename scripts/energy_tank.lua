EnergyTank = {}
EnergyTank.__index = EnergyTank

EnergyTank.ANIM_SPEED = 5
EnergyTank.ANIMATIONS = {}
EnergyTank.ANIMATIONS.idle = { { source = Rect:new( 17, 437, 14, 8 ), dest = Rect:new( 0, 0, 14, 8 ) } }

for i = 0, 5 do
	table.insert( EnergyTank.ANIMATIONS.idle, { source = Rect:new( 1, 437, 14, 8 ), dest = Rect:new( 0, 0, 14, 8 ) } )
end

function EnergyTank:new( pos, name )
	local object = setmetatable( {}, self )

	object.id = 1
	object.position = Vec2:new( pos.x + 4, pos.y )
	object.colRect = Rect:new( pos.x, pos.y - 8, 14, 8 )

	object.sprite = Sprite:new( Resources.textures.objectsAndEnemies, Rect:new(), Rect:new(), Vec2:new( 4, 8 ), 0.0, WHITE )
	object.sprite.animations = object.ANIMATIONS
	object.sprite.animation = "idle"

	object.name = name -- Name to identify specific tank so that we only have one of them.

    return object
end

function EnergyTank:destroy()
	Objects.pickups[ self.id ] = Objects.FREE
end

function EnergyTank:process( delta )
	if RL_CheckCollisionRecs( self.colRect, Player.colRect ) then
		Player.collectedEnergyTanks[ self.name ] = true
		Player.energyTanks = Player.energyTanks + 1
		Player.health = Player.health + Player.TANK_HEALTH
		self:destroy()
		RL_PlaySound( Resources.sounds.powerUp )
		Game:setMessage( Resources.locale.energyTankAcquired )
	end

	self.sprite:playAnimation( self.ANIM_SPEED * delta )
end

function EnergyTank:draw()
	if self.sprite ~= nil then
		self.sprite:draw( self.position )
	end

	-- RL_DrawRectangle( self.colRect, { 0, 255, 0, 50 } )
end
