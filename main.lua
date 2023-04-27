package.path = package.path..";"..RL.GetBasePath().."libs/?.lua"
package.path = package.path..";"..RL.GetBasePath().."?.lua"

Util = require( "utillib" )
Vec2 = require( "vector2" )
Rect = require( "rectangle" )
Color = require( "color" )

-- Define global constants.
TILE_SIZE = 8

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
require( "scripts/ECS" )

function RL.init()
	Settings:init()
	Resources:init()
	Window:init()
	Menu:init()
end

function RL.process( delta )
	Window:process( delta )
	Game:process( delta )
	Menu:process( delta )
end

function RL.draw()
	Window:draw()
end
