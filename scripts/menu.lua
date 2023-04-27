Menu = {}
Menu.__index = Menu

Menu.PAGE = {
	MAIN = { "start", "options", "quit" },
	OPTIONS = { "monitor", "scale", "fullscreen", "vsync", "master_volume", "sound_volume", "music_volume", "showFPS", "back" },
	GAMES = {},
}
Menu.ITEM_SPACING = 4
-- Menu.ITEM_START_POS = Vec2:new( 140, 128 )
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
	self.title = Resources.locale.spaceWarMan

	local titleSize = Vec2:new( RL.MeasureText( 0, self.title, 20, 2 ) )

	self.titleRect = Rect:new(
		Window.FRAMEBUFFER_SIZE.x / 2 - titleSize.x / 2,
		Window.FRAMEBUFFER_SIZE.y / 2 - titleSize.y / 2 - 64,
		titleSize.x,
		titleSize.y
	)

	RL.PlayMusicStream( Resources.music.title )
end

local function adjust_volume( setting, adjust )
	Settings.audio[ setting ] = Util.clamp( Settings.audio[ setting ] + adjust, 0.0, 1.0 )
	-- A bit of a hack.
	Settings[ "update_"..setting ]( Settings )
end

function Menu:process( delta )
	local menuPressed = RL.IsKeyPressed( Settings.keys.menu )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.menu ) )

	if Game.run and menuPressed then
		self.run = not self.run
	end

	if not self.run then
		return
	end

	local upPressed = RL.IsKeyPressed( Settings.keys.up )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.up ) )

	local downPressed = RL.IsKeyPressed( Settings.keys.down )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.down ) )

	local leftPressed = RL.IsKeyPressed( Settings.keys.left )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.left ) )

	local rightPressed = RL.IsKeyPressed( Settings.keys.right )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.right ) )

	local shootPressed = RL.IsKeyPressed( Settings.keys.shoot )
	or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

	if upPressed then
		self.selected = self.selected - 1

		if self.selected <= 0 then
			self.selected = #self.page
		end
	elseif downPressed then
		self.selected = self.selected + 1

		if #self.page < self.selected then
			self.selected = 1
		end
	end

	local item = self.page[ self.selected ]

	if shootPressed then
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
	elseif rightPressed then
		if item == "monitor" and Settings.window.monitor + 1 < Window.monitorCount then
			Settings.window.monitor = Settings.window.monitor + 1
			Window:init()
		elseif item == "scale" then
			Settings.window.scale = Settings.window.scale + 1

			if not Settings.window.fullscreen then
				Window:init()
			end
		elseif item == "master_volume" or item == "sound_volume" or item == "music_volume" then
			adjust_volume( item, self.VOLUME_ADJUST_INCREMENT )
		end
	elseif leftPressed then
		if item == "monitor" and 0 < Settings.window.monitor then
			Settings.window.monitor = Settings.window.monitor - 1
			Window:init()
		elseif item == "scale" then
			Settings.window.scale = Settings.window.scale - 1

			if not Settings.window.fullscreen then
				Window:init()
			end
		elseif item == "master_volume" or item == "sound_volume" or item == "music_volume" then
			adjust_volume( item, -self.VOLUME_ADJUST_INCREMENT )
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
	RL.DrawText( 0, Resources.locale.spaceWarMan, self.titleRect, 20, 2, RL.DARKGREEN )

	-- Selections.
	local pos = self.ITEM_START_POS:clone()

	for i, item in ipairs( self.page ) do
		local color = RL.DARKGREEN

		if i == self.selected then
			color = RL.GREEN
		end

		local itemText = Resources.locale[ item ]

		if item == "monitor" then
			itemText = itemText.." "..Settings.window.monitor
		elseif item == "scale" then
			itemText = itemText.." "..Settings.window.scale
		elseif item == "fullscreen" then
			itemText = itemText.." "..tostring( Settings.window.fullscreen )
		elseif item == "vsync" then
			itemText = itemText.." "..tostring( Settings.window.vsync )
		elseif item == "master_volume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.master_volume * 100 ) ).."%"
		elseif item == "sound_volume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.sound_volume * 100 ) ).."%"
		elseif item == "music_volume" then
			itemText = itemText.." "..tostring( Util.round( Settings.audio.music_volume * 100 ) ).."%"
		elseif item == "showFPS" then
			itemText = itemText.." "..tostring( Settings.debug.showFPS )
		end

		RL.DrawText( 0, itemText, pos, UI.FONT_SIZE, UI.SPACING, color )

		pos.y = pos.y + UI.FONT_SIZE + self.ITEM_SPACING
	end
end

Menu = Menu:new()
