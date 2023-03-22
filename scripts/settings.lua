Settings = {}
Settings.__index = Settings

function Settings:new()
	local object = setmetatable( {}, self )

	object.locale = "en"
	object.gamepad = nil
	object.window = {
		monitor = 0,
		scale = 4,
		fullscreen = false,
		vsync = true,
	}
	object.keys = {
		exit = KEY_F8,
		right = KEY_RIGHT,
		left = KEY_LEFT,
		up = KEY_UP,
		down = KEY_DOWN,
		diagonal = KEY_LEFT_SHIFT,
		jump = KEY_X,
		shoot = KEY_C,
		menu = KEY_ESCAPE,
	}
	object.buttons = {
		right = GAMEPAD_BUTTON_LEFT_FACE_RIGHT,
		left = GAMEPAD_BUTTON_LEFT_FACE_LEFT,
		up = GAMEPAD_BUTTON_LEFT_FACE_UP,
		down = GAMEPAD_BUTTON_LEFT_FACE_DOWN,
		diagonal = GAMEPAD_BUTTON_LEFT_TRIGGER_1,
		jump = GAMEPAD_BUTTON_RIGHT_FACE_RIGHT,
		shoot = GAMEPAD_BUTTON_RIGHT_FACE_DOWN,
		menu = GAMEPAD_BUTTON_MIDDLE_RIGHT,
	}

    return object
end

function Settings:init()
	local path = RL_GetBasePath().."settings.lua"

	if not RL_FileExists( path ) then
		RL_TraceLog( LOG_WARNING, "Cannot find default settings" )
		return
	end

	RL_SetTargetFPS( 60 )
	-- RL_SetTargetFPS( 50 )
	-- RL_SetTargetFPS( 30 )
	-- RL_SetTargetFPS( 10 )
	-- RL_SetTargetFPS( 120 )
	-- RL_SetTargetFPS( 600 )
	
	local confFile = dofile( path )

	self.locale = confFile.locale
	self.window = confFile.window
	self.keys = confFile.keys
	self.buttons = confFile.buttons
end

function Settings:writeToFile()
	local file = io.open( RL_GetBasePath().."settings.lua", "w" )

	-- Locale.
	file:write( "return{\nlocale='"..Settings.locale.."',\n" )

	--Window.
	file:write( "window={\n" )
	file:write( "monitor="..Settings.window.monitor..",\n" )
	file:write( "scale="..Settings.window.scale..",\n" )
	file:write( "fullscreen="..tostring( Settings.window.fullscreen )..",\n" )
	file:write( "vsync="..tostring( Settings.window.vsync )..",\n" )
	
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

	-- Close settings.
	file:write( "}\n" )

	file:close()
end

Settings = Settings:new()
