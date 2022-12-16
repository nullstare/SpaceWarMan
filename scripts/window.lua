Window = {}
Window.__index = Window

Window.FRAMEBUFFER_SIZE = Vec2:new( 320, 256 )

function Window:new()
	local object = setmetatable( {}, self )

	object.monitorPos = {}
	object.monitorSize = {}
	object.size = {}
	object.framebuffer = -1
	object.framebufferRect = Rect:new( 0, 0, object.FRAMEBUFFER_SIZE.x, object.FRAMEBUFFER_SIZE.y )

    return object
end

function Window:init()
	RL_SetWindowTitle( "Space War Man" )
	RL_SetWindowIcon( RL_LoadImage( RL_GetBasePath().."icon.png" ) )
	self.monitorPos = Vec2:new( RL_GetMonitorPosition( Settings.window.monitor ) )
	self.monitorSize = Vec2:new( RL_GetMonitorSize( Settings.window.monitor ) )
	self.size = self.FRAMEBUFFER_SIZE:clone()
	self.framebuffer = RL_LoadRenderTexture( self.FRAMEBUFFER_SIZE )
	self:setFullscreen( Settings.window.fullscreen )
	self:adjustFramebuffer()
end

function Window:adjustFramebuffer()
	self.framebufferRect.height = self.size.y
	self.framebufferRect.width = self.framebufferRect.height * ( self.FRAMEBUFFER_SIZE.x / self.FRAMEBUFFER_SIZE.y )
	self.framebufferRect.x = self.size.x / 2 - self.framebufferRect.width / 2
end

function Window:setFullscreen( fullscreen )
	Settings.window.fullscreen = fullscreen

	if Settings.window.fullscreen then
		RL_ClearWindowState( FLAG_WINDOW_RESIZABLE )
		RL_SetWindowState( FLAG_WINDOW_UNDECORATED )
		RL_SetWindowState( FLAG_WINDOW_TOPMOST )
		RL_SetWindowSize( self.monitorSize )
		RL_SetWindowPosition( self.monitorPos )
		RL_HideCursor()
	else
		self.size = self.FRAMEBUFFER_SIZE:scale( Settings.window.scale )

		RL_ClearWindowState( FLAG_WINDOW_UNDECORATED )
		RL_ClearWindowState( FLAG_WINDOW_TOPMOST )
		RL_SetWindowState( FLAG_WINDOW_RESIZABLE )
		RL_SetWindowSize( self.size )
		RL_SetWindowPosition( { self.monitorPos.x + self.monitorSize.x / 2 - self.size.x / 2,
							    self.monitorPos.y + self.monitorSize.y / 2 - self.size.y / 2 } )
		RL_ShowCursor()
	end

	if Settings.window.vsync then
		RL_SetWindowState( FLAG_VSYNC_HINT )
	end
end

function Window:process( delta )
	if RL_IsWindowResized() then
		self.size = Vec2:new( RL_GetWindowSize() )
		self:adjustFramebuffer()
	end
end

function Window:draw()
	RL_BeginTextureMode( self.framebuffer )
		RL_ClearBackground( BLACK )
		Game:draw()
	RL_EndTextureMode()
		
	RL_ClearBackground( BLACK )
	RL_SetTextureSource( TEXTURE_SOURCE_RENDER_TEXTURE )

	RL_DrawTexturePro( self.framebuffer, { 0, 0, self.FRAMEBUFFER_SIZE.x, -self.FRAMEBUFFER_SIZE.y },
{ self.framebufferRect.x, self.framebufferRect.y, self.framebufferRect.width, self.framebufferRect.height }, { 0, 0 }, 0.0, WHITE )

	RL_SetTextureSource( TEXTURE_SOURCE_TEXTURE )

	-- RL_DrawFPS( { 5, 5 } )
end

Window = Window:new()
