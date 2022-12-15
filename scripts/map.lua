Map = {}
Map.__index = Map

function Map:new()
    local object = setmetatable( {}, self )

    return object
end

function Map:process( delta )
end

function Map:draw()
	RL_DrawTexture( Resources.textures.mockup, { 0, 0 }, WHITE )
end

Map = Map:new()
