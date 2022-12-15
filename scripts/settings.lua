Settings = {}
Settings.__index = Settings

function Settings:new()
	local object = setmetatable( {}, self )

	object.locale = "en"
	object.window = {
		monitor = 0,
		scale = 4,
		fullscreen = false,
		vsync = true,
	}
	object.keys = {
		exit = KEY_ESCAPE,
		right = KEY_RIGHT,
		left = KEY_LEFT,
		jump = KEY_SPACE,
	}

    return object
end

function Settings:init()
	local path = RL_GetBasePath().."settings.lua"

	if not RL_FileExists( path ) then
		RL_TraceLog( LOG_WARNING, "Cannot find default settings" )
		return
	end

	local confFile = dofile( path )

	self.locale = confFile.locale
	self.window = confFile.window
	self.keys = confFile.keys
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
	
	file:write( "},\n},\n" )

	-- Keys.
	file:write( "keys={\n" )

	for name, key in pairs( Settings.keys ) do
		file:write( name.."="..key..",\n" )
	end

	file:write( "},\n" )

	-- Close settings.
	file:write( "}\n" )

	file:close()
end

Settings = Settings:new()
