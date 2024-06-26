Room = {}
Room.__index = Room

-- Render size of screen in tiles.
Room.TILE_RENDER_SIZE = Vec2:new(
	math.ceil( Window.FRAMEBUFFER_SIZE.x / TILE_SIZE ) + 1,
	math.ceil( Window.FRAMEBUFFER_SIZE.y / TILE_SIZE ) + 1
)
Room.TILE_FRAMEBUFFER_SIZE = Vec2:new(
	( Room.TILE_RENDER_SIZE.x + 1 ) * TILE_SIZE,
	( Room.TILE_RENDER_SIZE.y + 1 ) * TILE_SIZE
)
Room.GRAVITY = 6

function Room:new()
    local object = setmetatable( {}, self )

	object.loaded = false
	object.data = {}
	object.wallTiles = {}
	object.bgrTiles = {}
	object.bgrTiles2 = {}
	object.tileTexture = nil
	object.tileTextureSize = Vec2:new()
	object.tileTextureTileSize = Vec2:new()
	object.bgrImage = nil
	object.bgrImagePos = Vec2:new()
	object.transitions = { left = nil, right = nil, up = nil, down = nil } -- Correspond to Room.TRANSITION.

	object.tilemapFramebuffer = RL.LoadRenderTexture( Room.TILE_FRAMEBUFFER_SIZE )
	object.updateTilePos = Vec2:new( -1, -1 )

    return object
end

function Room:load( name )
	self:clear()

	self.tileTexture = Resources.textures.tileset
	self.tileTextureSize = Vec2:newT( RL.GetTextureSize( self.tileTexture ) )
	self.tileTextureTileSize = Vec2:new( self.tileTextureSize.x / TILE_SIZE, self.tileTextureSize.y / TILE_SIZE )
	self.data = dofile( RL.GetBasePath().."maps/"..name )

	-- Set properties.

	self.bgrImage = Resources.textures[ self.data.properties.bgrImage ]
	self.bgrImagePos.x = self.data.properties.bgrImageX
	self.bgrImagePos.y = self.data.properties.bgrImageY

	-- Transitions.

	self.transitions.left = self.data.properties.roomLeft
	self.transitions.right = self.data.properties.roomRight
	self.transitions.up = self.data.properties.roomUp
	self.transitions.down = self.data.properties.roomDown

	-- Load tile data.

	for x = 1, self.data.width do
		table.insert( self.wallTiles, {} )
		table.insert( self.bgrTiles, {} )
		table.insert( self.bgrTiles2, {} )

		for y = 1, self.data.height do
			local i = (x-1) + (y-1) * self.data.width + 1

			for _, layer in ipairs( self.data.layers ) do
				if layer.name == "walls" then
					table.insert( self.wallTiles[x], layer.data[i] )
				elseif layer.name == "background" then
					table.insert( self.bgrTiles[x], layer.data[i] )
				elseif layer.name == "background2" then
					table.insert( self.bgrTiles2[x], layer.data[i] )
				end
			end
		end
	end

	-- Load Entities.

	for _, layer in ipairs( self.data.layers ) do
		if layer.name == "Entities" then
			for _, object in ipairs( layer.objects ) do
				local facing = 1

				if object.properties.flipped ~= nil and object.properties.flipped then
					facing = -1
				end

				if not Player.inited and object.name == "player" then
					Player:init( Vec2:new( object.x + 8, object.y ) )
				elseif object.name == "droid" then
					Entities:add( Entities.enemies, Droid:new( Vec2:new( object.x + 8, object.y ), facing ) )
				elseif object.name == "energyTank" and Player.collectedEnergyTanks[ object.properties.name ] == nil then
					Entities:add( Entities.pickups, EnergyTank:new( Vec2:new( object.x, object.y ), object.properties.name ) )
				elseif object.name == "doubleJump" and not Player.doubleJump then
					Entities:add( Entities.pickups, DoubleJump:new( Vec2:new( object.x, object.y ) ) )
				end
			end
		end
	end

	Game.run = true
	self.loaded = true
end

function Room:clear()
	self.data = {}
	self.wallTiles = {}
	self.bgrTiles = {}
	self.bgrTiles2 = {}

	Entities:clear()
	-- Set to -1 so we will force update.
	self.updateTilePos:set( -1, -1 )
end

function Room:transition( direction )
	if self.transitions[ direction ] ~= nil then
		Game.run = false
		Room:load( self.transitions[ direction ] )

		if direction == "right" then
			Player:setPosition( Vec2:new( 8, Player.position.y ) )
		elseif direction == "left" then
			Player:setPosition( Vec2:new( self.data.width * TILE_SIZE - 8, Player.position.y ) )
		end

		-- Set camera immediately to player position to prevent it beeing one frame in wrong place.
		Camera:setPosition( Player.position )
	end
end

function Room:isTileWall( pos )
	if RL.CheckCollisionPointRec( { pos.x, pos.y }, { 0, 0, self.data.width, self.data.height } ) then
		return 0 < self.wallTiles[ pos.x + 1 ][ pos.y + 1 ]
	else
		return false
	end
end

function Room:tileCollision( entity )
	local vPos = entity.position + entity.velocity -- Future pos with current vel.
	local vRect = entity.colRect:clone()
	local tinyGap = 0.001 -- Tiny gap between collisionRect and tile to prevent getting stuck on all seams.
	local landed = false

	-- Move test rect to predicted position.
	vRect.x = vPos.x - vRect.width / 2

	-- Tile range where collision box is affecting.
	local tileRect = Rect:temp(
		math.floor( vRect.x / TILE_SIZE ),
		math.floor( vRect.y / TILE_SIZE ),
		math.floor( ( vRect.x + vRect.width ) / TILE_SIZE ),
		math.floor( ( vRect.y + vRect.height ) / TILE_SIZE )
	)

	for y = tileRect.y, tileRect.height do
		if 0 < entity.velocity.x then
			if self:isTileWall( Vec2:temp( tileRect.width, y ) ) then
				-- Use new_x to push out of tile.
				local new_x = tileRect.width * TILE_SIZE - ( entity.colRect.x + entity.colRect.width )

				entity.velocity.x = new_x - tinyGap

				break
			end
		elseif entity.velocity.x < 0 then
			if self:isTileWall( Vec2:temp( tileRect.x, y ) ) then
				local new_x = ( tileRect.x * TILE_SIZE + TILE_SIZE ) - entity.colRect.x
				entity.velocity.x = new_x + tinyGap

				break
			end
		end
	end

	-- Calculate new tileRect for y.
	vRect.x = entity.colRect.x -- Reset to non predicted one.
	vRect.y = vPos.y - vRect.height

	tileRect.x = math.floor( vRect.x / TILE_SIZE )
	tileRect.y = math.floor( vRect.y / TILE_SIZE )
	tileRect.width = math.floor( ( vRect.x + vRect.width ) / TILE_SIZE )
	tileRect.height = math.floor( ( vRect.y + vRect.height ) / TILE_SIZE )

	for x = tileRect.x, tileRect.width do
		if 0 < entity.velocity.y then
			if self:isTileWall( Vec2:temp( x, tileRect.height ) ) then
				local new_y = tileRect.height * TILE_SIZE - ( entity.colRect.y + entity.colRect.height )
				-- math.max prevents bounce when hitting right on the corner.
				entity.velocity.y = math.max( new_y - tinyGap, 0 )

				if not entity.onFloor then
					landed = true
				end

				entity.onFloor = true

				break
			end
		elseif entity.velocity.y < 0 then
			if self:isTileWall( Vec2:temp( x, tileRect.y ) ) then
				local new_y = ( tileRect.y * TILE_SIZE + TILE_SIZE ) - entity.colRect.y
				entity.velocity.y = new_y + tinyGap

				break
			end
		end
	end

	return landed
end

function Room:ifBulletCollide( bullet )
	local tileRect = Rect:temp(
		math.floor( bullet.colRect.x / TILE_SIZE ),
		math.floor( bullet.colRect.y / TILE_SIZE ),
		math.floor( ( bullet.colRect.x + bullet.colRect.width ) / TILE_SIZE ),
		math.floor( ( bullet.colRect.y + bullet.colRect.height ) / TILE_SIZE )
	)

	for x = tileRect.x, tileRect.width do
		for y = tileRect.y, tileRect.height do
			if self:isTileWall( Vec2:temp( x, y ) ) then
				return true
			end
		end
	end

	return false
end

-- function Room:update( delta )
-- end

function Room:drawTilemap( tilemap )
	local camTilePos = self.updateTilePos
	local tilePos = Vec2:new()
	local tileDrawPos = Vec2:new()

	for x = 0, self.TILE_RENDER_SIZE.x do
		for y = 0, self.TILE_RENDER_SIZE.y do
			tilePos:set( x + camTilePos.x, y + camTilePos.y )

			if tilemap[ tilePos.x ] ~= nil and tilemap[ tilePos.x ][ tilePos.y ] ~= nil then
				local tileId = tilemap[ tilePos.x ][ tilePos.y ]

				if 0 < tileId then
					-- On Tiled data 0 is empty but also id of first tile is 0 so we adjust to that.
					tileId = tileId - 1

					tileDrawPos.y = math.floor( tileId / self.tileTextureTileSize.x ) 
					tileDrawPos.x = ( tileId - tileDrawPos.y * self.tileTextureTileSize.x ) * TILE_SIZE
					tileDrawPos.y = tileDrawPos.y * TILE_SIZE

					RL.DrawTextureRec(
						self.tileTexture,
						{ tileDrawPos.x, tileDrawPos.y, TILE_SIZE, TILE_SIZE },
						{ (x-1) * TILE_SIZE, (y-1) * TILE_SIZE },
						RL.WHITE
					)
				end
			end
		end
	end
end

function Room:updateFramebuffer()
	local camTilePos = Vec2:new(
		math.floor( ( Camera.position.x - Camera.offset.x ) / TILE_SIZE ),
		math.floor( ( Camera.position.y - Camera.offset.y ) / TILE_SIZE )
	)

	-- Update framebuffer.

	if camTilePos ~= self.updateTilePos then
		self.updateTilePos = camTilePos

		RL.BeginTextureMode( self.tilemapFramebuffer )
			RL.ClearBackground( RL.BLANK )
			self:drawTilemap( self.bgrTiles2 )
			self:drawTilemap( self.bgrTiles )
			self:drawTilemap( self.wallTiles )
		RL.EndTextureMode()
	end
end

function Room:draw()
	RL.DrawTexturePro(
		RL.GetRenderTextureTexture( self.tilemapFramebuffer ),
		{ 0, 0, self.TILE_FRAMEBUFFER_SIZE.x, -self.TILE_FRAMEBUFFER_SIZE.y },
		{ self.updateTilePos.x * TILE_SIZE, self.updateTilePos.y * TILE_SIZE, self.TILE_FRAMEBUFFER_SIZE.x, self.TILE_FRAMEBUFFER_SIZE.y },
		{ 0, 0 },
		0.0,
		RL.WHITE
	)
end

Room = Room:new()
