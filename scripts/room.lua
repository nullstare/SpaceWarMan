Room = {}
Room.__index = Room

function Room:new()
    local object = setmetatable( {}, self )

	object.TILE_RENDER_SIZE = Vec2:new( 40 + 1, 32 + 1 )

	object.data = {}
	object.wallTiles = {}
	object.bgrTiles = {}
	object.tileTexture = nil
	object.tileTextureSize = Vec2:new( 0, 0 )
	object.tileTextureTileSize = Vec2:new( 0, 0 )

    return object
end

function Room:load( name )
	self.tileTexture = Resources.textures.tileset
	self.tileTextureSize = Vec2:new( RL_GetTextureSize( self.tileTexture ) )
	self.tileTextureTileSize = Vec2:new( self.tileTextureSize.x / TILE_SIZE, self.tileTextureSize.y / TILE_SIZE )
	self.data = dofile( RL_GetBasePath().."maps/"..name )

	-- Load tile data.

	for x = 1, self.data.width do
		table.insert( self.wallTiles, {} )
		table.insert( self.bgrTiles, {} )
		
		for y = 1, self.data.height do
			local i = (x-1) + (y-1) * self.data.width + 1

			for _, layer in ipairs( self.data.layers ) do
				if layer.name == "walls" then
					table.insert( self.wallTiles[x], layer.data[i] )
				elseif layer.name == "background" then
					table.insert( self.bgrTiles[x], layer.data[i] )
				end
			end
		end
	end

	-- Load objects.

	for _, layer in ipairs( self.data.layers ) do
		if layer.name == "objects" then
			for _, object in ipairs( layer.objects ) do
				if not Player.ready and object.name == "player" then
					Player:init( Vec2:new( object.x + 18, object.y ) )
				end
			end
		end
	end
end

function Room:isTileWall( pos )
	if RL_CheckCollisionPointRec( { pos.x, pos.y }, { 0, 0, self.data.width - 1, self.data.height - 1 } ) then
		return 0 < self.wallTiles[ pos.x + 1 ][ pos.y + 1 ]
	else
		return false
	end
end

function Room:tileCollision( entity )
	local vPos = entity.position + entity.velocity -- Future pos with current vel.
	local vRect = entity.colRect:clone()
	local tinyGap = 0.001 -- Tiny gap between collisionRect and tile to prevent getting stuck on all seams.

	-- Move test rect to predicted position.
	vRect.x = vPos.x - vRect.width / 2

	-- Tile range where collision box is affecting.
	local tileRect = Rect:new(
		math.floor( vRect.x / TILE_SIZE ),
		math.floor( vRect.y / TILE_SIZE ),
		math.floor( ( vRect.x + vRect.width ) / TILE_SIZE ),
		math.floor( ( vRect.y + vRect.height ) / TILE_SIZE )
	)

	for y = tileRect.y, tileRect.height do
		if 0 < entity.velocity.x then
			if self:isTileWall( Vec2:new( tileRect.width, y ) ) then
				-- Use new_x to push out of tile.
				local new_x = tileRect.width * TILE_SIZE - ( entity.colRect.x + entity.colRect.width )

				entity.velocity.x = new_x - tinyGap

				break
			end
		elseif entity.velocity.x < 0 then
			if self:isTileWall( Vec2:new( tileRect.x, y ) ) then
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
			if self:isTileWall( Vec2:new( x, tileRect.height ) ) then
				local new_y = tileRect.height * TILE_SIZE - ( entity.colRect.y + entity.colRect.height )
				-- math.max prevents bounce when hitting right on the corner.
				entity.velocity.y = math.max( new_y - tinyGap, 0 )
				entity.onFloor = true

				break
			end
		elseif entity.velocity.y < 0 then
			if self:isTileWall( Vec2:new( x, tileRect.y ) ) then
				local new_y = ( tileRect.y * TILE_SIZE + TILE_SIZE ) - entity.colRect.y
				entity.velocity.y = new_y + tinyGap

				break
			end
		end
	end
end

function Room:ifBulletCollide( bullet )
	local tileRect = Rect:new(
		math.floor( bullet.colRect.x / TILE_SIZE ),
		math.floor( bullet.colRect.y / TILE_SIZE ),
		math.floor( ( bullet.colRect.x + bullet.colRect.width ) / TILE_SIZE ),
		math.floor( ( bullet.colRect.y + bullet.colRect.height ) / TILE_SIZE )
	)

	for x = tileRect.x, tileRect.width do
		for y = tileRect.y, tileRect.height do
			if self:isTileWall( Vec2:new( x, y ) ) then
				return true
			end
		end
	end

	return false
end

function Room:process( delta )
end

function Room:drawTilemap( tilemap )
	local camTilePos = Vec2:new( math.floor( ( Camera.position.x - Camera.offset.x ) / TILE_SIZE ), math.floor( ( Camera.position.y - Camera.offset.y ) / TILE_SIZE ) )

	for x = camTilePos.x, self.TILE_RENDER_SIZE.x + camTilePos.x do
		for y = camTilePos.y, self.TILE_RENDER_SIZE.y + camTilePos.y do
			local tilePos = Vec2:new( x, y )

			if tilemap[ tilePos.x ] ~= nil and tilemap[ tilePos.x ][ tilePos.y ] ~= nil then
				local tileId = tilemap[ tilePos.x ][ tilePos.y ]
				
				if 0 < tileId then
					local tileDrawPos = Vec2:new()

					-- On Tiled data, 0 is empty but also id of first tile is 0 so we adjust to that.
					tileId = tileId - 1

					tileDrawPos.y = math.floor( tileId / self.tileTextureTileSize.x ) 
					tileDrawPos.x = ( tileId - tileDrawPos.y * self.tileTextureTileSize.x ) * TILE_SIZE 
					tileDrawPos.y = tileDrawPos.y * TILE_SIZE

					RL_DrawTextureRec( self.tileTexture, { tileDrawPos.x, tileDrawPos.y, TILE_SIZE, TILE_SIZE }, { (x-1) * TILE_SIZE, (y-1) * TILE_SIZE }, WHITE )
				end
			end
		end
	end
end

function Room:draw()
	self:drawTilemap( self.bgrTiles )
	self:drawTilemap( self.wallTiles )
end

Room = Room:new()
