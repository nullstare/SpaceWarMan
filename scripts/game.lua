Game = {}
Game.__index = Game

function Game:new()
    local object = setmetatable( {}, self )

	object.run = false
	object.physicsDelta = 1 / 60
	object.physicsAccumulator = 0.0

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
		self:physicsProcess( delta )
	end
	-- UI needs to process even when game doesn't.
	UI:process( delta )

	if Settings.gamepad == nil and RL_IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end
end

function Game:physicsProcess( delta )
	self.physicsAccumulator = self.physicsAccumulator + delta

	local steps = math.floor( self.physicsAccumulator / self.physicsDelta )

	for i = 0, steps - 1 do
		Player:physicsProcess( self.physicsDelta, i )
		Objects:physicsProcess( self.physicsDelta, i )

		self.physicsAccumulator = self.physicsAccumulator - self.physicsDelta
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
