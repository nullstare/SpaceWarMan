return {
  version = "1.9",
  luaversion = "5.1",
  tiledversion = "1.9.2",
  class = "",
  orientation = "orthogonal",
  renderorder = "right-down",
  width = 40,
  height = 32,
  tilewidth = 8,
  tileheight = 8,
  nextlayerid = 9,
  nextobjectid = 29,
  properties = {
    ["bgrImage"] = "desertBgr",
    ["bgrImageX"] = 0,
    ["bgrImageY"] = -40,
    ["roomLeft"] = "factory.lua",
    ["roomRight"] = "pipes.lua"
  },
  tilesets = {
    {
      name = "tiles",
      firstgid = 1,
      filename = "../sources/maps/tiles.tsx"
    },
    {
      name = "actors",
      firstgid = 793,
      filename = "../sources/maps/actors.tsx"
    },
    {
      name = "powers",
      firstgid = 801,
      filename = "../sources/maps/powers.tsx"
    }
  },
  layers = {
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 40,
      height = 32,
      id = 8,
      name = "background2",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 0, 0, 0, 0, 0, 0, 0, 249, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 293, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 392, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 435, 436, 437, 434, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 392, 0, 0, 0, 0, 0, 0, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 437, 434, 435, 0, 0, 0, 0, 0, 0, 0, 0, 436, 437, 434, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 393, 390, 391, 0, 0, 390, 391, 392, 393, 0, 0, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 434, 435, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 393, 390, 391, 392, 393, 390, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 434, 435, 436, 437, 434, 435, 436, 437, 434, 435, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 390, 391, 392, 393, 390, 391, 392, 393, 390, 391, 392, 393, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 434, 435, 390, 391, 392, 393, 390, 391, 392, 393, 436, 437, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 40,
      height = 32,
      id = 2,
      name = "background",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 205, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 0, 0, 0, 0,
        0, 0, 382, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 382, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 77, 390, 391, 392, 393,
        552, 552, 382, 244, 246, 0, 0, 0, 0, 0, 38, 39, 40, 41, 0, 0, 0, 382, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 392, 393, 390, 391,
        552, 552, 382, 244, 246, 0, 0, 0, 0, 0, 82, 83, 84, 85, 383, 383, 383, 336, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 390, 391, 392, 393,
        552, 552, 382, 244, 246, 383, 383, 337, 383, 383, 126, 127, 128, 129, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 32, 392, 393, 390, 391,
        552, 552, 382, 244, 246, 0, 0, 511, 0, 0, 170, 171, 172, 173, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 76, 0, 0, 0, 0,
        552, 552, 382, 244, 246, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        552, 552, 382, 244, 246, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 382, 244, 246, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 162, 163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 206, 207, 209, 208, 209, 208, 209, 120, 208, 121, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 511, 0, 0, 214, 215, 216, 217, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 250, 251, 253, 252, 253, 252, 253, 164, 252, 165, 112, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 512, 468, 468, 258, 259, 260, 261, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 294, 295, 0, 0, 0, 0, 0, 0, 0, 0, 77, 390, 391, 392, 393,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 302, 303, 304, 305, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 294, 295, 0, 0, 0, 0, 0, 0, 0, 0, 76, 392, 393, 390, 391,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 346, 347, 348, 349, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 162, 163, 0, 0, 0, 0, 0, 0, 0, 0, 76, 390, 391, 392, 393,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 206, 207, 0, 0, 0, 0, 0, 0, 0, 0, 32, 392, 393, 390, 391,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0, 112, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 294, 295, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 162, 163, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 244, 246, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 244, 246, 0, 0, 0, 0, 206, 207, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        5, 0, 0, 244, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 246, 0, 0, 0, 0, 250, 251, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 210, 211, 212, 213, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 254, 255, 256, 257, 0, 0, 0, 0, 0, 42, 43, 44, 0, 0, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0, 0, 0, 0, 5, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 298, 299, 300, 301, 0, 0, 0, 0, 0, 86, 87, 88, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 342, 343, 344, 345, 0, 0, 0, 0, 0, 130, 131, 132, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 386, 387, 388, 389, 0, 0, 0, 0, 0, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 430, 431, 432, 433, 0, 0, 0, 0, 0, 0, 0, 511, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 474, 475, 476, 477, 383, 383, 383, 0, 0, 0, 0, 513, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 518, 519, 520, 521, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
      }
    },
    {
      type = "tilelayer",
      x = 0,
      y = 0,
      width = 40,
      height = 32,
      id = 1,
      name = "walls",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      encoding = "lua",
      data = {
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 4, 6, 12,
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 265, 138, 138, 138, 136,
        3, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        136, 136, 399, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 177, 138, 138, 138, 136,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 48, 50, 6,
        0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 2, 4, 50,
        136, 136, 311, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 227, 228, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 46, 48, 4,
        2, 2, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 3, 2, 48,
        2, 2, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 3, 46, 46,
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 265, 138, 138, 138, 136,
        2, 2, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        2, 2, 135, 0, 0, 0, 0, 0, 0, 0, 0, 227, 228, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
        48, 3, 135, 0, 0, 0, 0, 0, 0, 0, 0, 271, 272, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 177, 138, 138, 138, 136,
        48, 2, 135, 0, 0, 0, 0, 0, 309, 310, 310, 310, 310, 310, 310, 311, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 2, 3, 2,
        5, 3, 135, 0, 0, 0, 0, 0, 353, 354, 398, 398, 398, 398, 354, 355, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 46, 3, 46,
        7, 3, 135, 0, 0, 0, 0, 0, 353, 355, 0, 579, 0, 0, 353, 355, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 3, 4, 6,
        177, 136, 133, 309, 310, 310, 310, 310, 354, 355, 0, 579, 0, 0, 353, 354, 310, 310, 310, 310, 311, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 185, 3, 3, 48, 6,
        135, 2, 2, 353, 354, 354, 398, 398, 398, 399, 0, 579, 0, 0, 397, 398, 398, 398, 354, 354, 355, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 136, 133, 3, 4, 6, 10,
        135, 2, 3, 353, 354, 355, 0, 0, 0, 0, 0, 579, 538, 539, 539, 584, 0, 0, 353, 354, 355, 4, 2, 2, 3, 4, 4, 2, 3, 2, 4, 2, 3, 2, 4, 185, 3, 48, 6, 54,
        135, 2, 3, 353, 354, 355, 0, 0, 0, 0, 281, 282, 283, 284, 0, 0, 0, 0, 353, 354, 355, 4, 3, 2, 3, 2, 4, 177, 138, 138, 138, 138, 138, 138, 138, 223, 138, 138, 138, 138,
        135, 2, 2, 353, 354, 355, 0, 0, 0, 0, 325, 326, 327, 328, 0, 0, 0, 0, 353, 354, 355, 2, 2, 3, 4, 5, 4, 185, 2, 3, 2, 2, 2, 3, 4, 4, 4, 4, 6, 7,
        135, 2, 3, 353, 354, 355, 0, 535, 536, 536, 369, 370, 371, 372, 540, 0, 0, 0, 353, 354, 355, 46, 46, 47, 48, 4, 48, 185, 46, 47, 46, 46, 4, 5, 48, 48, 6, 6, 7, 7,
        135, 2, 3, 353, 354, 355, 0, 579, 0, 0, 413, 414, 415, 416, 582, 0, 0, 0, 353, 354, 355, 2, 2, 3, 4, 5, 4, 185, 2, 3, 4, 5, 4, 5, 5, 6, 7, 50, 8, 8,
        135, 4, 5, 353, 354, 355, 0, 579, 0, 0, 0, 0, 0, 0, 582, 0, 0, 0, 353, 354, 355, 46, 46, 47, 48, 4, 48, 185, 46, 47, 48, 4, 48, 6, 7, 7, 51, 51, 8, 11,
        135, 4, 5, 353, 354, 355, 0, 579, 0, 0, 0, 0, 0, 453, 454, 455, 456, 0, 353, 354, 355, 4, 4, 6, 7, 6, 5, 185, 4, 5, 4, 4, 5, 6, 7, 6, 11, 8, 11, 55,
        135, 4, 5, 353, 354, 355, 0, 579, 0, 0, 0, 0, 0, 497, 498, 499, 500, 0, 353, 354, 355, 6, 6, 7, 6, 8, 7, 185, 4, 5, 4, 6, 7, 8, 51, 11, 55, 13, 55, 57,
        135, 48, 49, 353, 354, 355, 0, 579, 0, 0, 0, 0, 0, 541, 542, 543, 544, 0, 353, 354, 355, 8, 8, 51, 8, 50, 51, 185, 48, 49, 48, 50, 51, 52, 8, 55, 55, 57, 57, 56
      }
    },
    {
      type = "objectgroup",
      draworder = "topdown",
      id = 3,
      name = "objects",
      class = "",
      visible = true,
      opacity = 1,
      offsetx = 0,
      offsety = 0,
      parallaxx = 1,
      parallaxy = 1,
      properties = {},
      objects = {
        {
          id = 22,
          name = "player",
          class = "",
          shape = "rectangle",
          x = 88,
          y = 128,
          width = 16,
          height = 16,
          rotation = 0,
          gid = 793,
          visible = true,
          properties = {}
        }
      }
    }
  }
}
