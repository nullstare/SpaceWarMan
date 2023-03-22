Game = {}
Game.__index = Game

function Game:new()
    local object = setmetatable( {}, self )

	object.run = false
	object.physics_delta = 1 / 60
	object.physics_accumulator = 0.0

    return object
end

function Game:start()
	Player.inited = false
	Room:load( "start.lua" )
end

function Game:process( delta )
	if self.run and not Menu.run then
		self:physics_process( delta )
		Player:process( delta )
		Objects:process( delta )
	end
	-- UI needs to process even when game doesn't.
	UI:process( delta )

	if Settings.gamepad == nil and RL_IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end
end

function Game:physics_process( delta )
	self.physics_accumulator = self.physics_accumulator + delta

	local steps = math.floor( self.physics_accumulator / self.physics_delta )
	-- print( "steps", steps )

	for i = 0, steps - 1 do
		-- print( "i", i )
		-- print( "self.physics_accumulator", self.physics_accumulator )
		Player:physics_process( self.physics_delta, i )

		self.physics_accumulator = self.physics_accumulator - self.physics_delta
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
