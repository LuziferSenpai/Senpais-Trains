require "config"

local MODNAME = "__Senpais_Trains__"

-- Senpais.Functions.Create

function Senpais.Functions.Create.Elec_Locomotive( multiplier, name, icon, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )
	local MaxPower = multiplier * 600 .. "kW"
	local train_entity = util.table.deepcopy( data.raw["locomotive"]["locomotive"] )
	train_entity.name = name
	train_entity.icon = icon
	train_entity.minable.result = name
	train_entity.max_health = health
	train_entity.weight = weight
	train_entity.max_speed = speed
	train_entity.max_power = MaxPower
	train_entity.burner = { effictivity = 1, fuel_inventory_size = 0 }

	Senpais.Functions.Replace.mask_image_filenames( train_entity.pictures.layers, "diesel-locomotive" )

	train_entity.color = color
	if grid ~=  nil then
		train_entity.equipment_grid = grid
	end

	local train_item = util.table.deepcopy( data.raw["item-with-entity-data"]["locomotive"] )
	train_item.name = name
	train_item.icon = icon
	train_item.subgroup = subgroup
	train_item.order = order
	train_item.place_result = name
	train_item.stack_size = stack

	local train_recipe = util.table.deepcopy( data.raw["recipe"]["locomotive"] )
	train_recipe.name = name
	train_recipe.ingredients = ingredients
	train_recipe.result = name

	data:extend( { train_entity, train_item, train_recipe } )

	table.insert( data.raw["technology"][tech].effects, { type = "unlock-recipe", recipe = name } )
end

function Senpais.Functions.Create.Battle_Locomotive( multiplier, name, icon, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )
	local MaxPower = multiplier * 600 .. "kW"
	local train_entity = util.table.deepcopy( data.raw["locomotive"]["locomotive"] )
	train_entity.name = name
	train_entity.icon = icon
	train_entity.minable.result = name
	train_entity.max_health = health
	train_entity.weight = weight
	train_entity.max_speed = speed
	train_entity.max_power = MaxPower

	Senpais.Functions.Replace.mask_image_filenames( train_entity.pictures.layers, "diesel-locomotive" )

	train_entity.color = color
	train_entity.equipment_grid = grid

	local train_item = util.table.deepcopy( data.raw["item-with-entity-data"]["locomotive"] )
	train_item.name = name
	train_item.icon = icon
	train_item.subgroup = subgroup
	train_item.order = order
	train_item.place_result = name
	train_item.stack_size = stack

	local train_recipe = util.table.deepcopy( data.raw["recipe"]["locomotive"] )
	train_recipe.name = name
	train_recipe.ingredients = ingredients
	train_recipe.result = name

	data:extend( { train_entity, train_item, train_recipe } )

	table.insert( data.raw["technology"][tech].effects, { type = "unlock-recipe", recipe = name } )
end

function Senpais.Functions.Create.Battle_Wagon( name, icon, inventory, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )
	local wagon_entity = util.table.deepcopy( data.raw["cargo-wagon"]["cargo-wagon"] )
	wagon_entity.name = name
	wagon_entity.icon = icon
	wagon_entity.inventory_size = inventory
	wagon_entity.minable.result = name
	wagon_entity.max_health = health
	wagon_entity.weight = weight
	wagon_entity.max_speed = speed

	Senpais.Functions.Replace.mask_image_filenames( wagon_entity.pictures.layers, "cargo-wagon" )
	Senpais.Functions.Replace.mask_image_filenames( wagon_entity.horizontal_doors.layers, "cargo-wagon" )
	Senpais.Functions.Replace.mask_image_filenames( wagon_entity.vertical_doors.layers, "cargo-wagon" )

	wagon_entity.color = color
	wagon_entity.equipment_grid = grid

	local wagon_item = util.table.deepcopy( data.raw["item-with-entity-data"]["cargo-wagon"] )
	wagon_item.name = name
	wagon_item.icon = icon
	wagon_item.subgroup = subgroup
	wagon_item.order = order
	wagon_item.place_result = name
	wagon_item.stack_size = stack

	local wagon_recipe = util.table.deepcopy( data.raw["recipe"]["cargo-wagon"] )
	wagon_recipe.name = name
	wagon_recipe.ingredients = ingredients
	wagon_recipe.result = name

	data:extend( { wagon_entity, wagon_item, wagon_recipe } )

	table.insert( data.raw["technology"][tech].effects, { type = "unlock-recipe", recipe = name } )
end

function Senpais.Functions.Create.Grid( name, width, height, categories )
	local grid = util.table.deepcopy( data.raw["equipment-grid"]["large-equipment-grid"] )
	grid.name = name
	grid.width = width
	grid.height = height
	grid.equipment_categories = categories

	data:extend( { grid } )
end

function Senpais.Functions.Create.Sprite32x32( name, filename )
	return { type = "sprite", name = name, filename = filename, priority = "extra-high-no-scale", width = 32, height = 32, scale = 1 }
end

-- Senpais.Functions.Replace

function Senpais.Functions.Replace.filesnames_in_layer( layer, entity )
	if layer.filenames then
		for i, filename in pairs( layer.filenames ) do
			layer.filenames[i] = string.gsub( filename, "__base__/graphics/entity/" .. entity, MODNAME .. "/graphics/" )
		end
	end
	if layer.filename then
		layer.file = string.gsub( layer.filename, "__base__/graphics/entity/" .. entity , MODNAME .. "/graphics/" )
	end
end

function Senpais.Functions.Replace.mask_image_filenames( layers, entity )
	for _, layer in pairs( layers ) do
		if layer.apply_runtime_tint == true then
			Senpais.Functions.Replace.filesnames_in_layer( layer, entity )
			if layer.hr_version then
				Senpais.Functions.Replace.filesnames_in_layer( layer.hr_version, entity )
			end
		end 
	end
end

-- GUI

function Senpais_Trains_MainGUI( player )
	local A01 = Senpais_Trains_Add_Frame( mod_gui.get_frame_flow( player), "SenpaisGUI", "outer_frame" )
	local A02 = Senpais_Trains_Add_Table( A01, "SenpaisGUITable01", 4 )
	local A03 = { Senpais_Trains_Add_Frame( A02, "SenpaisGUIHiddenFrame01", "outer_frame" ),
				  Senpais_Trains_Add_Frame( A02, "SenpaisGUIHiddenFrame02", "outer_frame" ),
				  Senpais_Trains_Add_Frame( A02, "SenpaisGUIHiddenFrame03", "outer_frame" ),
				  Senpais_Trains_Add_Frame( A02, "SenpaisGUIHiddenFrame04", "outer_frame" ) }
	local A04 = Senpais_Trains_Add_Frame( A03[1], "SenpaisGUIFrame01" )
	local A05 = { Senpais_Trains_Add_Sprite_Button( A04, "SenpaisCountTrainsButton", "Train-Count" ),
				  Senpais_Trains_Add_Sprite_Button( A04, "SenpaisCountWagonsButton", "Wagon-Count" ),
				  Senpais_Trains_Add_Sprite_Button( A04, "SenpaisCountFluidWagonsButton", "FluidWagon-Count" ) }
	if settings.startup["Smarter-Trains"].value then
		local A06 = Senpais_Trains_Add_Sprite_Button( A04, "SenpaisSmarterTrainsGUIMainButton", "Senpais-Smart-Stop-Icon" )
	end
	if settings.startup["Senpais-Power-Provider"].value then
		local A07 = Senpais_Trains_Add_Sprite_Button( A04, "SenpaisElectricTrainsStatesButton", "item/Senpais-Power-Provider" )
	end
end

function Senpais_Trains_DestroyChildren( children, number )
	local count = number or 1
	if #children > ( number - 1 ) then
		for i = count, #children do
			children[i].clear()
		end
	end
end

function Senpais_Trains_SmarterTrainsGUIMain( parent )
	local B01 = Senpais_Trains_Add_Frame( parent, "SenpaisSmarterTrainsGUIFrame01" )
	local B02 = Senpais_Trains_Add_Table( B01, "SenpaisSmarterTrainsGUITable01", 4 )
	local B03 = { Senpais_Trains_Add_Drop_Down( B02, "SenpaisSmarterTrainsGUIDropDown", global.SenpaisLines ),
				  Senpais_Trains_Add_Choose_Elem_Button_Signal( B02, "SenpaisSmarterTrainsGUIElemButton01" ),
				  Senpais_Trains_Add_Sprite_Button( B02, "SenpaisSmarterTrainsGUISpriteButton01", "Senpais-plus" ),
				  Senpais_Trains_Add_Sprite_Button( B02, "SenpaisSmarterTrainsGUISpriteButton02", "utility/trash_bin" ) }
end

function Senpais_Trains_SmarterTrainsGUIMainList( parent )
	if parent.children[2] then parent.children[2].destroy() end
	local C01 = Senpais_Trains_Add_Scroll_Pane( parent, "SenpaisSmarterTrainsGUIScrollPane" )
	C01.style.maximal_height = 300
	local C02 = Senpais_Trains_Add_Frame( C01, "SenpaisSmarterTrainsGUIFrame02", "image_frame" )
	C02.style.left_padding = 4
	C02.style.right_padding = 8
	C02.style.bottom_padding = 4
	C02.style.top_padding = 4
	local C03 = Senpais_Trains_Add_Table( C02, "SenpaisSmarterTrainsGUITable02", 2 )
	C03.style.horizontal_spacing = 16
	C03.style.vertical_spacing = 8
	C03.style.column_alignments[2] = "right"
	C03.draw_horizontal_line_after_headers = true
	C03.draw_vertical_lines = true
	local C04 = { Senpais_Trains_Add_Label( C03, "SenpaisSmarterTrainsGUILabels01", "Stations" ),
				  Senpais_Trains_Add_Label( C03, "SenpaisSmarterTrainsGUILabels02", "Signals" ) }
	for _, h in pairs( global.SenpaisScheduleLinesSignals[global.SenpaisLines[parent.children[1].children[1].selected_index]] ) do
		local C05 = { Senpais_Trains_Add_Label( C03, "SenpaisSmarterTrainsGUILabels03_" .. h.station, h.station ),
					  Senpais_Trains_Add_Choose_Elem_Button_Signal( C03, "SenpaisSmarterTrainsGUIElemButton02_" .. h.station, Senpais_Trains_Check( h.signal ) ) }
	end
end

function Senpais_Trains_SmarterTrainsGUIAdd( parent )
	local D01 = Senpais_Trains_Add_Frame( parent, "SenpaisSmarterTrainsGUIFrame03" )
	local D02 = Senpais_Trains_Add_Table( D01, "SenpaisSmarterTrainsGUITable03", 2 )
	local D03 = { Senpais_Trains_Add_Textfield( D02, "SenpaisSmarterTRainsGUITextfield" ),
				  Senpais_Trains_Add_Choose_Elem_Button_Signal( D02, "SenpaisSmarterTrainsGUIElemButton03" ),
				  Senpais_Trains_Add_Button( D01, "SenpaisSmarterTrainsGUIButton", "Add Linie" ) }
end

function Senpais_Trains_CountTrainsGUIMain( parent )
	local E01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountTrainsFrame01" )
	local E02 = { Senpais_Trains_Add_Label( E01, "SenpaisCountTrainsLabel01", "Train Counter" ),
				  Senpais_Trains_Add_Scroll_Pane( E01, "SenpaisCountTrainsScrollPane01" ) }
	E02[2].style.maximal_height = 270
	local E03 = Senpais_Trains_Add_Frame( E02[2], "SenpaisCountTrainsFrame02", "image_frame" )
	E03.style.left_padding = 4
	E03.style.right_padding = 8
	E03.style.bottom_padding = 4
	E03.style.top_padding = 4
	local E04 = Senpais_Trains_Add_Table( E03, "SenpaisCountTrainsTable01", 3 )
	E04.style.column_alignments[2] = "center"
	E04.style.column_alignments[3] = "right"
	E04.style.horizontal_spacing = 16
	E04.style.vertical_spacing = 8
	E04.draw_horizontal_line_after_headers = true
	E04.draw_vertical_lines = true
	local E05 = { Senpais_Trains_Add_Label( E04, "SenpaisCountTrainsLabel02", "Icon" ),
				  Senpais_Trains_Add_Label( E04, "SenpaisCountTrainsLabel03", "Count" ),
				  Senpais_Trains_Add_Label( E04, "SenpaisCountTrainsLabel04" ) }
	global.PlayerDATA[game.players[parent.player_index].index].TrainsCount = {}
	for _, entity in pairs( game.players[parent.player_index].surface.find_entities_filtered{ type = "locomotive" } ) do
		found = false
		for _, q in pairs( global.PlayerDATA[game.players[parent.player_index].index].TrainsCount ) do
			if q.name == entity.name then
				table.insert( q.entities, entity )
				found = true
				break
			end
		end
		if not found then
			table.insert( global.PlayerDATA[game.players[parent.player_index].index].TrainsCount, { name = entity.name, entities = { entity } } )
		end
	end
	for _, t in pairs( global.PlayerDATA[game.players[parent.player_index].index].TrainsCount ) do
		local E06 = { Senpais_Trains_Add_Sprite( E04, "SenpaisCountTrainsSprite_" .. t.name, "item/" .. t.name ),
					  Senpais_Trains_Add_Label( E04, "SenpaisCountTrainsLabel05_" .. t.name, #t.entities ),
					  Senpais_Trains_Add_Button( E04, "SenpaisCountTrainsButton01_" .. t.name, "List All" ) }
	end
end

function Senpais_Trains_CountTrainsGUIList( parent, part )
	global.PlayerDATA[game.players[parent.player_index].index].EntityName = part.name
	local F01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountTrainsFrame03" )
	local F02 = { Senpais_Trains_Add_Label( F01, "SenpaisCountTrainsLabel04", "All placed Trains of this Type" ),
				  Senpais_Trains_Add_Scroll_Pane( F01, "SenpaisCountTrainsScrollPane02" ) }
	F02[2].style.maximal_height = 270
	local F03 = Senpais_Trains_Add_Frame( F02[2], "SenpaisCountTrainsFrame04", "image_frame" )
	F03.style.left_padding = 4
	F03.style.right_padding = 8
	F03.style.bottom_padding = 4
	F03.style.top_padding = 4
	local F04 = Senpais_Trains_Add_Table( F03, "SenpaisCountTrainsTable02", 5 )
	F04.style.column_alignments[2] = "center"
	F04.style.column_alignments[3] = "center"
	F04.style.column_alignments[4] = "right"
	F04.style.horizontal_spacing = 16
	F04.style.vertical_spacing = 8
	F04.draw_horizontal_line_after_headers = true
	F04.draw_vertical_lines = true
	local F05 = { Senpais_Trains_Add_Label( F04, "SenpaisCountTrainsLabel05", "Backer Name" ),
				  Senpais_Trains_Add_Label( F04, "SenpaisCountTrainsLabel06", "Player Kills" ),
				  Senpais_Trains_Add_Label( F04, "SenpaisCountTrainsLabel07", "Unique Train ID" ),
				  Senpais_Trains_Add_Label( F04, "SenpaisCountTrainsLabel08", "Health" ),
				  Senpais_Trains_Add_Label( F04, "SenpaisCountTrainsLabel09" ) }
	for u = 1, #part.entities do
		local F06 = { Senpais_Trains_Add_Frame( F04, "SenpaisCountTrainsFrame05_" .. part.name .. "_" .. u, "outer_frame" ),
					  Senpais_Trains_Add_Frame( F04, "SenpaisCountTrainsFrame06_" .. part.name .. "_" .. u, "outer_frame" ),
					  Senpais_Trains_Add_Frame( F04, "SenpaisCountTrainsFrame07_" .. part.name .. "_" .. u, "outer_frame" ),
					  Senpais_Trains_Add_Frame( F04, "SenpaisCountTrainsFrame08_" .. part.name .. "_" .. u, "outer_frame" ),
					  Senpais_Trains_Add_Frame( F04, "SenpaisCountTrainsFrame09_" .. part.name .. "_" .. u, "outer_frame" ) }
		local F07 = Senpais_Trains_Add_Label( F06[1], "SenpaisCountTrainsLabel10_" .. part.name .. "_" .. u, part.entities[u].backer_name )
		if #part.entities[u].train.killed_players > 0 then
			for id, count in pairs( part.entities[u].train.killed_players ) do
				local F08 = Senpais_Trains_Add_Label( F06[2], "SenpaisCountTrainsLabel11_" .. part.name .. "_" .. u, "- " .. game.players[id].name .. ": " .. count )
			end
		end
		local F09 ={  Senpais_Trains_Add_Label( F06[3], "SenpaisCountTrainsLabel12_" .. part.name .. "_" .. u, part.entities[u].train.id ),
					  Senpais_Trains_Add_Label( F06[4], "SenpaisCountTrainsLabel13_" .. part.name .. "_" .. u, part.entities[u].health .. "/" .. part.entities[u].prototype.max_health ),
					  Senpais_Trains_Add_Button( F06[5], "SenpaisCountTrainsButton02_" .. part.name .. "_" .. u, "Edit Train" ) }
	end
end

function Senpais_Trains_CountTrainsGUIEntityEdit( parent, entity )
	if parent.children[1] then parent.children[1].destroy() end
	local G01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountTrainsFrame10" )
	local G02 = Senpais_Trains_Add_Textfield( G01, "SenpaisCountTrainsTextfield", entity.backer_name )
	if settings.startup["Smarter-Trains"].value then
		local G03 = { Senpais_Trains_Add_Drop_Down( G01, "SenpaisCountTrainsDropDown", global.SenpaisLines ),
					  Senpais_Trains_Add_Scroll_Pane( G01, "SenpaisCountTrainsScrollPane02" ) }
		G03[2].style.maximal_height = 300
	end
	local G04 = Senpais_Trains_Add_Button( G01, "SenpaisCountTrainsButton03", "Apply Changes" )
end

function Senpais_Trains_CountTrainsGUIEntityEditList( parent, index )
	if parent.children[1] then parent.clear() end
	local H01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountTrainsFrame11", "image_frame" )
	H01.style.left_padding = 4
	H01.style.right_padding = 8
	H01.style.bottom_padding = 4
	H01.style.top_padding = 4
	local H02 = Senpais_Trains_Add_Table( H01, "SenpaisCountTrainsTable03", 2 )
	H02.style.horizontal_spacing = 16
	H02.style.vertical_spacing = 8
	H02.style.column_alignments[2] = "right"
	H02.draw_horizontal_line_after_headers = true
	H02.draw_vertical_lines = true
	local H03 = { Senpais_Trains_Add_Label( H02, "SenpaisCountTrainsLabel14" ),
				  Senpais_Trains_Add_Label( H02, "SenpaisCountTrainsLabel15", "Stations" ) }
	for _, t in pairs( global.SenpaisScheduleLinesSignals[global.SenpaisLines[index]] ) do
		local H04 = { Senpais_Trains_Add_RadioButton( H02, "SenpaisCountTrainsRadioButton_" .. t.station ),
					  Senpais_Trains_Add_Label( H02, "SenpaisCountTrainsLabel16_" .. t.station, t.station ) }
	end
end

function Senpais_Trains_CountWagonsGUIMain( parent )
	local I01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountWagonsFrame01" )
	local I02 = { Senpais_Trains_Add_Label( I01, "SenpaisCountWagonsLabel01", "Wagon Counter" ),
				  Senpais_Trains_Add_Scroll_Pane( I01, "SenpaisCountWagonsScrollPane01" ) }
	I02[2].style.maximal_height = 270
	local I03 = Senpais_Trains_Add_Frame( I02[2], "SenpaisCountWagonsFrame02", "image_frame" )
	I03.style.left_padding = 4
	I03.style.right_padding = 8
	I03.style.bottom_padding = 4
	I03.style.top_padding = 4
	local I04 = Senpais_Trains_Add_Table( I03, "SenpaisCountWagonsTable01", 3 )
	I04.style.column_alignments[2] = "center"
	I04.style.column_alignments[3] = "right"
	I04.style.horizontal_spacing = 16
	I04.style.vertical_spacing = 8
	I04.draw_horizontal_line_after_headers = true
	I04.draw_vertical_lines = true
	local I05 = { Senpais_Trains_Add_Label( I04, "SenpaisCountWagonsLabel02", "Icon" ),
				  Senpais_Trains_Add_Label( I04, "SenpaisCountWagonsLabel03", "Count" ),
				  Senpais_Trains_Add_Label( I04, "SenpaisCountWagonsLabel04" ) }
	global.PlayerDATA[game.players[parent.player_index].index].WagonsCount = {}
	for _, entity in pairs( game.players[parent.player_index].surface.find_entities_filtered{ type = "cargo-wagon" } ) do
		found = false
		for _, l in pairs( global.PlayerDATA[game.players[parent.player_index].index].WagonsCount ) do
			if l.name == entity.name then
				table.insert( l.entities, entity )
				found = true
				break
			end
		end
		if not found then
			table.insert( global.PlayerDATA[game.players[parent.player_index].index].WagonsCount, { name = entity.name, entities = { entity } } )
		end
	end
	for _, x in pairs( global.PlayerDATA[game.players[parent.player_index].index].WagonsCount ) do
		local I06 = { Senpais_Trains_Add_Sprite( I04, "SenpaisCountWagonsSprite01_" .. x.name, "item/" .. x.name ),
					  Senpais_Trains_Add_Label( I04, "SenpaisCountWagonsLabel05_" .. x.name, #x.entities ),
					  Senpais_Trains_Add_Button( I04, "SenpaisCountWagonsButton_" .. x.name, "List All" ) }
	end
end

function Senpais_Trains_CountWagonsGUIList( parent, part )
	local J01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountWagonsFrame03" )
	local J02 = { Senpais_Trains_Add_Label( J01, "SenpaisCountWagonsLabel06", "All placed Wagons of this Type" ),
				  Senpais_Trains_Add_Scroll_Pane( J01, "SenpaisCountWagonsScrollPane02" ) }
	J02[2].style.maximal_height = 270
	local J03 = Senpais_Trains_Add_Frame( J02[2], "SenpaisCountWagonsFrame04", "image_frame" )
	J03.style.left_padding = 4
	J03.style.right_padding = 8
	J03.style.bottom_padding = 4
	J03.style.top_padding = 4
	local J04 = Senpais_Trains_Add_Table( J03, "SenpaisCountWagonsTable02", 4 )
	J04.style.column_alignments[2] = "center"
	J04.style.column_alignments[4] = "center"
	J04.style.horizontal_spacing = 16
	J04.style.vertical_spacing = 8
	J04.draw_horizontal_line_after_headers = true
	J04.draw_vertical_lines = true
	J04.draw_horizontal_lines = true
	local J05 = { Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame05", "outer_frame" ),
				  Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame06", "outer_frame" ),
				  Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame07", "outer_frame" ),
				  Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame08", "outer_frame" ) }
	local J06 = { Senpais_Trains_Add_Label( J05[1], "SenpaisCountWagonsLabel07", "Health" ),
				  Senpais_Trains_Add_Table( J05[2], "SenpaisCountWagonsTable03", 2 ),
				  Senpais_Trains_Add_Label( J05[3], "SenpaisCountWagonsLabel08", "Health" ),
				  Senpais_Trains_Add_Table( J05[4], "SenpaisCountWagonsTable04", 2 ) }
	J06[2].style.column_alignments[2] = "right"
	J06[2].style.horizontal_spacing = 16
	J06[2].style.vertical_spacing = 8
	J06[4].style.column_alignments[2] = "right"
	J06[4].style.horizontal_spacing = 16
	J06[4].style.vertical_spacing = 8
	local J07 = { Senpais_Trains_Add_Label( J06[2], "SenpaisCountWagonsLabel09", "Icon" ),
				  Senpais_Trains_Add_Label( J06[2], "SenpaisCountWagonsLabel10", "Load" ),
				  Senpais_Trains_Add_Label( J06[4], "SenpaisCountWagonsLabel11", "Icon" ),
				  Senpais_Trains_Add_Label( J06[4], "SenpaisCountWagonsLabel12", "Load" ) }
	for f = 1, #part.entities do
		local J08 = { Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame09_" .. part.name .. "_" .. f, "outer_frame" ),
					  Senpais_Trains_Add_Frame( J04, "SenpaisCountWagonsFrame10_" .. part.name .. "_" .. f, "outer_frame" ) }
		local J09 ={ Senpais_Trains_Add_Label( J08[1], "SenpaisCountWagonsLabel13_" .. part.name .. "_" .. f, part.entities[f].health .. "/" .. part.entities[f].prototype.max_health ),
					 Senpais_Trains_Add_Table( J08[2], "SenpaisCountWagonsTable05_" .. part.name .. "_" .. f, 2 ) }
		J09[2].style.column_alignments[2] = "right"
		J09[2].style.horizontal_spacing = 16
		J09[2].style.vertical_spacing = 8
		for name, count in pairs( part.entities[f].get_inventory( defines.inventory.cargo_wagon ).get_contents() ) do
			local J10 = { Senpais_Trains_Add_Sprite( J09[2], "SenpaisCountWagonsSprite02_" .. part.name .. "_" .. f .. "_" .. name, "item/" .. name ),
						  Senpais_Trains_Add_Label( J09[2], "SenpaisCountWagonsLabel14_" .. part.name .. "_" .. f .. "_" .. name, count ) }
		end
	end
end

function Senpais_Trains_CountFluidWagonsGUIMain( parent )
	local K01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountFluidWagonsFrame01" )
	local K02 = { Senpais_Trains_Add_Label( K01, "SenpaisCountFluidWagonsLabel01", "Fluid Wagon Counter" ),
				  Senpais_Trains_Add_Scroll_Pane( K01, "SenpaisCountFluidWagonsScrollPane01" ) }
	K02[2].style.maximal_height = 270
	local K03 = Senpais_Trains_Add_Frame( K02[2], "SenpaisCountFluidWagonsFrame02", "image_frame" )
	K03.style.left_padding = 4
	K03.style.right_padding = 8
	K03.style.bottom_padding = 4
	K03.style.top_padding = 4
	local K04 = Senpais_Trains_Add_Table( K03, "SenpaisCountFluidWagonsTable01", 3 )
	K04.style.column_alignments[2] = "center"
	K04.style.column_alignments[3] = "right"
	K04.style.horizontal_spacing = 16
	K04.style.vertical_spacing = 8
	K04.draw_horizontal_line_after_headers = true
	K04.draw_vertical_lines = true
	local K05 = { Senpais_Trains_Add_Label( K04, "SenpaisCountFluidWagonsLabel02", "Icon" ),
				  Senpais_Trains_Add_Label( K04, "SenpaisCountFluidWagonsLabel03", "Count" ),
				  Senpais_Trains_Add_Label( K04, "SenpaisCountFluidWagonsLabel04" ) }
	global.PlayerDATA[game.players[parent.player_index].index].FluidWagonsCount = {}
	for _, entity in pairs( game.players[parent.player_index].surface.find_entities_filtered{ type = "fluid-wagon" } ) do
		found = false
		for _, t in pairs( global.PlayerDATA[game.players[parent.player_index].index].FluidWagonsCount ) do
			if t.name == entity.name then
				table.insert( t.entities, entity )
				found = true
				break
			end
		end
		if not found then
			table.insert( global.PlayerDATA[game.players[parent.player_index].index].FluidWagonsCount, { name = entity.name, entities = { entity } } )
		end
	end
	for _, b in pairs( global.PlayerDATA[game.players[parent.player_index].index].FluidWagonsCount ) do
		local K06 = { Senpais_Trains_Add_Sprite( K04, "SenpaisCountFluidWagonsSprite01_" .. b.name, "item/" .. b.name ),
					  Senpais_Trains_Add_Label( K04, "SenpaisCountFluidWagonsLabel05_" .. b.name, #b.entities ),
					  Senpais_Trains_Add_Button( K04, "SenpaisCountFluidWagonsButton_" .. b.name, "List All" ) }
	end
end

function Senpais_Trains_CountFluidWagonsGUIList( parent, part )
	local L01 = Senpais_Trains_Add_Frame( parent, "SenpaisCountFluidWagonsFrame03" )
	local L02 = { Senpais_Trains_Add_Label( L01, "SenpaisCountFluidWagonsLabel06", "All placed Fluid Wagons of this Type" ),
				  Senpais_Trains_Add_Scroll_Pane( L01, "SenpaisCountFluidWagonsScrollPane02" ) }
	L02[2].style.maximal_height = 270
	local L03 = Senpais_Trains_Add_Frame( L02[2], "SenpaisCountFluidWagonsFrame04", "image_frame" )
	L03.style.left_padding = 4
	L03.style.right_padding = 8
	L03.style.bottom_padding = 4
	L03.style.top_padding = 4
	local L04 = Senpais_Trains_Add_Table( L03, "SenpaisCountFluidWagonsTable02", 2 )
	L04.style.column_alignments[2] = "right"
	L04.style.horizontal_spacing = 16
	L04.style.vertical_spacing = 8
	L04.draw_horizontal_line_after_headers = true
	L04.draw_vertical_lines = true
	L04.draw_horizontal_lines = true
	local L05 = { Senpais_Trains_Add_Label( L04, "SenpaisCountFluidWagonsLabel07", "Health" ),
				  Senpais_Trains_Add_Frame( L04, "SenpaisCountFluidWagonsFrame05", "outer_frame" ) }
	local L06 = Senpais_Trains_Add_Table( L05[2], "SenpaisCountFluidWagonsTable03", 2 )
	L06.style.column_alignments[2] = "right"
	L06.style.horizontal_spacing = 16
	L06.style.vertical_spacing = 8
	L06.draw_vertical_lines = true
	local L07 = { Senpais_Trains_Add_Label( L06, "SenpaisCountFluidWagonsLabel08", "Fluid" ),
				  Senpais_Trains_Add_Label( L06, "SenpaisCountFluidWagonsLabel09", "Load/Max" ) }
	for r = 1, #part.entities do
		local L08 = { Senpais_Trains_Add_Frame( L04, "SenpaisCountFluidWagonsFrame06_" .. part.name .. "_" .. r, "outer_frame" ),
					  Senpais_Trains_Add_Frame( L04, "SenpaisCountFluidWagonsFrame07_" .. part.name .. "_" .. r, "outer_frame" ) }
		local L09 = { Senpais_Trains_Add_Label( L08[1], "SenpaisCountFluidWagonsLabel10_" .. part.name .. "_" .. r, part.entities[r].health .. "/" .. part.entities[r].prototype.max_health ),
					  Senpais_Trains_Add_Table( L08[2], "SenpaisCountFluidWagonsTable04_" .. part.name .. "_" .. r, 2 ) }
		L09[2].style.column_alignments[2] = "right"
		L09[2].draw_vertical_lines = true
		local fluid = part.entities[r].fluidbox
		local hasfluid = false
		for m = 1, #fluid do
			if fluid[m] ~= nil then
				local L10 = { Senpais_Trains_Add_Sprite( L09[2], "SenpaisCountFluidWagonsSprite02_" .. part.name .. "_" .. r .. "_" .. fluid[m].name, "fluid/" .. fluid[m].name ),
							  Senpais_Trains_Add_Progressbar( L09[2], "SenpaisCountFluidWagonsProgressbar _" .. part.name .. "_" .. r .. "_" .. fluid[m].name, part.entities[r].prototype.fluid_capacity, fluid[m].amount / part.entities[r].prototype.fluid_capacity ) }
				L10[2].style.color = game.fluid_prototypes[fluid[m].name].base_color
				hasfluid = true
			end
		end
		if not hasfluid then
			local L10 = Senpais_Trains_Add_Label( L08[2], "SenpaisCountFluidWagonsLabel11_" .. part.name .. "_" .. r, "No Fluid/s loaded" )
		end
	end
end

function Senpais_Trains_ElectricTrainsStatesGUIMain( parent )
	local PowerNeeded = 0
	local PowerProvided = 0
	local PowerTrains = "W"
	local PowerProvider = "kJ"
	for _, y in pairs( global.SenpaisTrainsList ) do
		PowerNeeded = PowerNeeded + ( y.multi * 600 )
	end
	if PowerNeeded > 1000 then
		PowerNeeded = PowerNeeded / 1000
		PowerTrains = "MW"
		if PowerNeeded > 1000 then
			PowerNeeded = PowerNeeded / 1000
			PowerTrains = "GW"
		end
	end
	for _, c in pairs( global.SenpaisAccuList ) do
		PowerProvided = PowerProvided + c.energy
	end
	if PowerProvided > 1000 then
		PowerProvided = Senpais_Trains_Round( PowerProvided / 1000, 2 )
		PowerProvider = "KJ"
		if PowerProvided > 1000 then
			PowerProvided = Senpais_Trains_Round( PowerProvided / 1000, 2 )
			PowerProvider = "MJ"
			if PowerProvided > 1000 then
				PowerProvided = Senpais_Trains_Round( PowerProvided / 1000, 2 )
				PowerProvider = "GJ"
				if PowerProvided > 1000 then
					PowerProvided = Senpais_Trains_Round( PowerProvided / 1000, 2 )
					PowerProvider = "TJ"
				end
			end
		end
	end
	local AccuMaxCapa = 25 * #global.SenpaisAccuList
	local AccuMaxCapaJoule = "MJ"
	if AccuMaxCapa > 1000 then
		AccuMaxCapa = AccuMaxCapa / 1000
		AccuMaxCapaJoule = "GJ"
		if AccuMaxCapa > 1000 then
			AccuMaxCapa = AccuMaxCapa / 1000
			AccuMaxCapaJoule = "TJ"
		end
	end
	local M01 = Senpais_Trains_Add_Frame( parent, "SenpaisElectricTrainsStatesFrame01", "frame_in_right_container" )
	local M02 = { Senpais_Trains_Add_Label( M01, "SenpaisElectricTrainsStatesLabel01", "Electric Trains States" ),
				  Senpais_Trains_Add_Flow( M01, "SenpaisElectricTrainsStatesFlow01", "vertical", "description_vertical_flow" ),
				  Senpais_Trains_Add_Flow( M01, "SenpaisElectricTrainsStatesFlow02", "vertical", "description_vertical_flow" ),
				  Senpais_Trains_Add_Flow( M01, "SenpaisElectricTrainsStatesFlow03", "vertical", "description_vertical_flow" ),
				  Senpais_Trains_Add_Flow( M01, "SenpaisElectricTrainsStatesFlow04", "vertical", "description_vertical_flow" ),
				  Senpais_Trains_Add_Flow( M01, "SenpaisElectricTrainsStatesFlow05", "vertical", "description_vertical_flow" ),
				  Senpais_Trains_Add_Progressbar( M01, "SenpaisElectricTrainsStatesProgressbar", AccuMaxCapa, PowerProvided / AccuMaxCapa ) }
	M02[1].style = "description_title_label"
	M02[7].style = "electric_satisfaction_progressbar"
	local M03 = { Senpais_Trains_Add_Table( M02[2], "SenpaisElectricTrainsStatesTable01", 2 ),
				  Senpais_Trains_Add_Table( M02[3], "SenpaisElectricTrainsStatesTable02", 2 ),
				  Senpais_Trains_Add_Table( M02[4], "SenpaisElectricTrainsStatesTable03", 2 ),
				  Senpais_Trains_Add_Table( M02[5], "SenpaisElectricTrainsStatesTable04", 2 ),
				  Senpais_Trains_Add_Table( M02[6], "SenpaisElectricTrainsStatesTable05", 2 ) }
	local M04 = { Senpais_Trains_Add_Label( M03[1], "SenpaisElectricTrainsStatesLabel02", "Total Provider:" ),
				  Senpais_Trains_Add_Label( M03[1], "SenpaisElectricTrainsStatesLabel03", #global.SenpaisAccuList ),
				  Senpais_Trains_Add_Label( M03[2], "SenpaisElectricTrainsStatesLabel04", "Total Electric Trains:" ),
				  Senpais_Trains_Add_Label( M03[2], "SenpaisElectricTrainsStatesLabel05", #global.SenpaisTrainsList ),
				  Senpais_Trains_Add_Label( M03[3], "SenpaisElectricTrainsStatesLabel06", "Total Power Needed for Trains:" ),
				  Senpais_Trains_Add_Label( M03[3], "SenpaisElectricTrainsStatesLabel07", PowerNeeded .. PowerTrains ),
				  Senpais_Trains_Add_Label( M03[4], "SenpaisElectricTrainsStatesLabel08", "Total Power in Provider:" ),
				  Senpais_Trains_Add_Label( M03[4], "SenpaisElectricTrainsStatesLabel09", PowerProvided .. PowerProvider ),
				  Senpais_Trains_Add_Label( M03[5], "SenpaisElectricTrainsStatesLabel10", "Total Power Provider can Store:" ),
				  Senpais_Trains_Add_Label( M03[5], "SenpaisElectricTrainsStatesLabel11", AccuMaxCapa .. AccuMaxCapaJoule ) }
	M04[1].style = "description_label"
	M04[2].style = "description_value_label"
	M04[3].style = "description_label"
	M04[4].style = "description_value_label"
	M04[5].style = "description_label"
	M04[6].style = "description_value_label"
	M04[7].style = "description_label"
	M04[8].style = "description_value_label"
	M04[9].style = "description_label"
	M04[10].style = "description_value_label"
end

-- GUI Elements

function Senpais_Trains_Add_Sprite_Button( flow, name, sprite, style )
	return flow.add{ type = "sprite-button", name = name, style = style or nil, sprite = sprite }
end

function Senpais_Trains_Add_Frame( flow, name, style )
	return flow.add{ type = "frame", name = name, direction = "vertical", style = style or nil }
end

function Senpais_Trains_Add_Table( flow, name, column_count )
	return flow.add{ type = "table", name = name, column_count = column_count }
end

function Senpais_Trains_Add_Drop_Down( flow, name, items )
	return flow.add{ type = "drop-down", name = name, items = items or nil }
end

function Senpais_Trains_Add_Choose_Elem_Button_Signal( flow, name, signal )
	return flow.add{ type = "choose-elem-button", name = name, elem_type = "signal", signal = signal or nil }
end

function Senpais_Trains_Add_Textfield( flow, name, text )
	return flow.add{ type = "textfield", name = name, text = text or nil }
end

function Senpais_Trains_Add_Button( flow, name, caption )
	return flow.add{ type = "button", name = name, caption = caption or nil }
end

function Senpais_Trains_Add_Scroll_Pane( flow, name )
	return flow.add{ type = "scroll-pane", name = name }
end

function Senpais_Trains_Add_Sprite( flow, name, sprite )
	return flow.add{ type = "sprite", name = name, sprite = sprite }
end

function Senpais_Trains_Add_Label( flow, name, caption )
	return flow.add{ type = "label", name = name, caption = caption or nil }
end

function Senpais_Trains_Add_RadioButton( flow, name, state )
	return flow.add{ type = "radiobutton", name = name, state = state or false }
end

function Senpais_Trains_Add_Progressbar( flow, name, size, value )
	return flow.add{ type = "progressbar", name = name, size = size, value = value or nil }
end

function Senpais_Trains_Add_Flow( flow, name, direction, style )
	return flow.add{ type = "flow", name = name, direction = direction, style = style or nil }
end

-- Script

function Senpais_Trains_globals()
	global.Register = { { name = "Senpais-Electric-Train", multy = 2 }, { name = "Senpais-Electric-Train-Heavy", multy = 5 }, { name = "Elec-Battle-Loco-1", multy = 2 },
						{ name = "Elec-Battle-Loco-2", multy = 4 }, { name = "Elec-Battle-Loco-3", multy = 6 } }
	global.SenpaisTrainsList = global.SenpaisTrainsList or {}
	global.SenpaisAccuList = global.SenpaisAccuList or {}
	global.SenpaisLines = global.SenpaisLines or {}
	global.SenpaisScheduleLines = global.SenpaisScheduleLines or {}
	global.SenpaisScheduleLinesSignals = global.SenpaisScheduleLinesSignals or {}
	global.SenpaisTrainSchedulebyID = global.SenpaisTrainSchedulebyID or {}
	global.PlayerDATA = global.PlayerDATA or {}
end

function Senpais_Trains_Players()
	for _, p in pairs( game.players ) do
		if not mod_gui.get_button_flow( p ).SenpaisGUIButton then
			local button = Senpais_Trains_Add_Sprite_Button( mod_gui.get_button_flow( p ), "SenpaisGUIButton", "Senpais-S" )
			button.style.visible = true
		end
		global.PlayerDATA[p.index] = global.PlayerDATA[p.index] or { TrainsCount = {}, WagonsCount = {}, FluidWagonsCount = {}, EntityName = {}, EntityCount = {} }
		if p.gui.top.SenpaisSmartTrainMainButton then p.gui.top.SenpaisSmartTrainMainButton.destroy() end
		if p.gui.left.SenpaisSmartTrainMainFrame01 then p.gui.left.SenpaisSmartTrainMainFrame01.destroy() end
	end
end

function Senpais_Trains_OnBuild( event )
	local entity = event.created_entity
	if entity.name == "Senpais-Power-Provider" then
		table.insert( global.SenpaisAccuList, entity )
	end
	if entity.type == "locomotive" then
		for _, j in pairs( global.Register ) do
			if entity.name == j.name then
				table.insert( global.SenpaisTrainsList, { multi = j.multy, entity = entity } )
				break
			end
		end
	end
end

function Senpais_Trains_OnRemove( event )
	local entity = event.entity
	if entity.name == "Senpais-Power-Provider" and global.SenpaisAccuList ~= nil then
		for index, l in pairs( global.SenpaisAccuList ) do
			if entity == l then
				global.SenpaisAccuList[index] = nil
				break
			end
		end
	end
	if entity.type == "locomotive" and global.SenpaisTrainsList ~= nil then
		for index, l in pairs( global.SenpaisTrainsList ) do
			if entity == l.entity then
				global.SenpaisTrainsList[index] = nil
				break
			end
		end
	end
	if entity.train and global.SenpaisTrainSchedulebyID[entity.train.id] then
		global.SenpaisTrainSchedulebyID[entity.train.id] = nil
	end
end

-- Coupling

function Senpais_Trains_GetSignal( entity, signal )
	local red = entity.get_circuit_network( defines.wire_type.red )
	local green = entity.get_circuit_network( defines.wire_type.green )
	local value = 0
	if red then
		value = red.get_signal( signal )
	end
	if green then
		value = value + green.get_signal( signal )
	end
	if value == 0 then
		return nil
	else
		return value
	end
end

function Senpais_Trains_OrientationMatch( orient1, orient2 )
	return math.abs( orient1 - orient2 ) < 0.25 or math.abs( orient1 - orient2 ) > 0.75
end

function Senpais_Trains_GetOrientation( entity, target )
	local x = target.position.x - entity.position.x
	local y = target.position.y - entity.position.y
	return ( math.atan2( y, x ) / 2 / math.pi + 0.25 ) % 1
end

function Senpais_Trains_GetTileDistance( pos_a, pos_b )
	return math.abs( pos_a.x - pos_b.x ) + math.abs( pos_a.y - pos_b.y )
end

function Senpais_Trains_SwapRailDir( raildir )
	if raildir == defines.rail_direction.front then
		return defines.rail_direction.back
	else
		return defines.rail_direction.front
	end
end

function Senpais_Trains_GetRealFront( train, station )
	if Senpais_Trains_GetTileDistance( train.front_stock.position, station.position ) < Senpais_Trains_GetTileDistance( train.back_stock.position, station.position ) then
		return train.front_stock
	else
		return train.back_stock
	end
end

function Senpais_Trains_GetRealBack( train, station )
	if Senpais_Trains_GetTileDistance( train.front_stock.position, station.position ) < Senpais_Trains_GetTileDistance( train.back_stock.position, station.position ) then
		return train.back_stock
	else
		return train.front_stock
	end
end

function Senpais_Trains_AttemptCouple( train, count, station )
	if count then
		local direction = defines.rail_direction.front
		if count < 0 then
			direction = defines.rail_direction.back
		end
		local front = Senpais_Trains_GetRealFront( train, station )
		if not Senpais_Trains_OrientationMatch( front.orientation, station.orientation ) then
			direction = Senpais_Trains_SwapRailDir( direction )
		end
		if front.connect_rolling_stock( direction ) then
			return front
		end
	end
end

function Senpais_Trains_AttemptUncouple( front, count )
	local frontCar = front.train.front_stock
	local backCar = front.train.back_stock
	if count and math.abs( count ) < #front.train.carriages then
		local direction = defines.rail_direction.front
		if front ~= front.train.front_stock then
			count = count * -1
		end
		local target = count
		if count < 0 then
			count = #front.train.carriages + count
			target = count + 1
		else
			count = count + 1
		end
		local wagon = front.train.carriages[count]
		if not Senpais_Trains_OrientationMatch( Senpais_Trains_GetOrientation( wagon, front.train.carriages[target] ), wagon.orientation ) then
			direction = Senpais_Trains_SwapRailDir( direction )
		end
		if wagon.disconnect_rolling_stock( direction ) then
			local frontLocos = 0
			local backLocos = 0
			local wagons = frontCar.train.carriages
			for _, carriage in pairs( wagons ) do
				if carriage.type == "locomotive" then
					frontLocos = frontLocos + 1
				end
			end
			local wagons = backCar.train.carriages
			for _, carriage in pairs( wagons ) do
				if carriage.type == "locomotive" then
					backLocos = backLocos + 1
				end
			end
			if frontLocos > 0 then frontCar.train.manual_mode = false end
			if backLocos > 0 then backCar.train.manual_mode = false end
			return wagon
		end
	end
end

-- SmarterTrains

function Senpais_Trains_ClearSchedule( schedule )
	local used = {}
	for i , v in pairs( schedule.records ) do
		if used[v.station] then
			schedule.records[i] = nil
		else
			used[v.station] = true
		end
	end
	return schedule
end

function Senpais_Trains_Check( signal )
	if settings.startup["Coupling"].value and signal ~= nil and ( signal.name == "signal-couple" or signal.name == "signal-decouple" ) then
		signal = nil
	end
	if signal ~= nil then
		if signal.type == "fluid" then
			if not game.fluid_prototypes[signal.name] then
				signal = nil
			end
		elseif signal.type == "item" then
			if not game.item_prototypes[signal.name] then
				signal = nil
			end
		elseif signal.type == "virtual" then
			if not game.virtual_signal_prototypes[signal.name] then
				signal = nil
			end
		end
	end
	return signal
end

-- Math

function Senpais_Trains_Round( num, decimalNumbers )
	local mult = 10^( decimalNumbers or 0 )
	return math.floor( num * mult + 0.5 ) / mult
end