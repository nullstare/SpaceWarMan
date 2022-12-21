package.path = package.path..";"..RL_GetBasePath().."libs/?.lua"
package.path = package.path..";"..RL_GetBasePath().."?.lua"

util = require( "utillib" )
Vec2 = require( "vector2" )
Rect = require( "rectangle" )
Color = require( "color" )

require( "scripts/settings" )
require( "scripts/resources" )
require( "scripts/window" )
require( "scripts/game" )
require( "scripts/room" )
require( "scripts/camera" )
require( "scripts/sprite" )
require( "scripts/player" )
require( "scripts/objects" )

-- Define global constants.
TILE_SIZE = 8

function init()
	Settings:init()
	Resources:init()
	Window:init()

	Game:start()
end

function process( delta )
	Window:process( delta )
	Game:process( delta )
end

function draw()
	Window:draw()
end
