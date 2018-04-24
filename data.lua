require "functions"
require "config"

local accuname = "Senpais-Power-Provider"
local artillery_train_name = "Senpais-Dora"
local MODNAME = "__Senpais_Trains__"

Senpais.Functions.Create.Grid( "Senpais-Trains", 10, 10, { "Senpais-Trains" } )

for s, ss in pairs( Senpais.Sprites ) do
	if data.raw["sprite"] == nil then
		data.raw["sprite"] = {}
	end
	if data.raw["sprite"][s] == nil then
		data:extend{ Senpais.Functions.Create.Sprite32x32( s, MODNAME .. "/graphics/" .. ss .. ".png" ) }
	end
end

data:extend{ { type = "equipment-category", name = "Senpais-Trains" } }

if settings["startup"]["Senpais-Power-Provider"].value then
	local accu_entity = util.table.deepcopy( data.raw["electric-energy-interface"]["electric-energy-interface"] )
	accu_entity.name = accuname
	accu_entity.icon = MODNAME .. "/graphics/" .. accuname .. "-i.png"
	accu_entity.minable.result = accuname
	accu_entity.enable_gui = false
    accu_entity.allow_copy_paste = false
	accu_entity.energy_source = { type = "electric", buffer_capacity = "25MJ", usage_priority = "primary-input", input_flow_limit = "1500kW", output_flow_limit = "0W" }
	accu_entity.energy_production = "0kW"
	accu_entity.energy_usage = "0kW"
	accu_entity.picture = { filename = MODNAME .. "/graphics/" .. accuname.. "-e.png", priority = "extra-high", width = 124, height = 103, shift = { 0.6875, -0.203125 } }
	accu_entity.charge_animation = { filename = MODNAME .. "/graphics/" .. accuname .. "-charge.png", width = 138, height = 135, line_length = 8, frame_count = 24, shift = { 0.46875, -0.640625 }, animation_speed = 0.5 }

	local accu_item = util.table.deepcopy( data.raw["item"]["accumulator"] )
	accu_item.name = accuname
	accu_item.icon = MODNAME .. "/graphics/" .. accuname .. "-i.png"
	accu_item.order = "e[accumulator]-d["..accuname.."]"
	accu_item.place_result = accuname

	local accu_recipe = util.table.deepcopy( data.raw["recipe"]["accumulator"] )
	accu_recipe.name = accuname
	accu_recipe.ingredients = { { "accumulator", 2 }, { "battery", 5 }, { "electronic-circuit", 10 } }
	accu_recipe.result = accuname

	local senpais_electric_train_tech = util.table.deepcopy( data.raw["technology"]["railway"] )
	senpais_electric_train_tech.name = "Senpais-Electric-Train"
	senpais_electric_train_tech.icon = MODNAME .. "/graphics/tech.png"
	senpais_electric_train_tech.icon_size = 128
	senpais_electric_train_tech.effects = { { type = "unlock-recipe", recipe = accuname } }
	senpais_electric_train_tech.prerequisites = { "railway", "electric-engine", "battery", "electric-energy-distribution-2" }
	senpais_electric_train_tech.unit = { count = 150, ingredients = { { "science-pack-1", 2 }, { "science-pack-2", 2}, { "science-pack-3", 1} }, time = 50 }
	senpais_electric_train_tech.order = "s-e-t"

	data:extend( { accu_entity, accu_item, accu_recipe, senpais_electric_train_tech } )

	if settings["startup"]["Senpais-Electric-Train"].value then
		Senpais.Functions.Create.Elec_Locomotive( 2, "Senpais-Electric-Train", MODNAME .. "/graphics/Senpais-Electric-Train.png", 1000, 2000, 2.5, { r = 83, g = 187, b = 144 }, nil,
												  "transport", "a[train-system]-faa[Senpais-Electric-Train]", 5, { { "locomotive", 1 }, { "battery", 10 }, { "electric-engine-unit", 20 } },
												  "Senpais-Electric-Train" )
		if settings["startup"]["Senpais-Electric-Train-Heavy"].value then
			local senpais_electric_train_tech_2 = util.table.deepcopy( data.raw["technology"]["Senpais-Electric-Train"] )
			senpais_electric_train_tech_2.name = "Senpais-Electric-Train-2"
			senpais_electric_train_tech_2.effects = {}
			senpais_electric_train_tech_2.prerequisites = { "Senpais-Electric-Train" }
			senpais_electric_train_tech_2.unit.count = 300
	
			data:extend( { senpais_electric_train_tech_2 } )
	
			Senpais.Functions.Create.Elec_Locomotive( 5, "Senpais-Electric-Train-Heavy", MODNAME .. "/graphics/Senpais-Electric-Train-Heavy.png", 2000, 5000, 2.5, { r = 166, g = 26, b = 26 }, nil,
													  "transport", "a[train-system]-fab[Senpais-Electric-Train-Heavy]", 5, { { "Senpais-Electric-Train", 1 }, { "battery", 20 }, { "electric-engine-unit", 20 } },
													  "Senpais-Electric-Train-2" )
		end
	end
end

if settings["startup"]["Battle-Laser"].value then
	local laser_beam =
	{
	 type = "beam",
	 name = "battle-laser-beam",
	 flags = { "not-on-map" },
	 width = 0.5,
	 damage_interval = 20,
	 light = { intensity = 0.5, size = 10 },
	 working_sound = { { filename = MODNAME .. "/graphics/laser-beam-01.ogg", volume = 0.9 }, { filename = MODNAME .. "/graphics/laser-beam-02.ogg", volume = 0.9 }, { filename = MODNAME .. "/graphics/laser-beam-03.ogg", volume = 0.9 } },
	 action = { type = "direct", action_delivery = { type = "instant", target_effects = { { type = "damage", damage = { amount = 20, type = "laser" } } } } },
	 start = { filename = MODNAME .. "/graphics/laser-beam-start.png", line_length = 16, tint = { r = 232, g = 10, b = 165 }, frame_count = 12, x = 45 * 4, width = 45, height = 1, priority = "high", animation_speed = 0.5, blend_mode = "additive-soft" },
	 ending = { filename = MODNAME .. "/graphics/laser-beam-end.png", line_length = 16, tint = { r = 232, g = 10, b = 165 }, frame_count = 12, x = 48 * 4, width = 48, height = 24, priority = "high", animation_speed = 0.5, blend_mode = "additive-soft" },
	 head = { filename = MODNAME .. "/graphics/laser-beam-head.png", line_length = 16, tint = { r = 232, g = 10, b = 165 }, frame_count = 12, x = 45 * 4, width = 45, height = 1, priority = "high", animation_speed = 0.5, blend_mode = "additive-soft" },
	 tail = { filename = MODNAME .. "/graphics/laser-beam-tail.png", line_length = 16, tint = { r = 232, g = 10, b = 165 }, frame_count = 12, x = 48 * 4, width = 48, height = 24, priority = "high", animation_speed = 0.5, blend_mode = "additive-soft" },
	 body = { { filename = MODNAME .. "/graphics/laser-beam-body.png", line_length = 16, tint = { r = 232, g = 10, b = 165 }, frame_count = 12, x = 48 * 4, width = 48, height = 24, priority = "high", animation_speed = 0.5, blend_mode = "additive-soft" } }
	}

	local laser_equipment = util.table.deepcopy( data.raw["active-defense-equipment"]["personal-laser-defense-equipment"] )
	laser_equipment.name = "laser-2"
	laser_equipment.sprite.filename = MODNAME .. "/graphics/laser-2.png"
	laser_equipment.energy_source.buffer_capacity = "750kJ"
	laser_equipment.attack_parameters = { type = "beam", ammo_category = "electric", cooldown = 20, range = 25, damage_modifier = 4, ammo_type = { type = "projectile", category = "laser-turret",
										  energy_consumption = "700kW", action = { { type = "direct", action_delivery = { { type = "beam", beam = "battle-laser-beam", max_length = 20, duration = 20, source_offset = { 0, -13 } } } } } },
										  sound = { { filename = MODNAME .. "/graphics/laser-beam-01.ogg", volume = 0.5 }, { filename = MODNAME .. "/graphics/laser-beam-02.ogg", volume = 0.5 }, { filename = MODNAME .. "/graphics/laser-beam-03.ogg", volume = 0.5 } } }
	laser_equipment.categories = { "Senpais-Trains" }

	local laser_item = util.table.deepcopy( data.raw["item"]["personal-laser-defense-equipment"] )
	laser_item.name = "laser-2"
	laser_item.icon = MODNAME .. "/graphics/laser-2-i.png"
	laser_item.placed_as_equipment_result = "laser-2"
	laser_item.order = "d[active-defense]-ab[laser-2]"

	local laser_recipe = util.table.deepcopy( data.raw["recipe"]["personal-laser-defense-equipment"] )
	laser_recipe.name = "laser-2"
	laser_recipe.ingredients = { { "personal-laser-defense-equipment", 1 }, { "processing-unit", 10 }, { "steel-plate", 50 }, { "laser-turret", 5 } }
	laser_recipe.result = "laser-2"

	local laser_tech = util.table.deepcopy( data.raw["technology"]["personal-laser-defense-equipment"] )
	laser_tech.name = "personal-laser-defense-equipment-2"
	laser_tech.prerequisites = { "personal-laser-defense-equipment" }
	laser_tech.effects = { { type = "unlock-recipe", recipe = "laser-2" } }
	laser_tech.unit.count = 250

	data:extend( { laser_beam, laser_equipment, laser_item, laser_recipe, laser_tech } )

	table.insert( data.raw["energy-shield-equipment"]["energy-shield-mk2-equipment"].categories, "Senpais-Trains" )
	table.insert( data.raw["battery-equipment"]["battery-mk2-equipment"].categories, "Senpais-Trains" )
	table.insert( data.raw["generator-equipment"]["fusion-reactor-equipment"].categories, "Senpais-Trains" )
end

if settings["startup"]["Battle-Loco-1"].value then
	Senpais.Functions.Create.Battle_Locomotive( 1, "Battle-Loco-1", MODNAME .. "/graphics/Battle-Loco-1.png", 1000, 2000, 1.2, { r = 213, g = 105, b = 33 }, "Senpais-Trains", "transport",
												"a[train-system]-fba[Battle-Loco-1]", 5, { { "locomotive", 1 }, { "modular-armor", 1 } }, "modular-armor" )

	if settings["startup"]["Battle-Loco-2"].value then
		Senpais.Functions.Create.Battle_Locomotive( 2, "Battle-Loco-2", MODNAME .. "/graphics/Battle-Loco-2.png", 2000, 4000, 1.4, { r = 101, g = 33, b = 213 }, "Senpais-Trains", "transport",
													"a[train-system]-fbb[Battle-Loco-2]", 5, { { "Battle-Loco-1", 1 }, { "power-armor", 1 } }, "power-armor" )
		if settings["startup"]["Battle-Loco-3"].value then
			Senpais.Functions.Create.Battle_Locomotive( 3, "Battle-Loco-3", MODNAME .. "/graphics/Battle-Loco-3.png", 3000, 6000, 1.6, { r = 196, g = 0, b = 74 }, "Senpais-Trains", "transport",
														"a[train-system]-fbc[Battle-Loco-3]", 5, { { "Battle-Loco-2", 1 }, { "power-armor-mk2", 1 } }, "power-armor-2" )
		end
	end
	if settings["startup"][ "Senpais-Power-Provider"].value and settings["startup"]["Senpais-Electric-Train"].value then
		if settings["startup"]["Elec-Battle-Loco-1"].value then
			Senpais.Functions.Create.Elec_Locomotive( 2, "Elec-Battle-Loco-1", MODNAME .. "/graphics/Elec-Battle-Loco-1.png", 1000, 2000, 2.5, { r = 180, g = 136, b = 0 }, "Senpais-Trains", "transport",
													  "a[train-system]-fca[Elec-Battle-Loco-1]", 5, { { "Senpais-Electric-Train", 1 }, { "modular-armor", 1 } }, "modular-armor" )
			if settings["startup"]["Elec-Battle-Loco-2"].value then
				Senpais.Functions.Create.Elec_Locomotive( 4, "Elec-Battle-Loco-2", MODNAME .. "/graphics/Elec-Battle-Loco-2.png", 2000, 4000, 3, { r = 83, g = 166, b = 187 }, "Senpais-Trains", "transport",
														  "a[train-system]-fcb[Elec-Battle-Loco-2]", 5, { { "Elec-Battle-Loco-1", 1 }, { "power-armor", 1 } }, "power-armor" )
				if settings["startup"]["Elec-Battle-Loco-3"].value then
				Senpais.Functions.Create.Elec_Locomotive( 6, "Elec-Battle-Loco-3", MODNAME .. "/graphics/Elec-Battle-Loco-3.png", 3000, 6000, 3.5, { r = 157, g = 0, b = 196 }, "Senpais-Trains", "transport",
														  "a[train-system]-fcc[Elec-Battle-Loco-3]", 5, { { "Elec-Battle-Loco-2", 1 }, { "power-armor-mk2", 1 } }, "power-armor-2" )
				end
			end
		end
	end
end

if settings["startup"]["Battle-Wagon-1"].value then
	Senpais.Functions.Create.Battle_Wagon( "Battle-Wagon-1", nil, 20, 1000, 2000, 1.5, { r = 19, g = 122, b = 156 }, "Senpais-Trains", "transport",
										   "a[train-system]-gaa[Battle-Wagon-1]", 5, { { "cargo-wagon", 1 }, { "modular-armor", 1 } }, "modular-armor" )

	data.raw["cargo-wagon"]["Battle-Wagon-1"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 19, g = 122, b = 156 } } }
	data.raw["item-with-entity-data"]["Battle-Wagon-1"].icon = nil
	data.raw["item-with-entity-data"]["Battle-Wagon-1"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 19, g = 122, b = 156 } } }

	if settings["startup"]["Battle-Wagon-2"].value then
		Senpais.Functions.Create.Battle_Wagon( "Battle-Wagon-2", nil, 40, 2000, 4000, 1.7, { r = 29, g = 127, b = 12 }, "Senpais-Trains", "transport",
											   "a[train-system]-gab[Battle-Wagon-2]", 5, { { "Battle-Wagon-1", 1 }, { "power-armor", 1 } }, "power-armor" )

		data.raw["cargo-wagon"]["Battle-Wagon-2"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 29, g = 127, b = 12 } } }
		data.raw["item-with-entity-data"]["Battle-Wagon-2"].icon = nil
		data.raw["item-with-entity-data"]["Battle-Wagon-2"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 29, g = 127, b = 12 } } }
	end

	if settings["startup"]["Battle-Wagon-3"].value then
		Senpais.Functions.Create.Battle_Wagon( "Battle-Wagon-3", nil, 60, 2000, 6000, 1.9, { r = 156, g = 66, b = 150 }, "Senpais-Trains", "transport",
											   "a[train-system]-gac[Battle-Wagon-3]", 5, { { "Battle-Wagon-2", 1 }, { "power-armor-mk2", 1 } }, "power-armor-2" )

		data.raw["cargo-wagon"]["Battle-Wagon-3"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 156, g = 66, b = 150 } } }
		data.raw["item-with-entity-data"]["Battle-Wagon-3"].icon = nil
		data.raw["item-with-entity-data"]["Battle-Wagon-3"].icons = { { icon = "__base__/graphics/icons/cargo-wagon.png", tint = { r = 156, g = 66, b = 150 } } }
	end
end

if settings["startup"]["braking-force-8"].value then
	local braking_force_8 = util.table.deepcopy( data.raw["technology"]["braking-force-7"] )
	braking_force_8.name = "braking-force-8"
	braking_force_8.effects = { { type = "train-braking-force-bonus", modifier = 0.30 } }
	braking_force_8.prerequisites = { "braking-force-7" }
	braking_force_8.unit.count = 800

	data:extend( { braking_force_8 } )

	if settings["startup"]["braking-force-9"].value then
		local braking_force_9 = util.table.deepcopy( data.raw["technology"]["braking-force-7"] )
		braking_force_9.name = "braking-force-9"
		braking_force_9.effects = { { type = "train-braking-force-bonus", modifier = 0.50 } }
		braking_force_9.prerequisites = { "braking-force-8" }
		braking_force_9.unit.count = 1000

		data:extend( { braking_force_9 } )
	end
end

if settings["startup"]["Senpais-Dora"].value then
	local dora_entity = util.table.deepcopy( data.raw["artillery-wagon"]["artillery-wagon"] )
	dora_entity.name = artillery_train_name
	dora_entity.icon = MODNAME .. "/graphics/dora.png"
	dora_entity.minable.result = artillery_train_name
	dora_entity.max_health = 1000
	dora_entity.weight = 8000
	dora_entity.gun = "dora-gun"
	dora_entity.pictures.layers[1].filenames =
	{
     MODNAME .. "/graphics/artillery-wagon-base-1.png",
     MODNAME .. "/graphics/artillery-wagon-base-2.png",
     MODNAME .. "/graphics/artillery-wagon-base-3.png",
     MODNAME .. "/graphics/artillery-wagon-base-4.png",
     MODNAME .. "/graphics/artillery-wagon-base-5.png",
     MODNAME .. "/graphics/artillery-wagon-base-6.png",
     MODNAME .. "/graphics/artillery-wagon-base-7.png",
     MODNAME .. "/graphics/artillery-wagon-base-8.png",
     MODNAME .. "/graphics/artillery-wagon-base-9.png",
     MODNAME .. "/graphics/artillery-wagon-base-10.png",
     MODNAME .. "/graphics/artillery-wagon-base-11.png",
     MODNAME .. "/graphics/artillery-wagon-base-12.png",
     MODNAME .. "/graphics/artillery-wagon-base-13.png",
     MODNAME .. "/graphics/artillery-wagon-base-14.png",
     MODNAME .. "/graphics/artillery-wagon-base-15.png",
     MODNAME .. "/graphics/artillery-wagon-base-16.png",
    }
    dora_entity.pictures.layers[1].hr_version.filenames =
    {
     MODNAME .. "/graphics/hr-artillery-wagon-base-1.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-2.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-3.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-4.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-5.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-6.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-7.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-8.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-9.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-10.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-11.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-12.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-13.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-14.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-15.png",
     MODNAME .. "/graphics/hr-artillery-wagon-base-16.png",
    }

	local dora_gun = util.table.deepcopy( data.raw["gun"]["artillery-wagon-cannon"] )
	dora_gun.name = "dora-gun"
	dora_gun.order = "z[artillery]-b[dora]"
	dora_gun.attack_parameters.ammo_category = "dora-shell"
	dora_gun.attack_parameters.range = 10 * 32
	dora_gun.attack_parameters.min_range = 2 * 32

	local dora_ammo = util.table.deepcopy( data.raw["ammo"]["artillery-shell"] )
	dora_ammo.name = "dora-shell"
	dora_ammo.icon = MODNAME .. "/graphics/dora-shell.png"
	dora_ammo.ammo_type.category = "dora-shell"
	dora_ammo.ammo_type.action.action_delivery.projectile = "dora-projectile"
	dora_ammo.order = "d[explosive-cannon-shell]-e[dora]"

	local dora_projectile = util.table.deepcopy( data.raw["artillery-projectile"]["artillery-projectile"] )
	dora_projectile.name = "dora-projectile"
	dora_projectile.chart_picture.filename = MODNAME .. "/graphics/dora-shoot-map-visualization.png"
	dora_projectile.action.action_delivery.target_effects =
	{ { repeat_count = 250, type = "create-trivial-smoke", smoke_name = "nuclear-smoke", offset_deviation = { { -1, -1}, { 1, 1 } }, slow_down_factor = 1,
	   starting_frame = 3, starting_frame_deviation = 5, starting_frame_speed = 0, starting_frame_speed_deviation = 5, speed_from_center = 0.5, speed_deviation = 0.2  },
	  { type = "create-entity", entity_name = "explosion" },
	  { type = "destroy-cliffs", radius = 50, explosion = "explosion" },
	  { type = "damage", damage = { amount = 2500, type = "explosion" } },
	  { type = "create-entity", entity_name = "small-scorchmark", check_buildability = true },
	  { type = "nested-result", action = { type = "area", target_entities = false, repeat_count = 7500, radius = 75, action_delivery =
	    { type = "projectile", projectile = "dora-atomic-wave", starting_speed = 0.5 } } } }

    local dora_atomic_wave =
    {
     type = "projectile",
     name = "dora-atomic-wave",
     flags = { "not-on-map" },
     acceleration = 0,
     action = { { type = "direct", action_delivery = { type = "instant", target_effects = { { type = "create-entity", entity_name = "explosion" } } } },
    		    { type = "area", radius = 5, action_delivery = { type = "instant", target_effects = { { type = "damage", damage = { amount = 2000, type = "explosion" } } } } } },
     animation = { filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high" },
     shadow = { filename = "__core__/graphics/empty.png", frame_count = 1, width = 1, height = 1, priority = "high" }
    }

	local dora_item = util.table.deepcopy( data.raw["item-with-entity-data"]["artillery-wagon"] )
	dora_item.name = artillery_train_name
	dora_item.icon = MODNAME .. "/graphics/dora.png"
	dora_item.order = "a[train-system]-ia[dora]"
	dora_item.place_result = artillery_train_name

	local dora_recipe = util.table.deepcopy( data.raw["recipe"]["artillery-wagon"] )
	dora_recipe.name = artillery_train_name
	dora_recipe.ingredients[1] = { "artillery-wagon", 1 }
	dora_recipe.result = artillery_train_name

	local dora_ammo_recipe = util.table.deepcopy( data.raw["recipe"]["artillery-shell"] )
	dora_ammo_recipe.name = "dora-shell"
	dora_ammo_recipe.ingredients = { { "artillery-shell", 2 }, { "atomic-bomb", 4 }, { "explosives", 50 } }
	dora_ammo_recipe.result = "dora-shell"

	local dora_tech = util.table.deepcopy( data.raw["technology"]["artillery"] )
	dora_tech.name = "dora"
	dora_tech.icon = MODNAME .. "/graphics/dora-tech.png"
	dora_tech.effects = { { type = "unlock-recipe", recipe = artillery_train_name }, { type = "unlock-recipe", recipe = "dora-shell" } }
	dora_tech.prerequisites = { "artillery" }
	dora_tech.unit.count = 2500

	table.insert( dora_tech.unit.ingredients, { "space-science-pack", 1 } )

	data:extend( { { type = "ammo-category", name = "dora-shell" }, dora_entity, dora_gun, dora_ammo, dora_projectile, dora_atomic_wave, dora_item, dora_recipe, dora_ammo_recipe, dora_tech } )
end

if settings["startup"]["Coupling"].value then
	local couple_signal = util.table.deepcopy( data.raw["virtual-signal"]["signal-1"] )
	couple_signal.name = "signal-couple"
	couple_signal.icon = MODNAME .. "/graphics/signal-couple.png"
	couple_signal.subgroup = "coupling-signals"
	couple_signal.order = "a"

	local decouple_signal = util.table.deepcopy( data.raw["virtual-signal"]["signal-1"] )
	decouple_signal.name = "signal-decouple"
	decouple_signal.icon = MODNAME .. "/graphics/signal-decouple.png"
	decouple_signal.subgroup = "coupling-signals"
	decouple_signal.order = "b"

	data:extend( { { type = "item-subgroup", name = "coupling-signals", group = "signals", order = "gg" }, couple_signal, decouple_signal } )
end