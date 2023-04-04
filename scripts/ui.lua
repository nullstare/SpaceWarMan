UI = {}
UI.__index = UI

UI.CONTAINER_RECT_FULL = Rect:new( 49, 509, 14, 14 )
UI.CONTAINER_RECT_EMPTY = Rect:new( 81, 509, 14, 14 )
UI.HEALTH_RECT_FULL = Rect:new( 11, 21, 8, 8 )
UI.HEALTH_RECT_EMPTY = Rect:new( 1, 21, 8, 8 )
UI.MESSAGE_RECT = Rect:new(
	Window.FRAMEBUFFER_SIZE.x / 2 - 96,
	Window.FRAMEBUFFER_SIZE.y / 2 - 16,
	192,
	32
)
UI.FONT_SIZE = 10
UI.SPACING = 1

function UI:new()
    local object = setmetatable( {}, self )

	object.message = nil

    return object
end

function UI:process( delta )
	local shootPressed = RL_IsKeyPressed( Settings.keys.shoot ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

	if self.message ~= nil and shootPressed then
		self.message = nil
		Game.run = true
	end 
end

function UI:drawUi()
	local containers = Player.energyTanks
	local health = Player.health
	local pos = Vec2:new( 1, 0 )

	for i = 0, containers - 1 do
		if i * Player.TANK_HEALTH < Player.health then
			RL_DrawTextureRec( Resources.textures.ObjectsAndEnemies, self.CONTAINER_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.ObjectsAndEnemies, self.CONTAINER_RECT_EMPTY, pos, WHITE )
		end
		pos.x = pos.x + 13
	end

	pos.x = 2
	pos.y = 15

	for i = 0, Player.TANK_HEALTH - 1 do
		if 0 < Player.health and i + 1 <= Player.health - math.floor( ( Player.health - 1 ) / Player.TANK_HEALTH ) * Player.TANK_HEALTH then
			RL_DrawTextureRec( Resources.textures.ObjectsAndEnemies, self.HEALTH_RECT_FULL, pos, WHITE )
		else
			RL_DrawTextureRec( Resources.textures.ObjectsAndEnemies, self.HEALTH_RECT_EMPTY, pos, WHITE )
		end

		pos.x = pos.x + 8
	end
end

function UI:setMessage( message )
	self.message = message
	Game.run = false
end

function UI:drawMessage()
	local center = Vec2:new( Window.FRAMEBUFFER_SIZE.x / 2, Window.FRAMEBUFFER_SIZE.y / 2 )
	local textSize = Vec2:new( RL_MeasureText( 0, self.message, self.FONT_SIZE, self.SPACING ) )
	local textRect = Rect:new( math.floor( center.x - textSize.x / 2 ), math.floor( center.y - textSize.y / 2 ), textSize.x, textSize.y )

	RL_DrawRectangle( self.MESSAGE_RECT, BLACK )
	RL_DrawText( 0, self.message, textRect, self.FONT_SIZE, self.SPACING, WHITE )
end

function UI:draw()
	self:drawUi()

	if self.message ~= nil then
		self:drawMessage()
	end
end

UI = UI:new()
