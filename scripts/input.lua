Input = {}
Input.__index = Input

Input.INPUTS = { "right", "left", "up", "down", "diagonal", "jump", "shoot", "menu" }

function Input:new()
	local object = setmetatable( {}, self )
	
	object.pressed = {}
	object.down = {}

	return object
end

function Input:process()
	for _, input in ipairs( self.INPUTS ) do
		self.pressed[ input ] = RL.IsKeyPressed( Settings.keys[ input ] )
		or ( Settings.gamepad ~= nil and RL.IsGamepadButtonPressed( Settings.gamepad, Settings.buttons[ input ] ) )

		self.down[ input ] = RL.IsKeyDown( Settings.keys[ input ] )
		or ( Settings.gamepad ~= nil and RL.IsGamepadButtonDown( Settings.gamepad, Settings.buttons[ input ] ) )
	end

	--[[
		Jump is handled in physics_process that will run fewer times than process on high frame rates. We will only set
		input true here to prevent eating inputs and will set Player.jumpPressed to false when input is handled.
	]]--
	if self.pressed.jump then
		Player.jumpPressed = true
	end
end

Input = Input:new()