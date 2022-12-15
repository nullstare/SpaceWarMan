Bullet = {}
Bullet.__index = Bullet

function Bullet:new( pos, vel, tex, source, range )
	local object = setmetatable( {}, self )

	object.position = pos:clone()
	object.velocity = vel:clone()
	object.sprite = Sprite:new( Resources.textures.effects, source, { pos.x, pos.y, source[3], source[4] }, { 4, 4 }, 0.0, WHITE )
	object.range = range
	object.colRect = Rect:new( pos.x, pos.y, source[3], source[4] )

    return object
end

-- Return false if destroyed.
function Bullet:process( delta )
	local range = self.velocity:scale( delta )

	self.position = self.position + range
	self.colRect.x = self.position.x - self.colRect.width / 2
	self.colRect.y = self.position.y - self.colRect.height / 2
	self.range = self.range - range:length()

	return 0 < self.range and not Room:ifBulletCollide( self )
end

function Bullet:draw()
	if self.sprite ~= nil then
		self.sprite:draw( self.position )
	end
end
