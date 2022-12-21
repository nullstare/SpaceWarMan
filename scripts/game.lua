Game = {}
Game.__index = Game

function Game:new()
    local object = setmetatable( {}, self )

	object.run = false

    return object
end

function Game:start()
	Player.inited = false
	Room:load( "start.lua" )
end

function Game:process( delta )
	if self.run and not Menu.run then
		Player:process( delta )
		Objects:process( delta )
	end
	-- UI needs to process even when game doesn't.
	UI:process( delta )

	if Settings.gamepad == nil and RL_IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end
end

function Game:draw()
	if not Room.loaded then
		return
	end

	RL_DrawTexture( Room.bgrImage, Room.bgrImagePos, WHITE )

	RL_SetCamera2DTarget( Camera.camera, Camera.position )

	RL_BeginMode2D( Camera.camera )
		Room:draw()
		Player:draw()
		Objects:draw()
	RL_EndMode2D()

	UI:draw()
end

Game = Game:new()
