Menu = {}
Menu.__index = Menu

Menu.PAGE = {
	MAIN = { "start", "options", "quit" },
	OPTIONS = { "monitor", "scale", "fullscreen", "vsync", "back" },
	GAMES = {},
}
Menu.ITEM_SPACING = 4
Menu.ITEM_START_POS = Vec2:new( 140, 128 )

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

	local titleSize = Vec2:new( RL_MeasureText( 0, self.title, 20, 2 ) )

	self.titleRect = Rect:new(
		Window.FRAMEBUFFER_SIZE.x / 2 - titleSize.x / 2,
		Window.FRAMEBUFFER_SIZE.y / 2 - titleSize.y / 2 - 30,
		titleSize.x,
		titleSize.y
	)
end

function Menu:process( delta )
	local menuPressed = RL_IsKeyPressed( Settings.keys.menu ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.menu ) )

	if Game.run and menuPressed then
		self.run = not self.run
	end

	if not self.run then
		return
	end

	local upPressed = RL_IsKeyPressed( Settings.keys.up ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.up ) )
	local downPressed = RL_IsKeyPressed( Settings.keys.down ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.down ) )
	local leftPressed = RL_IsKeyPressed( Settings.keys.left ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.left ) )
	local rightPressed = RL_IsKeyPressed( Settings.keys.right ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.right ) )
	local shootPressed = RL_IsKeyPressed( Settings.keys.shoot ) or ( Settings.gamepad ~= nil and RL_IsGamepadButtonPressed( Settings.gamepad, Settings.buttons.shoot ) )

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
			RL_CloseWindow()
		elseif item == "fullscreen" then
			Window:setFullscreen( not Settings.window.fullscreen )
		elseif item == "vsync" then
			Settings.window.vsync = not Settings.window.vsync
			Window:updateVSync()
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
		end
	end
end

function Menu:draw()
	if not self.run then
		return
	end

	-- Title.
	RL_DrawText( 0, Resources.locale.spaceWarMan, self.titleRect, 20, 2, DARKGREEN )

	-- Selections.
	local pos = self.ITEM_START_POS:clone()
	
	for i, item in ipairs( self.page ) do
		local color = DARKGREEN

		if i == self.selected then
			color = GREEN
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
		end

		RL_DrawText( 0, itemText, pos, UI.FONT_SIZE, UI.SPACING, color )

		pos.y = pos.y + UI.FONT_SIZE + self.ITEM_SPACING
	end
end

Menu = Menu:new()
