Settings = {}
Settings.__index = Settings

function Settings:new()
	local object = setmetatable( {}, self )

	object.language = 1
	object.gamepad = nil
	object.window = {
		monitor = 0,
		scale = 4,
		fullscreen = false,
		vsync = true,
	}
	object.audio = {
		masterVolume = 1.0,
		soundVolume = 1.0,
		musicVolume = 1.0,
	}
	object.keys = {
		exit = RL.KEY_F8,
		right = RL.KEY_RIGHT,
		left = RL.KEY_LEFT,
		up = RL.KEY_UP,
		down = RL.KEY_DOWN,
		diagonal = RL.KEY_LEFT_SHIFT,
		jump = RL.KEY_X,
		shoot = RL.KEY_C,
		menu = RL.KEY_ESCAPE,
	}
	object.buttons = {
		right = RL.GAMEPAD_BUTTON_LEFT_FACE_RIGHT,
		left = RL.GAMEPAD_BUTTON_LEFT_FACE_LEFT,
		up = RL.GAMEPAD_BUTTON_LEFT_FACE_UP,
		down = RL.GAMEPAD_BUTTON_LEFT_FACE_DOWN,
		diagonal = RL.GAMEPAD_BUTTON_LEFT_TRIGGER_1,
		jump = RL.GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,
		shoot = RL.GAMEPAD_BUTTON_RIGHT_FACE_DOWN,
		menu = RL.GAMEPAD_BUTTON_MIDDLE_RIGHT,
	}
	object.debug = {
		showFPS = false,
		showHitboxes = false,
	}

    return object
end

function Settings:init()
	local path = RL.GetBasePath().."settings.lua"

	if not RL.FileExists( path ) then
		RL.TraceLog( RL.LOG_WARNING, "Cannot find default settings" )
		return
	end

	-- For testing framerate independence.
	-- RL.SetTargetFPS( 15 )
	-- RL.SetTargetFPS( 30 )
	-- RL.SetTargetFPS( 60 )
	-- RL.SetTargetFPS( 120 )

	local confFile = dofile( path )

	self.language = confFile.language
	self.window = confFile.window
	self.audio = confFile.audio
	self.keys = confFile.keys
	self.buttons = confFile.buttons
	self.debug = confFile.debug
end

function Settings:writeToFile()
	local file = io.open( RL.GetBasePath().."settings.lua", "w" )

	if file == nil then
		return
	end

	-- language.
	file:write( "return{\nlanguage="..Settings.language..",\n" )

	-- Window.
	file:write( "window={\n" )
	file:write( "monitor="..Settings.window.monitor..",\n" )
	file:write( "scale="..Settings.window.scale..",\n" )
	file:write( "fullscreen="..tostring( Settings.window.fullscreen )..",\n" )
	file:write( "vsync="..tostring( Settings.window.vsync )..",\n" )

	file:write( "},\n" )

	-- Audio.
	file:write( "audio={\n" )
	file:write( "masterVolume="..Settings.audio.masterVolume..",\n" )
	file:write( "soundVolume="..Settings.audio.soundVolume..",\n" )
	file:write( "musicVolume="..Settings.audio.musicVolume..",\n" )

	file:write( "},\n" )

	-- Keys.
	file:write( "keys={\n" )

	for name, key in pairs( Settings.keys ) do
		file:write( name.."="..key..",\n" )
	end

	file:write( "},\n" )

	-- Buttons.
	file:write( "buttons={\n" )

	for name, button in pairs( Settings.buttons ) do
		file:write( name.."="..button..",\n" )
	end

	file:write( "},\n" )

	-- Debug
	file:write( "debug={\n" )
	file:write( "showFPS="..tostring( Settings.debug.showFPS )..",\n" )
	file:write( "showHitboxes="..tostring( Settings.debug.showHitboxes )..",\n" )
	file:write( "},\n" )

	-- Close settings.
	file:write( "}\n" )

	file:close()
end

function Settings:updateMasterVolume()
	RL.SetMasterVolume( self.audio.masterVolume )
end

function Settings:updateSoundVolume()
	for _, sound in pairs( Resources.sounds ) do
		RL.SetSoundVolume( sound, self.audio.soundVolume )
	end
end

function Settings:updateMusicVolume()
	for _, music in pairs( Resources.music ) do
		RL.SetMusicVolume( music, self.audio.musicVolume )
	end
end

Settings = Settings:new()
