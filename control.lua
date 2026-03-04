local old_name = {}

--- @param event EventData.on_pre_build
script.on_event(defines.events.on_pre_build, function (event)
  local player = game.get_player(event.player_index)
  local entity = player.selected
  if not entity then return end
  local name = entity.name == "entity-ghost" and entity.ghost_name or ""
  if not name:find("pipe-junction", 1, true) then return end
  old_name[player.index] = name
end)

--- @param event EventData.on_built_entity
script.on_event(defines.events.on_built_entity, function (event)
  local player = game.get_player(event.player_index)
  local old = old_name[player.index]
  old_name[player.index] = nil
  if not old then return end
  local entity = event.entity
  if not entity or not entity.valid then return end
  local name = entity.name == "entity-ghost" and entity.ghost_name or entity.name
  if not name:find("pipe-junction", 1, true) then return end
  entity.surface.create_entity({
    name = entity.name == "entity-ghost" and "entity-ghost" or old,
    ghost_name = entity.name == "entity-ghost" and old or nil,
    position = entity.position,
    quality = entity.quality,
    direction = entity.direction,
    force = entity.force,
    fast_replace = true,
    spill = false,
    create_build_effect_smoke = false,
  })
end)

local next = {
  ["1"] = "2",
  ["2"] = "3",
  ["3"] = "4",
  ["4"] = "1"
}

--- @param event EventData.CustomInputEvent
script.on_event("pipe-junction-next", function (event)
  local player = game.get_player(event.player_index)
  local entity = player.selected
  if not entity then return end
  local name = entity.name == "entity-ghost" and entity.ghost_name or entity.name
  if not name:find("pipe-junction", 1, true) then return end
  local new_name = name:sub(1, -2) .. next[name:sub(-1)]
  local new_neighbour = entity.surface.create_entity({
    name = entity.name == "entity-ghost" and "entity-ghost" or new_name,
    ghost_name = entity.name == "entity-ghost" and new_name or nil,
    position = entity.position,
    quality = entity.quality,
    direction = entity.direction,
    force = entity.force,
    fast_replace = true,
    spill = false,
    create_build_effect_smoke = false,
  })
end)