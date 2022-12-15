Resources = {}
Resources.__index = Resources

function Resources:new()
	local object = setmetatable( {}, self )

	object.locale = {} -- Strings.
	object.textures = {}

    return object
end

function Resources:init()
	RL_SetExitKey( Settings.keys.exit )

	self:loadLocale()

	local prefix = RL_GetBasePath().."images/"

	self:loadTexture( "mockup", prefix.."mockup.png" )
	self:loadTexture( "tileset", prefix.."oga-swm-tiles-alpha.png" )
	self:loadTexture( "player", prefix.."oga-swm-mainchar-sheet-alpha.png" )
	self:loadTexture( "objectsAndEnemies", prefix.."oga-swm-objectsandenemies-sheet-alpha.png" )
end

function Resources:loadLocale()
	local path = RL_GetBasePath().."locale/"..Settings.locale..".lua"

	self.locale = dofile( path )
end

function Resources:loadTexture( name, path )
	self.textures[ name ] = RL_LoadTexture( path )
end

Resources = Resources:new()
