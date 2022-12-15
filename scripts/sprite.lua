Sprite = {}
Sprite.__index = Sprite

function Sprite:new( texture, source, dest, origin, rotation, tint )
	local object = setmetatable( {}, self )

	object.texture = texture
	object.source = Rect:new( source )
	object.dest = Rect:new( dest )
	object.origin = Vec2:new( origin )
	object.rotation = rotation
	object.tint = Color:new( tint )

	object.animations = {}
	object.animation = nil
	object.animationPos = 0.0
	object.HFacing = 1
	object.VFacing = 1

    return object
end

function Sprite:getCurFrame()
	return util.clamp( math.ceil( self.animationPos ), 1, #self.animations[ self.animation ] )
end

function Sprite:playAnimation( advance )
	if self.animations[ self.animation ] == nil then
		return
	end

	self.animationPos = self.animationPos + advance

	if #self.animations[ self.animation ] < self.animationPos then
		self.animationPos = self.animationPos - #self.animations[ self.animation ]
	end
end

function Sprite:draw( pos )
	local source = self.source:clone()
	local dest = self.dest:clone()

	if self.animation ~= nil then
		source = self.animations[ self.animation ][ self:getCurFrame() ].source:clone()
		dest = self.animations[ self.animation ][ self:getCurFrame() ].dest:clone()
	end

	dest.x = pos.x
	dest.y = pos.y

	source.width = source.width * self.HFacing
	source.height = source.height * self.VFacing

	RL_DrawTexturePro( self.texture, source, dest, self.origin, self.rotation, self.tint )
end
