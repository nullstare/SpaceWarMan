Camera = {}
Camera.__index = Camera

function Camera:new()
	local object = setmetatable( {}, self )

	object.camera = RL.CreateCamera2D()
	object.position = Vec2:new()
	object.offset = Vec2:new( Window.FRAMEBUFFER_SIZE.x / 2, Window.FRAMEBUFFER_SIZE.y / 2 )

	RL.SetCamera2DOffset( object.camera, object.offset )

    return object
end

function Camera:setPosition( pos )
	self.position.x = Util.clamp(
		Util.round( pos.x ),
		Window.FRAMEBUFFER_SIZE.x / 2,
		Room.data.width * TILE_SIZE - Window.FRAMEBUFFER_SIZE.x / 2
	)
	self.position.y = Util.clamp(
		Util.round( pos.y ),
		Window.FRAMEBUFFER_SIZE.y / 2,
		Room.data.height * TILE_SIZE - Window.FRAMEBUFFER_SIZE.y / 2
	)
end

Camera = Camera:new()
