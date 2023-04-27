Map = {}
Map.__index = Map

function Map:new()
    local object = setmetatable( {}, self )

    return object
end

function Map:process( delta )
end

function Map:draw()
	RL.DrawTexture( Resources.textures.mockup, { 0, 0 }, RL.WHITE )
end

Map = Map:new()
