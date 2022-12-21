Game = {}
Game.__index = Game

Game.CONTAINER_RECT_FULL = Rect:new( 49, 509, 14, 14 )
Game.CONTAINER_RECT_EMPTY = Rect:new( 81, 509, 14, 14 )
Game.HEALTH_RECT_FULL = Rect:new( 11, 21, 8, 8 )
Game.HEALTH_RECT_EMPTY = Rect:new( 1, 21, 8, 8 )
Game.MESSAGE_RECT = Rect:new(
	Window.FRAMEBUFFER_SIZE.x / 2 - 96,
	Window.FRAMEBUFFER_SIZE.y / 2 - 16,
	192,
	32
)
Game.MESSAGE_FONT_SIZE = 10
Game.MESSAGE_SPACING = 1

function Game:new()
    local object = setmetatable( {}, self )

	object.run = false
	object.message = nil

    return object
end

function Game:start()
	Room:load( "start.lua" )
end

function Game:process( delta )
	if self.run then
		Player:process( delta )
		Objects:process( delta )
	end

	if Settings.gamepadEnabled and Settings.gamepad == nil and RL_IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end

	local shootPressed = RL_IsKeyPressed( Settings.keys.shoot ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

	if self.message ~= nil and shootPressed then
		self.message = nil
		self.run = true
	end 
end

function Game:drawUi()
	local containers = Player.energyTanks
	local health = Player.health
	local pos = Vec2:new( 1, 0 )

	for i = 0, containers - 1 do
		if i * Player.TANK_HEALTH < Player.health then
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.CONTAINER_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.CONTAINER_RECT_EMPTY, pos, WHITE )
		end
		pos.x = pos.x + 13
	end

	pos.x = 2
	pos.y = 15

	for i = 0, Player.TANK_HEALTH - 1 do
		if 0 < Player.health and i + 1 <= Player.health - math.floor( ( Player.health - 1 ) / Player.TANK_HEALTH ) * Player.TANK_HEALTH then
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.HEALTH_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.objectsAndEnemies, self.HEALTH_RECT_EMPTY, pos, WHITE )
		end

		pos.x = pos.x + 8
	end
end

function Game:setMessage( message )
	self.message = message
	self.run = false
end

function Game:drawMessage()
	local center = Vec2:new( Window.FRAMEBUFFER_SIZE.x / 2, Window.FRAMEBUFFER_SIZE.y / 2 )
	local textSize = Vec2:new( RL_MeasureText( 0, self.message, self.MESSAGE_FONT_SIZE, self.MESSAGE_SPACING ) )
	local textRect = Rect:new( math.floor( center.x - textSize.x / 2 ), math.floor( center.y - textSize.y / 2 ), textSize.x, textSize.y )

	RL_DrawRectangle( self.MESSAGE_RECT, BLACK )
	RL_DrawText( 0, self.message, textRect, self.MESSAGE_FONT_SIZE, self.MESSAGE_SPACING, WHITE )
end

function Game:draw()
	RL_DrawTexture( Room.bgrImage, Room.bgrImagePos, WHITE )

	RL_SetCamera2DTarget( Camera.camera, Camera.position )

	RL_BeginMode2D( Camera.camera )
		Room:draw()
		Player:draw()
		Objects:draw()
	RL_EndMode2D()

	self:drawUi()

	if self.message ~= nil then
		self:drawMessage()
	end
end

Game = Game:new()
