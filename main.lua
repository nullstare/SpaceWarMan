package.path = package.path..";"..RL.GetBasePath().."libs/?.lua"
package.path = package.path..";"..RL.GetBasePath().."?.lua"

Util = require( "utillib" )
Vec2 = require( "vector2" )
Rect = require( "rectangle" )
Color = require( "color" )

-- Define global constants.
TILE_SIZE = 8

require( "scripts/input" )
require( "scripts/settings" )
require( "scripts/resources" )
require( "scripts/window" )
require( "scripts/game" )
require( "scripts/ui" )
require( "scripts/menu" )
require( "scripts/room" )
require( "scripts/camera" )
require( "scripts/sprite" )
require( "scripts/player" )
require( "scripts/entities" )

function RL.init()
	RL.InitAudioDevice()

	Settings:init()
	Resources:init()
	Window:init()
	Menu:init()
end

function RL.update( delta )
	Input:update()
	Window:update( delta )
	Game:update( delta )
	Menu:update( delta )
end

function RL.draw()
	Window:draw()
end

function RL.exit()
	RL.CloseAudioDevice()
end
