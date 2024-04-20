Menu = {}
Menu.__index = Menu

Menu.PAGE = {
	MAIN = { "start", "options", "quit" },
	OPTIONS = { "language", "monitor", "scale", "fullscreen", "vsync", "masterVolume", "soundVolume", "musicVolume", "showFPS", "back" },
	GAMES = {},
}
Menu.ITEM_SPACING = 4
Menu.ITEM_START_POS = Vec2:new( 140, 96 )
Menu.VOLUME_ADJUST_INCREMENT = 0.1

function Menu:new()
    local object = setmetatable( {}, self )

	object.run = true
	object.page = self.PAGE.MAIN
	object.selected = 1

	object.title = nil
	object.titleRect = nil

    return object
end

function Menu:init()
	self.title = Resources.language.spaceWarMan

	local titleSize = Vec2:newT( RL.MeasureTextEx( RL.GetFontDefault(), self.title, 20, 2 ) )

	self.titleRect = Rect:new(
		Window.FRAMEBUFFER_SIZE.x / 2 - titleSize.x / 2,
		Window.FRAMEBUFFER_SIZE.y / 2 - titleSize.y / 2 - 64,
		titleSize.x,
		titleSize.y
	)

	RL.PlayMusicStream( Resources.music.title )
end

local function adjustVolume( setting, adjust )
	Settings.audio[ setting ] = Util.clamp( Settings.audio[ setting ] + adjust, 0.0, 1.0 )
	-- A bit of a hack to call settings update*Volume functions.
	setting = setting:sub( 1, 1 ):upper()..setting:sub( 2 ) -- First char to upper.
	Settings[ "update"..setting ]( Settings )
end

local function boolString( bool )
	if bool then
		return Resources.language.bool_true
	else
		return Resources.language.bool_false
	end
end

function Menu:update( delta )
	local menuPressed = RL.IsKeyPressed( Settings.keys.menu )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.menu ) )

	if Game.run and menuPressed then
		self.run = not self.run
	end

	if not self.run then
		return
	end

	if Input.pressed.up then
		self.selected = self.selected - 1

		if self.selected <= 0 then
			self.selected = #self.page
		end
	elseif Input.pressed.down then
		self.selected = self.selected + 1

		if #self.page < self.selected then
			self.selected = 1
		end
	end

	local item = self.page[ self.selected ]

	if Input.pressed.shoot then
		if item == "start" then
			self.run = false
			Game:start()
		elseif item == "options" then
			self.page = self.PAGE.OPTIONS
		elseif item == "quit" then
			RL.CloseWindow()
		elseif item == "fullscreen" then
			Window:setFullscreen( not Settings.window.fullscreen )
		elseif item == "vsync" then
			Settings.window.vsync = not Settings.window.vsync
			Window:updateVSync()
		elseif item == "showFPS" then
			Settings.debug.showFPS = not Settings.debug.showFPS
		elseif item == "back" then
			self.page = self.PAGE.MAIN
			self.selected = 2
			Settings:writeToFile()
		end
	elseif Input.pressed.right then
		if item == "monitor" and Settings.window.monitor + 1 < Window.monitorCount then
			Settings.window.monitor = Settings.window.monitor + 1
			Window:init()
		elseif item == "scale" then
			Settings.window.scale = Settings.window.scale + 1

			if not Settings.window.fullscreen then
				Window:init()
			end
		elseif item == "language" then
			Settings.language = Settings.language + 1

			if #Resources.LANGUAGES < Settings.language then
				Settings.language = 1
			end
			Resources:loadLanguage()
		elseif item == "masterVolume" or item == "soundVolume" or item == "musicVolume" then
			adjustVolume( item, self.VOLUME_ADJUST_INCREMENT )
		end
	elseif Input.pressed.left then
		if item == "monitor" and 0 < Settings.window.monitor then
			Settings.window.monitor = Settings.window.monitor - 1
			Window:init()
		elseif item == "language" then
			Settings.language = Settings.language - 1

			if Settings.language < 1 then
				Settings.language = #Resources.LANGUAGES
			end
			Resources:loadLanguage()
		elseif item == "scale" then
			Settings.window.scale = math.max( 1, Settings.window.scale - 1 )

			if not Settings.window.fullscreen then
				Window:init()
			end
		elseif item == "masterVolume" or item == "soundVolume" or item == "musicVolume" then
			adjustVolume( item, -self.VOLUME_ADJUST_INCREMENT )
		end
	end

	if not Player.inited then
		RL.UpdateMusicStream( Resources.music.title )
	end
end

function Menu:draw()
	if not self.run then
		return
	end

	-- Title.
	RL.DrawTextEx( RL.GetFontDefault(), Resources.language.spaceWarMan, self.titleRect, 20, 2, RL.DARKGREEN )

	-- Selections.
	local pos = self.ITEM_START_POS:clone()

	for i, item in ipairs( self.page ) do
		local color = RL.DARKGREEN

		if i == self.selected then
			color = RL.GREEN
		end

		local itemText = Resources.language[ item ]

		if item == "language" then
			itemText = itemText.." "..Resources.language[ Resources.LANGUAGES[ Settings.language ] ]
		elseif item == "monitor" then
			itemText = itemText.." "..Settings.window.monitor
		elseif item == "scale" then
			itemText = itemText.." "..Settings.window.scale
		elseif item == "fullscreen" then
			itemText = itemText.." "..boolString( Settings.window.fullscreen )
		elseif item == "vsync" then
			-- itemText = itemText.." "..tostring( Settings.window.vsync )
			itemText = itemText.." "..boolString( Settings.window.vsync )
		elseif item == "masterVolume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.masterVolume * 100 ) ).."%"
		elseif item == "soundVolume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.soundVolume * 100 ) ).."%"
		elseif item == "musicVolume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.musicVolume * 100 ) ).."%"
		elseif item == "showFPS" then
			itemText = itemText.." "..boolString( Settings.debug.showFPS )
		end

		RL.DrawTextEx( RL.GetFontDefault(), itemText, pos, UI.FONT_SIZE, UI.SPACING, color )

		pos.y = pos.y + UI.FONT_SIZE + self.ITEM_SPACING
	end
end

Menu = Menu:new()
