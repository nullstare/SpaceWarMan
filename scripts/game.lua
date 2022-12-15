Game = {}
Game.__index = Game

function Game:new()
    local object = setmetatable( {}, self )

    return object
end

function Game:start()
	Room:load( "room01.lua" )
end

function Game:process( delta )
	if Player.ready then
		Player:process( delta )
		Bullets:process( delta )
	end
end

function Game:draw()
	RL_SetCamera2DTarget( Camera.camera, Camera.position )

	RL_BeginMode2D( Camera.camera )
		Room:draw()
		Player:draw()
		Bullets:draw()
	RL_EndMode2D()
end

Game = Game:new()
