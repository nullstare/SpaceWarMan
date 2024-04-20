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
	-- Player.inited = false
	Player:reset()
	Room:load( "start.lua" )

	RL.PlayMusicStream( Resources.music.level1 )
end

function Game:update( delta )
	if self.run and not Menu.run then
		Player:update( delta )
		Entities:update( delta )
		self:physicsUpdate( delta )
	end
	-- UI needs to update even when game doesn't.
	UI:update( delta )

	if Settings.gamepad == nil and RL.IsGamepadAvailable( 0 ) then
		Settings.gamepad = 0
	end

	if Player.inited then
		RL.UpdateMusicStream( Resources.music.level1 )
	end
end

function Game:physicsUpdate( delta )
	self.physicsAccumulator = self.physicsAccumulator + delta

	local steps = math.floor( self.physicsAccumulator / self.physicsDelta )

	for i = 0, steps - 1 do
		Player:physicsUpdate( self.physicsDelta, i )
		Entities:physicsUpdate( self.physicsDelta, i )

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
		Entities:draw()
	RL.EndMode2D()

	UI:draw()

	-- Dim game while in menu.
	if Menu.run then
		RL.DrawRectangle( { 0, 0, Window.FRAMEBUFFER_SIZE.x, Window.FRAMEBUFFER_SIZE.y }, { 0, 0, 0, 170 } )
	end
end

Game = Game:new()
