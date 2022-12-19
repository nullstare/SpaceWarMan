Game = {}
Game.__index = Game

Game.CONTAINER_RECT_FULL = Rect:new( 49, 509, 14, 14 )
Game.CONTAINER_RECT_EMPTY = Rect:new( 81, 509, 14, 14 )
Game.HEALTH_RECT_FULL = Rect:new( 11, 21, 8, 8 )
Game.HEALTH_RECT_EMPTY = Rect:new( 1, 21, 8, 8 )

function Game:new()
    local object = setmetatable( {}, self )

    return object
end

function Game:start()
	Room:load( "room01.lua" )
end

function Game:process( delta )
	if Player.ready then
		Enemies:process( delta )
		Player:process( delta )
		Bullets:process( delta )
		Pickups:process( delta )
		ParticleEmitters:process( delta )
	end

	if Settings.gamepadEnabled and Settings.gamepad == nil and RL_IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end
end

function Game:drawUi()
	local containers = Player.healthContainers
	local health = Player.health
	local pos = Vec2:new( 1, 0 )

	for i = 0, containers - 1 do
		if i * Player.CONTAINER_HEALTH < Player.health then
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.CONTAINER_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.CONTAINER_RECT_EMPTY, pos, WHITE )
		end
		pos.x = pos.x + 13
	end

	pos.x = 2
	pos.y = 15

	for i = 0, Player.CONTAINER_HEALTH - 1 do
		if 0 < Player.health and i + 1 <= Player.health - math.floor( ( Player.health - 1 ) / Player.CONTAINER_HEALTH ) * Player.CONTAINER_HEALTH then
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.HEALTH_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.HEALTH_RECT_EMPTY, pos, WHITE )
		end

		pos.x = pos.x + 8
	end
end

function Game:draw()
	RL_DrawTexture( Room.bgrImage, Room.bgrImagePos, WHITE )

	RL_SetCamera2DTarget( Camera.camera, Camera.position )

	RL_BeginMode2D( Camera.camera )
		Room:draw()
		Enemies:draw()
		Player:draw()
		Bullets:draw()
		Pickups:draw()
		ParticleEmitters:draw()
	RL_EndMode2D()

	self:drawUi()
end

Game = Game:new()
