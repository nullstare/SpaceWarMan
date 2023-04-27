Window = {}
Window.__index = Window

Window.FRAMEBUFFER_SIZE = Vec2:new( 320, 256 )

function Window:new()
	local object = setmetatable( {}, self )

	object.monitorCount = RL.GetMonitorCount()
	object.monitorPos = {}
	object.monitorSize = {}
	object.size = {}
	object.framebuffer = -1
	object.framebufferRect = Rect:new( 0, 0, object.FRAMEBUFFER_SIZE.x, object.FRAMEBUFFER_SIZE.y )

    return object
end

function Window:init()
	RL.SetWindowTitle( "Space War Man" )
	RL.SetWindowIcon( RL.LoadImage( RL.GetBasePath().."icon.png" ) )
	self.monitorPos = Vec2:new( RL.GetMonitorPosition( Settings.window.monitor ) )
	self.monitorSize = Vec2:new( RL.GetMonitorSize( Settings.window.monitor ) )
	self.size = self.FRAMEBUFFER_SIZE:clone()
	self.framebuffer = RL.LoadRenderTexture( self.FRAMEBUFFER_SIZE )
	self:setFullscreen( Settings.window.fullscreen )
	self:adjustFramebuffer()
	self:updateVSync()
end

function Window:adjustFramebuffer()
	self.framebufferRect.height = self.size.y
	self.framebufferRect.width = self.framebufferRect.height * ( self.FRAMEBUFFER_SIZE.x / self.FRAMEBUFFER_SIZE.y )
	self.framebufferRect.x = self.size.x / 2 - self.framebufferRect.width / 2
end

function Window:setFullscreen( fullscreen )
	Settings.window.fullscreen = fullscreen

	if Settings.window.fullscreen then
		RL.ClearWindowState( RL.FLAG_WINDOW_RESIZABLE )
		RL.SetWindowState( RL.FLAG_WINDOW_UNDECORATED )
		RL.SetWindowState( RL.FLAG_WINDOW_TOPMOST )
		RL.SetWindowSize( self.monitorSize )
		RL.SetWindowPosition( self.monitorPos )
		RL.HideCursor()
	else
		self.size = self.FRAMEBUFFER_SIZE:scale( Settings.window.scale )

		RL.ClearWindowState( RL.FLAG_WINDOW_UNDECORATED )
		RL.ClearWindowState( RL.FLAG_WINDOW_TOPMOST )
		RL.SetWindowState( RL.FLAG_WINDOW_RESIZABLE )
		RL.SetWindowSize( self.size )
		-- RL.GetScreenSize( self.size )
		RL.SetWindowPosition( { self.monitorPos.x + self.monitorSize.x / 2 - self.size.x / 2,
							    self.monitorPos.y + self.monitorSize.y / 2 - self.size.y / 2 } )
		RL.ShowCursor()
	end
end

function Window:updateVSync()
	if Settings.window.vsync then
		RL.SetWindowState( RL.FLAG_VSYNC_HINT )
	else
		RL.ClearWindowState( RL.FLAG_VSYNC_HINT )
	end
end

function Window:process( delta )
	if RL.IsWindowResized() then
		self.size = Vec2:new( RL.GetScreenSize() )
		self:adjustFramebuffer()
	end
end

function Window:draw()
	Room:updateFramebuffer()

	RL.BeginTextureMode( self.framebuffer )
		RL.ClearBackground( RL.BLACK )
		Game:draw()
		Menu:draw()
	RL.EndTextureMode()

	RL.ClearBackground( RL.BLACK )
	RL.SetTextureSource( RL.TEXTURE_SOURCE_RENDER_TEXTURE )

	RL.DrawTexturePro(
		self.framebuffer,
		{ 0, 0, self.FRAMEBUFFER_SIZE.x, -self.FRAMEBUFFER_SIZE.y },
		{ self.framebufferRect.x, self.framebufferRect.y, self.framebufferRect.width, self.framebufferRect.height },
		{ 0, 0 },
		0.0,
		RL.WHITE
	)

	-- RL.glBlitFramebuffer(
	-- 	self.framebuffer,
	-- 	-1,
	-- 	{ 0, 0, self.FRAMEBUFFER_SIZE.x, self.FRAMEBUFFER_SIZE.y },
	-- 	-- { 0, 0, self.size.x, self.size.y },
	-- 	{ self.framebufferRect.x, self.framebufferRect.y, self.framebufferRect.width, self.framebufferRect.height },
	-- 	RL.GL_COLOR_BUFFER_BIT,
	-- 	RL.GL_NEAREST
	-- )

	RL.SetTextureSource( RL.TEXTURE_SOURCE_TEXTURE )

	if Settings.debug.showFPS then
		RL.DrawFPS( { 5, 5 } )
	end
end

Window = Window:new()
