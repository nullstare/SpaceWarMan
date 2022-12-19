Resources = {}
Resources.__index = Resources

function Resources:new()
	local object = setmetatable( {}, self )

	object.locale = {} -- Strings.
	object.textures = {}
	object.sounds = {}

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
	self:loadTexture( "effects", prefix.."oga-swm-fx-sheet-alpha.png" )
	self:loadTexture( "desertBgr", prefix.."desertbg-pal00.png" )

	prefix = RL_GetBasePath().."sounds/"

	self:loadSound( "shoot", prefix.."shoot.wav"  )
	self:loadSound( "jump", prefix.."jump.wav"  )
	self:loadSound( "land", prefix.."land.wav"  )
	self:loadSound( "hit", prefix.."hit.wav"  )
	self:loadSound( "hit2", prefix.."hit2.wav"  )
	self:loadSound( "hit3", prefix.."hit3.wav"  )
	self:loadSound( "exlosion", prefix.."exlosion.wav"  )
end

function Resources:loadLocale()
	local path = RL_GetBasePath().."locale/"..Settings.locale..".lua"

	self.locale = dofile( path )
end

function Resources:loadTexture( name, path )
	self.textures[ name ] = RL_LoadTexture( path )
end

function Resources:loadSound( name, path )
	self.sounds[ name ] = RL_LoadSound( path )
end

Resources = Resources:new()
