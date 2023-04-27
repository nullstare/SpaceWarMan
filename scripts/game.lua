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

	RL.PlayMusicStream( Resources.music.level1 )
end

function Game:process( delta )
	if self.run and not Menu.run then
		Player:process( delta )
		ECS:process( delta )
		self:physicsProcess( delta )
	end
	-- UI needs to process even when game doesn't.
	UI:process( delta )

	if Settings.gamepad == nil and RL.IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end

	if Player.inited then
		RL.UpdateMusicStream( Resources.music.level1 )
	end
end

function Game:physicsProcess( delta )
	self.physicsAccumulator = self.physicsAccumulator + delta

	local steps = math.floor( self.physicsAccumulator / self.physicsDelta )

	for i = 0, steps - 1 do
		Player:physicsProcess( self.physicsDelta, i )
		ECS:physicsProcess( self.physicsDelta, i )

		self.physicsAccumulator = self.physicsAccumulator - self.physicsDelta
	end
end

function Game:draw()
	if not Room.loaded then
		return
	end

	RL.DrawTexture( Room.bgrImage, Room.bgrImagePos, RL.WHITE )
	RL.SetCamera2DTarget( Camera.camera, Camera.position )

	RL.BeginMode2D( Camera.camera )
		Room:draw()
		Player:draw()
		ECS:draw()
	RL.EndMode2D()

	UI:draw()
end

Game = Game:new()
