local sounds = require("__base__.prototypes.entity.sounds")
local item_sounds = require("__base__.prototypes.item_sounds")
local hit_effects = require("__base__.prototypes.entity.hit-effects")
local flow_rate = 10

local base = {
  type = "valve",
  name = "pipe-junction-",
  icon = "__pipe-junctions__/pipe-junction.png",
  icon_size = 64,
  flags = {"placeable-neutral", "player-creation"},
  minable = {mining_time = 0.1, result = "pipe-junction"},
  placeable_by = {item = "pipe-junction", count = 1},
  max_health = 100,
  corpse = "pipe-remnants",
  dying_explosion = "pipe-explosion",
  icon_draw_specification = {scale = 0.5},
  resistances =
  {
    {
      type = "fire",
      percent = 80
    },
    {
      type = "impact",
      percent = 30
    }
  },
  fast_replaceable_group = "pipe",
  collision_box = {{-0.29, -0.29}, {0.29, 0.29}},
  selection_box = {{-0.5, -0.5}, {0.5, 0.5}},
  open_sound = sounds.metal_small_open,
  close_sound = sounds.metal_small_close,
  damaged_trigger_effect = hit_effects.entity(),
  impact_category = "metal",
  mode = "one-way",
  fluid_box = {
    pipe_connections = {
      {flow_direction = "input-output", connection_type = "normal", direction = defines.direction.north, position = {0, 0}},
      {flow_direction = "input-output", connection_type = "normal", direction = defines.direction.east,  position = {0, 0}},
      {flow_direction = "input-output", connection_type = "normal", direction = defines.direction.south, position = {0, 0}},
      {flow_direction = "input-output", connection_type = "normal", direction = defines.direction.west,  position = {0, 0}},
    },
    volume = 100,
    pipe_covers = pipecoverspictures()
  },
  flow_rate = flow_rate,
  animations = {
    north = {
      filename = "__base__/graphics/entity/pipe/pipe-cross.png",
      size = 128,
      scale = 0.5,

    }
  },
  factoriopedia_alternative = "pipe-junction-2",
  hidden_in_factoriopedia = true
}

for suffix, outputs in pairs{
  {1},
  {1, 2},
  {1, 3},
  {1, 2, 3}
} do
  local junction = table.deepcopy(base)
  junction.name = junction.name .. suffix
  for _, output in pairs(outputs) do
    junction.fluid_box.pipe_connections[output].flow_direction = "output"
  end
  data:extend{junction}
end

data.raw.valve["pipe-junction-2"].factoriopedia_alternative = nil
data.raw.valve["pipe-junction-2"].hidden_in_factoriopedia = nil

data:extend{
  {
    type = "item",
    name = "pipe-junction",
    icon = "__pipe-junctions__/pipe-junction.png",
    icon_size = 64,
    subgroup = "energy-pipe-distribution",
    order = "a[pipe]-c[pipe-junction]",
    inventory_move_sound = item_sounds.metal_small_inventory_move,
    pick_sound = item_sounds.metal_small_inventory_pickup,
    drop_sound = item_sounds.metal_small_inventory_move,
    place_result = "pipe-junction-2",
    stack_size = 100,
  },
  {
    type = "recipe",
    name = "pipe-junction",
    ingredients = {
      {type = "item", name = "iron-plate", amount = 2},
      {type = "item", name = "pipe", amount = 2}
    },
    results = {{type = "item", name = "pipe-junction", amount = 1}},
    enabled = false
  },
  {
    type = "custom-input",
    name = "pipe-junction-next",
    key_sequence = "CONTROL + R",
    action = "lua"
  }
}

data.raw["technology"]["steam-power"].effects[#data.raw["technology"]["steam-power"].effects+1] = {type = "unlock-recipe", recipe = "pipe-junction"}