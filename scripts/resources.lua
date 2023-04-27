Resources = {}
Resources.__index = Resources

function Resources:new()
	local object = setmetatable( {}, self )

	object.locale = {} -- Strings.
	object.textures = {}
	object.sounds = {}
	object.music = {}

    return object
end

function Resources:init()
	RL.SetExitKey( Settings.keys.exit )

	self:loadLocale()

	local prefix = RL.GetBasePath().."images/"

	self:loadTexture( "tileset", prefix.."oga-swm-tiles-alpha.png" )
	self:loadTexture( "player", prefix.."oga-swm-mainchar-sheet-alpha.png" )
	self:loadTexture( "ObjectsAndEnemies", prefix.."oga-swm-objectsandenemies-sheet-alpha.png" )
	self:loadTexture( "effects", prefix.."oga-swm-fx-sheet-alpha.png" )
	self:loadTexture( "desertBgr", prefix.."desertbg-pal00.png" )

	prefix = RL.GetBasePath().."sounds/"

	self:loadSound( "shoot", prefix.."shoot.wav" )
	self:loadSound( "jump", prefix.."jump.wav" )
	self:loadSound( "land", prefix.."land.wav" )
	self:loadSound( "hit", prefix.."hit.wav" )
	self:loadSound( "hit2", prefix.."hit2.wav" )
	self:loadSound( "hit3", prefix.."hit3.wav" )
	self:loadSound( "exlosion", prefix.."exlosion.wav" )
	self:loadSound( "pickup", prefix.."pickup.wav" )
	self:loadSound( "powerUp", prefix.."powerUp.wav" )

	prefix = RL.GetBasePath().."music/"

	self:loadMusic( "title", prefix.."Juhani Junkala [Retro Game Music Pack] Title Screen.ogg" )
	self:loadMusic( "level1", prefix.."Juhani Junkala [Retro Game Music Pack] Level 1.ogg" )

	Settings:update_master_volume()
	Settings:update_sound_volume()
	Settings:update_music_volume()
end

function Resources:loadLocale()
	local path = RL.GetBasePath().."locale/"..Settings.locale..".lua"

	self.locale = dofile( path )
end

function Resources:loadTexture( name, path )
	self.textures[ name ] = RL.LoadTexture( path )
end

function Resources:loadSound( name, path )
	self.sounds[ name ] = RL.LoadSound( path )
end

function Resources:loadMusic( name, path )
	self.music[ name ] = RL.LoadMusicStream( path )
end

Resources = Resources:new()
