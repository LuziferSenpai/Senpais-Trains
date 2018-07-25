require "config"

local found = false

Functions =
{
	Globals = function()
		global.Register =
		{
			{ name = "Senpais-Electric-Train", multy = 2 },
			{ name = "Senpais-Electric-Train-Heavy", multy = 5 },
			{ name = "Elec-Battle-Loco-1", multy = 2 },
			{ name = "Elec-Battle-Loco-2", multy = 4 },
			{ name = "Elec-Battle-Loco-3", multy = 6 }
		}
		global.TrainsList = global.TrainsList or {}
		global.AccuList = global.AccuList or {}
		global.Lines = global.Lines or {}
		global.ScheduleLines = global.ScheduleLines or {}
		global.ScheduleLinesSignals = global.ScheduleLinesSignals or {}
		global.TrainsID = global.TrainsID or {}
		global.PlayerDATA = global.PlayerDATA or {}
		global.Data = global.Data or { tc = 0, ac = 0, pn = 0, pp = 0, am = 0, pt = "W", pv = "kJ", aj = "MJ" }
	end,
	Players = function()
		for _, p in pairs( game.players ) do
			local m = mod_gui.get_button_flow( p )
			if not m.SenpaisTrainsButton then
				local b = Functions.AddSpriteButton( m, "SenpaisTrainsButton", "Senpais-S" )
				b.style.visible = true
			end
			global.PlayerDATA[p.index] = { TrainsCount = {}, WagonsCount = {}, FluidWagonsCount = {}, EntityName = "", Entity = {} }
			if p.gui.top.SenpaisSmartTrainMainButton then p.gui.top.SenpaisSmartTrainMainButton.destroy() end
			if p.gui.left.SenpaisSmartTrainMainFrame01 then p.gui.left.SenpaisSmartTrainMainFrame01.destroy() end
		end
	end,
	DestroyChildren = function( p )
		if #p > 1 then
			for i = 2, #p do
				p[i].clear()
			end
		end
	end,
	MainGui = function( p )
		local A01 = Functions.AddFrame( p, "SenpaisTrainsMainGui", "outer_frame", nil )
		local A02 = Functions.AddTable( A01, "SenpaisTrainsTable01", 4 )
		local A03 =
		{
			Functions.AddFrame( A02, "SenpaisTrainsHiddenFrame01", "outer_frame", nil ),
			Functions.AddFrame( A02, "SenpaisTrainsHiddenFrame02", "outer_frame", nil ),
			Functions.AddFrame( A02, "SenpaisTrainsHiddenFrame03", "outer_frame", nil ),
			Functions.AddFrame( A02, "SenpaisTrainsHiddenFrame04", "outer_frame", nil )
		}
		local A04 = Functions.AddFrame( A03[1], "SenpaisTrainsFrame01", nil, nil )
		local A05 =
		{
			Functions.AddSpriteButton( A04, "SenpaisTrainsSpriteButton01", "Train-Count" ),
			Functions.AddSpriteButton( A04, "SenpaisTrainsSpriteButton02", "Wagon-Count" ),
			Functions.AddSpriteButton( A04, "SenpaisTrainsSpriteButton03", "FluidWagon-Count" )
		}
		if settings.startup["Smarter-Trains"].value then
			local A06 = Functions.AddSpriteButton( A04, "SenpaisTrainsSpriteButton04", "Senpais-Smart-Stop-Icon" )
		end
		if settings.startup["Senpais-Power-Provider"].value then
			local A07 = Functions.AddSpriteButton( A04, "SenpaisTrainsSpriteButton05", "item/Senpais-Power-Provider" )
		end
	end,
	CountTrainsMain = function( p )
		local B01 = Functions.AddFrame( p, "SenpaisTrainsFrame02", nil, { "Senpais-Trains.TrainCounter" } )
		local B02 = Functions.AddScrollPane( B01, "SenpaisTrainsScrollPane01" )
		B02.style.maximal_height = 270
		local B03 = Functions.AddFrame( B02, "SenpaisTrainsFrame03", "image_frame", nil )
		B03.style.left_padding = 4
		B03.style.right_padding = 8
		B03.style.bottom_padding = 4
		B03.style.top_padding = 4
		local B04 = Functions.AddTable( B03, "SenpaisTrainsTable02", 3 )
		B04.style.column_alignments[2] = "center"
		B04.style.column_alignments[3] = "right"
		B04.style.horizontal_spacing = 16
		B04.style.vertical_spacing = 8
		B04.draw_horizontal_line_after_headers = true
		B04.draw_vertical_lines = true
		local B05 =
		{
			Functions.AddLabel( B04, "SenpaisTrainsLabel01", { "Senpais-Trains.Icon" } ),
			Functions.AddLabel( B04, "SenpaisTrainsLabel02", { "Senpais-Trains.Count" } ),
			Functions.AddLabel( B04, nil, "" )
		}
		local player = game.players[p.player_index]
		global.PlayerDATA[player.index].TrainsCount = {}
		for _, e in pairs( player.surface.find_entities_filtered{ type = "locomotive" } ) do
			found = false
			for _, t in pairs( global.PlayerDATA[player.index].TrainsCount ) do
				if t.name == e.name then
					table.insert( t.entities, e )
					found = true
					break
				end
			end
			if not found then
				table.insert( global.PlayerDATA[player.index].TrainsCount, { name = e.name, entities = { e } } )
			end
		end
		for _, t in pairs( global.PlayerDATA[player.index].TrainsCount ) do
			local n = t.name
			local B06 =
			{
				Functions.AddSprite( B04, "SenpaisTrainsSprite01_" .. n, "item/" .. n ),
				Functions.AddLabel( B04, "SenpaisTrainsLabel03_" .. n, #t.entities ),
				Functions.AddButton( B04, "SenpaisTrainsButton01_" .. n, { "Senpais-Trains.ListAll" } )
			}
			local z = game.entity_prototypes[n] or game.tile_prototypes[n] or game.equipment_prototypes[n] or game.item_prototypes[n]
			B06[1].tooltip = z.localised_name
		end
	end,
	CountTrainsList = function( p, t )
		global.PlayerDATA[game.players[p.player_index].index].EntityName = t.name
		local C01 = Functions.AddFrame( p, "SenpaisTrainsFrame04", nil, { "Senpais-Trains.PlacedEntities" } )
		local C02 = Functions.AddScrollPane( C01, "SenpaisTrainsScrollPane02" )
		C02.style.maximal_height = 270
		local C03 = Functions.AddFrame( C02, "SenpaisTrainsFrame05", "image_frame", nil )
		C03.style.left_padding = 4
		C03.style.right_padding = 8
		C03.style.bottom_padding = 4
		C03.style.top_padding = 4
		local C04 = Functions.AddTable( C03, "SenpaisTrainsTable03", 5 )
		C04.style.column_alignments[2] = "center"
		C04.style.column_alignments[3] = "center"
		C04.style.column_alignments[4] = "right"
		C04.style.horizontal_spacing = 16
		C04.style.vertical_spacing = 8
		C04.draw_horizontal_line_after_headers = true
		C04.draw_vertical_lines = true
		local C05 =
		{
			Functions.AddLabel( C04, "SenpaisTrainsLabel04", { "Senpais-Trains.BackerName" } ),
			Functions.AddLabel( C04, "SenpaisTrainsLabel05", { "Senpais-Trains.PlayerKills" } ),
			Functions.AddLabel( C04, "SenpaisTrainsLabel06", { "Senpais-Trains.ID" } ),
			Functions.AddLabel( C04, "SenpaisTrainsLabel07", { "Senpais-Trains.Health" } ),
			Functions.AddLabel( C04, nil, "" )
		}
		for u = 1, #t.entities do
			local e = t.entities[u]
			local C06 =
			{
				Functions.AddFrame( C04, "SenpaisTrainsFrame06_" .. u, "outer_frame", nil ),
				Functions.AddFrame( C04, "SenpaisTrainsFrame07_" .. u, "outer_frame", nil ),
				Functions.AddFrame( C04, "SenpaisTrainsFrame08_" .. u, "outer_frame", nil ),
				Functions.AddFrame( C04, "SenpaisTrainsFrame09_" .. u, "outer_frame", nil ),
				Functions.AddFrame( C04, "SenpaisTrainsFrame10_" .. u, "outer_frame", nil )
			}
			local C07 = Functions.AddLabel( C06[1], "SenpaisTrainsLabel08_" .. u, e.backer_name )
			if #e.train.killed_players > 0 then
				for i, c in pairs( e.train.killed_players ) do
					local C08 = Functions.AddLabel( C06[2], "SenpaisTrainsLabel09_" .. u .. "_" .. i, "- " .. game.players[i].name .. ": " .. c )
				end
			end
			local C09 =
			{
				Functions.AddLabel( C06[3], "SenpaisTrainsLabel10_" .. u, e.train.id ),
				Functions.AddLabel( C06[4], "SenpaisTrainsLabel11_" .. u, e.health .. "/" .. e.prototype.max_health ),
				Functions.AddButton( C06[5], "SenpaisTrainsButton02_" .. u, { "Senpais-Trains.EditTrain" } )
			}
		end
	end,
	CountTrainsEntityEdit = function( p, b )
		local D01 = Functions.AddFrame( p, "SenpaisTrainsFrame11", nil, nil )
		local D02 = Functions.AddTexfield( D01, "SenpaisTrainsTextfield01", b )
		if settings.startup["Smarter-Trains"].value then
			local D03 =
			{
				Functions.AddDropDown( D01, "SenpaisTrainsDropDown01", global.SenpaisLines ),
				Functions.AddScrollPane( D01, "SenpaisTrainsScrollPane03" )
			}
			D03[2].style.maximal_height = 300
		end
		local D04 = Functions.AddButton( D01, "SenpaisTrainsButton03", { "Senpais-Trains.Changes" } )
	end,
	CountTrainsEntityEditList = function( p, i )
		local E01 = Functions.AddFrame( p, "SenpaisTrainsFrame12", "image_frame", nil )
		E01.style.left_padding = 4
		E01.style.right_padding = 8
		E01.style.bottom_padding = 4
		E01.style.top_padding = 4
		local E02 = Functions.AddTable( E01, "SenpaisTrainsTable04", 2 )
		E02.style.horizontal_spacing = 16
		E02.style.vertical_spacing = 8
		E02.style.column_alignments[2] = "right"
		E02.draw_horizontal_line_after_headers = true
		E02.draw_vertical_lines = true
		local E03 =
		{
			Functions.AddLabel( E02, nil, "" ),
			Functions.AddLabel( E02, "SenpaisTrainsLabel12", { "Senpais-Trains.Stations" } )
		}
		for _, s in pairs( global.ScheduleLinesSignals[global.Lines[i]] ) do
			local y = s.station
			local E04 =
			{
				Functions.AddRadioButton( E02, "SenpaisTrainsRadioButton01_" .. y ),
				Functions.AddLabel( E02, "SenpaisTrainsLabel13_" .. y, y )
			}
		end
	end,
	CountWagonsMain = function( p )
		local F01 = Functions.AddFrame( p, "SenpaisTrainsFrame13", nil, { "Senpais-Trains.WagonCounter" } )
		local F02 = Functions.AddScrollPane( F01, "SenpaisTrainsScrollPane04" )
		F02.style.maximal_height = 270
		local F03 = Functions.AddFrame( F02, "SenpaisTrainsFrame14", "image_frame", nil )
		F03.style.left_padding = 4
		F03.style.right_padding = 8
		F03.style.bottom_padding = 4
		F03.style.top_padding = 4
		local F04 = Functions.AddTable( F03, "SenpaisTrainsTable05", 3 )
		F04.style.column_alignments[2] = "center"
		F04.style.column_alignments[3] = "right"
		F04.style.horizontal_spacing = 16
		F04.style.vertical_spacing = 8
		F04.draw_horizontal_line_after_headers = true
		F04.draw_vertical_lines = true
		local F05 =
		{
			Functions.AddLabel( F04, "SenpaisTrainsLabel14", { "Senpais-Trains.Icon" } ),
			Functions.AddLabel( F04, "SenpaisTrainsLabel15", { "Senpais-Trains.Count" } ),
			Functions.AddLabel( F04, nil, "" )
		}
		local player = game.players[p.player_index]
		global.PlayerDATA[player.index].WagonsCount = {}
		for _, e in pairs( player.surface.find_entities_filtered{ type = "cargo-wagon" } ) do
			found = false
			for _, w in pairs( global.PlayerDATA[player.index].WagonsCount ) do
				if w.name == e.name then
					table.insert( w.entities, e )
					found = true
					break
				end
			end
			if not found then
				table.insert( global.PlayerDATA[player.index].WagonsCount, { name = e.name, entities = { e } } )
			end
		end
		for _, w in pairs( global.PlayerDATA[player.index].WagonsCount ) do
			local n = w.name
			local F06 =
			{
				Functions.AddSprite( F04, "SenpaisTrainsSprite02_" .. n, "item/" .. n ),
				Functions.AddLabel( F04, "SenpaisTrainsLabel16_" .. n, #w.entities ),
				Functions.AddButton( F04, "SenpaisTrainsButton04_" .. n, { "Senpais-Trains.ListAll" } )
			}
			local z = game.entity_prototypes[n] or game.tile_prototypes[n] or game.equipment_prototypes[n] or game.item_prototypes[n]
			F06[1].tooltip = z.localised_name
		end
	end,
	CountWagonsList = function( p, t )
		local G01 = Functions.AddFrame( p, "SenpaisTrainsFrame15", nil, { "Senpais-Trains.PlacedEntities" } )
		local G02 = Functions.AddScrollPane( G01, "SenpaisTrainsScrollPane05" )
		G02.style.maximal_height = 270
		local G03 = Functions.AddFrame( G02, "SenpaisTrainsFrame16", "image_frame", nil )
		G03.style.left_padding = 4
		G03.style.right_padding = 8
		G03.style.bottom_padding = 4
		G03.style.top_padding = 4
		local G04 = Functions.AddTable( G03, "SenpaisTrainsTable06", 4 )
		G04.style.column_alignments[2] = "center"
		G04.style.column_alignments[4] = "center"
		G04.style.horizontal_spacing = 16
		G04.style.vertical_spacing = 8
		G04.draw_horizontal_line_after_headers = true
		G04.draw_vertical_lines = true
		G04.draw_horizontal_lines = true
		local G05 =
		{
			Functions.AddFrame( G04, "SenpaisTrainsFrame17", "outer_frame", nil ),
			Functions.AddFrame( G04, "SenpaisTrainsFrame18", "outer_frame", nil ),
			Functions.AddFrame( G04, "SenpaisTrainsFrame19", "outer_frame", nil ),
			Functions.AddFrame( G04, "SenpaisTrainsFrame20", "outer_frame", nil )
		}
		local G06 =
		{
			Functions.AddLabel( G05[1], "SenpaisTrainsLabel17", { "Senpais-Trains.Health" } ),
			Functions.AddTable( G05[2], "SenpaisTrainsTable07", 2 ),
			Functions.AddLabel( G05[3], "SenpaisTrainsLabel18", { "Senpais-Trains.Health" } ),
			Functions.AddTable( G05[4], "SenpaisTrainsTable08", 2 ),
		}
		G06[2].style.column_alignments[2] = "right"
		G06[2].style.horizontal_spacing = 16
		G06[2].style.vertical_spacing = 8
		G06[4].style.column_alignments[2] = "right"
		G06[4].style.horizontal_spacing = 16
		G06[4].style.vertical_spacing = 8
		local G07 =
		{
			Functions.AddLabel( G06[2], "SenpaisTrainsLabel19", { "Senpais-Trains.Icon" } ),
			Functions.AddLabel( G06[2], "SenpaisTrainsLabel20", { "Senpais-Trains.Load" } ),
			Functions.AddLabel( G06[4], "SenpaisTrainsLabel21", { "Senpais-Trains.Icon" } ),
			Functions.AddLabel( G06[4], "SenpaisTrainsLabel22", { "Senpais-Trains.Load" } )
		}
		for u = 1, #t.entities do
			local e = t.entities[u]
			local G08 =
			{
				Functions.AddFrame( G04, "SenpaisTrainsFrame21_" .. u, "outer_frame", nil ),
				Functions.AddFrame( G04, "SenpaisTrainsFrame22_" .. u, "outer_frame", nil )
			}
			local G09 =
			{
				Functions.AddLabel( G08[1], "SenpaisTrainsLabel23_" .. u, e.health .. "/" .. e.prototype.max_health ),
				Functions.AddTable( G08[2], "SenpaisTrainsTable09_" .. u, 2 )
			}
			G09[2].style.column_alignments[2] = "right"
			G09[2].style.horizontal_spacing = 16
			G09[2].style.vertical_spacing = 8
			for n, c in pairs( e.get_inventory( defines.inventory.cargo_wagon ).get_contents() ) do
				local G10 =
				{
					Functions.AddSprite( G09[2], "SenpaisTrainsSprite03_" .. u .. "_" .. n, "item/" .. n ),
					Functions.AddLabel( G09[2], "SenpaisTrainsLabel24_" .. u .. "_" .. n, c )
				}
				local z = game.entity_prototypes[n] or game.tile_prototypes[n] or game.equipment_prototypes[n] or game.item_prototypes[n]
				G09[1].tooltip = z.localised_name
			end
		end
	end,
	CountFluidWagonsMain = function( p )
		local H01 = Functions.AddFrame( p, "SenpaisTrainsFrame23", nil, { "Senpais-Trains.FluidWagonCounter" } )
		local H02 = Functions.AddScrollPane( H01, "SenpaisTrainsScrollPane06" )
		H02.style.maximal_height = 270
		local H03 = Functions.AddFrame( H02, "SenpaisTrainsFrame24", "image_frame", nil )
		H03.style.left_padding = 4
		H03.style.right_padding = 8
		H03.style.bottom_padding = 4
		H03.style.top_padding = 4
		local H04 = Functions.AddTable( H03, "SenpaisTrainsTable10", 3 )
		H04.style.column_alignments[2] = "center"
		H04.style.column_alignments[3] = "right"
		H04.style.horizontal_spacing = 16
		H04.style.vertical_spacing = 8
		H04.draw_horizontal_line_after_headers = true
		H04.draw_vertical_lines = true
		local H05 =
		{
			Functions.AddLabel(  H04, "SenpaisTrainsLabel25", { "Senpais-Trains.Icon" } ),
			Functions.AddLabel(  H04, "SenpaisTrainsLabel26", { "Senpais-Trains.Count" } ),
			Functions.AddLabel(  H04, nil, "" ),
		}
		local player = game.players[p.player_index]
		global.PlayerDATA[player.index].FluidWagonsCount = {}
		for _, e in pairs( player.surface.find_entities_filtered{ type = "fluid-wagon" } ) do
			found = false
			for _, f in pairs( global.PlayerDATA[player.index].FluidWagonsCount ) do
				if f.name == e.name then
					table.insert( f.entities, e )
					found = true
					break
				end
			end
			if not found then
				table.insert( global.PlayerDATA[player.index].FluidWagonsCount, { name = e.name, entities = { e } } )
			end
		end
		for _, f in pairs( global.PlayerDATA[player.index].FluidWagonsCount ) do
			local n = f.name
			local H06 =
			{
				Functions.AddSprite( H04, "SenpaisTrainsSprite04_" .. n, "item/" .. n ),
				Functions.AddLabel( H04, "SenpaisTrainsLabel27_" .. n, #f.entities ),
				Functions.AddButton( H04, "SenpaisTrainsButton05_" .. n, { "Senpais-Trains.ListAll" } )
			}
			local z = game.entity_prototypes[n] or game.tile_prototypes[n] or game.equipment_prototypes[n] or game.item_prototypes[n]
			H06[1].tooltip = z.localised_name
		end
	end,
	CountFluidWagonsList = function( p, t )
		local I01 = Functions.AddFrame( p, "SenpaisTrainsFrame25", nil, { "Senpais-Trains.PlacedEntities" } )
		local I02 = Functions.AddScrollPane( I01, "SenpaisTrainsScrollPane07" )
		I02.style.maximal_height = 270
		local I03 = Functions.AddFrame( I02, "SenpaisTrainsFrame26", "image_frame", nil )
		I03.style.left_padding = 4
		I03.style.right_padding = 8
		I03.style.bottom_padding = 4
		I03.style.top_padding = 4
		local I04 = Functions.AddTable( I03, "SenpaisTrainsTable11", 2 )
		I04.style.horizontal_spacing = 16
		I04.style.vertical_spacing = 8
		I04.draw_horizontal_line_after_headers = true
		I04.draw_vertical_lines = true
		I04.draw_horizontal_lines = true
		local I05 =
		{
			Functions.AddLabel( I04, "SenpaisTrainsLabel28", { "Senpais-Trains.Health" } ),
			Functions.AddLabel( I04, "SenpaisTrainsLabel29", { "Senpais-Trains.Fluid" } ),
		}
		for u = 1, #t.entities do
			local e = t.entities[u]
			local I06 =
			{
				Functions.AddLabel( I04, "SenpaisTrainsLabel30_" .. u, e.health .. "/" .. e.prototype.max_health ),
				Functions.AddFlow( I04, "SenpaisTrainsFlow01_" .. u, "description_vertical_flow" )
			}
			local I07 = Functions.AddTable( I06[2], "SenpaisTrainsTable12_" .. u, 2 )
			local fluid = e.fluidbox[1]
			local c = e.prototype.fluid_capacity
			if fluid ~= nil then
				local fp = game.fluid_prototypes[fluid.name]
				local I08 =
				{
					Functions.AddSprite( I07, "SenpaisTrainsSprite05_" .. u, "fluid/" .. fluid.name ),
					Functions.AddProgressbar( I07, "SenpaisTrainsProgressbar01_" .. u, c, fluid.amount / c )
				}
				I08[1].tooltip = fp.localised_name
				I08[2].style.color = fp.base_color
			else
				local I08 = Functions.AddLabel( I07, "SenpaisTrainsLabel31_" .. u, {"Senpais-Trains.NoFluid"} )
			end
		end
	end,
	SmarterTrainsMain = function( p )
		local J01 = Functions.AddFrame( p, "SenpaisTrainsFrame27", nil, { "Senpais-Trains.Line" } )
		local J02 = Functions.AddTable( J01, "SenpaisTrainsTable13", 4 )
		local J03 =
		{
			Functions.AddDropDown( J02, "SenpaisTrainsDropDown02", global.Lines ),
			Functions.AddChooseElemButtonSignal( J02, "SenpaisTrainsChooseElemButton01", nil ),
			Functions.AddSpriteButton( J02, "SenpaisTrainsSpriteButton06", "Senpais-plus" ),
			Functions.AddSpriteButton( J02, "SenpaisTrainsSpriteButton07", "utility/trash_bin" )
		}
	end,
	SmarterTrainsList = function( p )
		local K01 = Functions.AddScrollPane( p, "SenpaisTrainsScrollPane08", nil, nil )
		K01.style.maximal_height = 300
		local K02 = Functions.AddFrame( K01, "SenpaisTrainsFrame28", "image_frame", nil )
		K02.style.left_padding = 4
		K02.style.right_padding = 8
		K02.style.bottom_padding = 4
		K02.style.top_padding = 4
		local K03 = Functions.AddTable( K02, "SenpaisTrainsTable14", 2 )
		K03.style.horizontal_spacing = 16
		K03.style.vertical_spacing = 8
		K03.style.column_alignments[2] = "right"
		K03.draw_horizontal_line_after_headers = true
		K03.draw_vertical_lines = true
		local K04 =
		{
			Functions.AddLabel( K03, "SenpaisTrainsLabel31", { "Senpais-Trains.Stations" } ),
			Functions.AddLabel( K03, "SenpaisTrainsLabel32", { "Senpais-Trains.Signals" } ),
		}
		for _, s in pairs( global.ScheduleLinesSignals[global.Lines[p.children[1].children[1].selected_index]] ) do
			local y = s.station
			local K05 =
			{
				Functions.AddLabel( K03, "SenpaisTrainsLabel33_" .. y, y ),
				Functions.AddChooseElemButtonSignal( K03, "SenpaisTrainsChooseElemButton02_" .. y, Functions.CheckSignal( s.signal ) )
			}
		end
	end,
	SmarterTrainsAdd = function( p )
		local L01 = Functions.AddFrame( p, "SenpaisTrainsFrame29", nil, { "Senpais-Trains.NewLine" } )
		local L02 = Functions.AddTable( L01, "SenpaisTrainsTable15", 2 )
		local L03 =
		{
			Functions.AddTexfield( L02, "SenpaisTrainsTextfield02", nil ),
			Functions.AddChooseElemButtonSignal( L02, "SenpaisTrainsChooseElemButton03", nil ),
			Functions.AddButton( L01, "SenpaisTrainsButton06", { "Senpais-Trains.AddLine" } )
		}
	end,
	ElectricTrainsMain = function( p )
		local pn = 0
		local pp = 0
		local am = 0
		local pt =  "W"
		local pv =  "kJ"
		local aj =  "MJ"
		local d = global.Data
		local tl = global.TrainsList
		local al = global.AccuList
		if #tl ~= d.tc then
			for i, t in pairs( tl ) do
				if t.entity.valid then
					pn = pn + ( t.multi * 600 )
				else
					table.remove( global.TrainsList, i )
					tl = global.TrainsList
				end
			end
			if pn > 1000 then
				pn = pn / 1000
				pt =  "MW"
				if pn > 1000 then
					pn = pn / 1000
					pt =  "GW"
				end
			end
			global.Data.tc = #tl
			global.Data.pn = pn
			global.Data.pt = pt
		else
			pn = d.pn
			pt = d.pt
		end
		for i, a in pairs( al ) do
			if a.valid then
				pp = pp + a.energy
			else
				table.remove( global.AccuList, i )
				al = global.AccuList
			end
		end
		if pp > 1000 then
			pp = Functions.Round( pp / 1000, 2 )
			pv = "kJ"
			if pp > 1000 then
				pp = Functions.Round( pp / 1000, 2 )
				pv =  "MJ"
				if pp > 1000 then
					pp = Functions.Round( pp / 1000, 2 )
					pv =  "GJ"
					if pp > 1000 then
						pp = Functions.Round( pp / 1000, 2 )
						pv = "TJ"
					end
				end
			end
		end
		if #al ~= d.ac then
			am = 25 * #al
			if am > 1000 then
				am = am / 1000
				aj =  "GJ"
				if am > 1000 then
					am = am / 1000
					aj =  "TJ"
				end
			end
			global.Data.ac = #al
			global.Data.am = am
			global.Data.aj = aj
		else
			am = d.am
			aj = d.aj
		end
		local M01 = Functions.AddFrame( p, "SenpaisTrainsFrame30", "frame_in_right_container", { "Senpais-Trains.ElectricStates" } )
		local M02 =
		{
			Functions.AddFlow( M01, "SenpaisTrainsFlow02", "description_vertical_flow" ),
			Functions.AddFlow( M01, "SenpaisTrainsFlow03", "description_vertical_flow" ),
			Functions.AddFlow( M01, "SenpaisTrainsFlow04", "description_vertical_flow" ),
			Functions.AddFlow( M01, "SenpaisTrainsFlow05", "description_vertical_flow" ),
			Functions.AddFlow( M01, "SenpaisTrainsFlow06", "description_vertical_flow" ),
			Functions.AddProgressbar( M01, "SenpaisTrainsProgressbar02", am, pp / am )
		}
		local M03 =
		{
			Functions.AddTable( M02[1], "SenpaisTrainsTable16", 2 ),
			Functions.AddTable( M02[2], "SenpaisTrainsTable17", 2 ),
			Functions.AddTable( M02[3], "SenpaisTrainsTable18", 2 ),
			Functions.AddTable( M02[4], "SenpaisTrainsTable19", 2 ),
			Functions.AddTable( M02[5], "SenpaisTrainsTable20", 2 )
		}
		local M04 =
		{
			Functions.AddLabel( M03[1], "SenpaisTrainsLabel34", { "Senpais-Trains.TP" } ),
			Functions.AddLabel( M03[1], "SenpaisTrainsLabel35", #al ),
			Functions.AddLabel( M03[2], "SenpaisTrainsLabel36", { "Senpais-Trains.TET" } ),
			Functions.AddLabel( M03[2], "SenpaisTrainsLabel37", #tl ),
			Functions.AddLabel( M03[3], "SenpaisTrainsLabel38", { "Senpais-Trains.TPNFT" } ),
			Functions.AddLabel( M03[3], "SenpaisTrainsLabel39", { "Senpais-Trains." .. pt, pn } ),
			Functions.AddLabel( M03[4], "SenpaisTrainsLabel40", { "Senpais-Trains.TPIP" } ),
			Functions.AddLabel( M03[4], "SenpaisTrainsLabel41", { "Senpais-Trains." .. pv, pp } ),
			Functions.AddLabel( M03[5], "SenpaisTrainsLabel42", { "Senpais-Trains.TPPCS" } ),
			Functions.AddLabel( M03[5], "SenpaisTrainsLabel43", { "Senpais-Trains." .. aj, am } )
		}
		M02[6].style = "electric_satisfaction_progressbar"
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
	end,
	OnBuild = function( ee )
		local e = ee.created_entity
		if e.name == "Senpais-Power-Provider" then
			table.insert( global.AccuList, e )
		elseif e.type == "locomotive" then
			for _, r in pairs( global.Register ) do
				if e.name == r.name then
					table.insert( global.TrainsList, { multi = r.multy, entity = e } )
					break
				end
			end
		end
	end,
	AttemptCouple = function( t, c, s )
		if c then
			local d = defines.rail_direction.front
			if count < 0 then
				d = defines.rail_direction.back
			end
			local f = Functions.GetRealFront
			if not Functions.OrientationMatch( f.orientation, s.orientation ) then
				d = Functions.SwapRailDir( d )
			end
			if f.connect_rolling_stock( d ) then
				return f
			end
		end
	end,
	AttemptUncouple = function( f, c )
		local t = f.train
		local cr = t.carriages
		local fr = t.front_stock
		local br = t.back_stock
		if c and math.abs( c ) < #cr then
			local d = defines.rail_direction.front
			if f ~= fr then
				c = c * -1
			end
			local ta = c
			if c < 0 then
				c = #cr + c
				ta = c + 1
			else
				c = c + 1
			end
			local w = t.cr[c]
			if not Functions.OrientationMatch( Functions.GetOrientation( w, cr[ta] ), w.orientation ) then
				d = Functions.SwapRailDir( d )
			end
			if w.disconnect_rolling_stock( d ) then
				local fl = 0
				local bl = 0
				fr = fr.train
				br = br.train
				local ws = fr.carriages
				for _, ce in pairs( ws ) do
					if ce.type == "locomotive" then
						fl = fl + 1
					end
				end
				es = br.carriages
				for _, ce in pairs( ws ) do
					if ce.type == "locomotive" then
						bl = bl + 1
					end
				end
				if fl > 0 then fr.manual_mode = false end
				if bl > 0 then br.manual_mode = false end
				return w
			end
		end
	end,
	AddButton = function( f, n, c )
		return f.add{ type = "button", name = n, caption = c }
	end,
	AddChooseElemButtonSignal = function( f, n, s )
		return f.add{ type = "choose-elem-button", name = n, elem_type = "signal", signal = s }
	end,
	AddDropDown = function( f, n, i )
		return f.add{ type = "drop-down", name = n, items = i }
	end,
	AddFlow = function( f, n, s )
		return f.add{ type = "flow", name = n, direction = "vertical", style = s }
	end,
	AddFrame = function( f, n, s, c )
		return f.add{ type = "frame", name = n, direction = "vertical", style = s, caption = c }
	end,
	AddLabel = function( f, n, c )
		return f.add{ type = "label", name = n, caption = c }
	end,
	AddRadioButton = function( f, n, s )
		return f.add{ type = "radiobutton", name = n, state = s }
	end,
	AddProgressbar = function( f, n, s, v )
		return f.add{ type = "progressbar", name = n, size = s, value = v }
	end,
	AddScrollPane = function( f, n )
		return f.add{ type = "scroll-pane", name = n }
	end,
	AddSprite = function( f, n, s )
		return f.add{ type = "sprite", name = n, sprite = s }
	end,
	AddSpriteButton = function( f, n, s )
		return f.add{ type = "sprite-button", name = n, sprite = s }
	end,
	AddTable = function( f, n, c )
		return f.add{ type = "table", name = n, column_count = c }
	end,
	AddTexfield = function( f, n, t )
		return f.add{ type = "textfield", name = n, text = t }
	end,
	CheckSignal = function( s )
		if s ~= nil then
			local n = s.name
			local t = s.type
			if settings.startup["Coupling"].value and ( n == "signal-couple" or n == "signal-decouple" ) then
				return nil
			elseif t == "fluid" then
				if not game.fluid_prototypes[n] then
					return nil
				end
			elseif t == "item" then
				if not game.item_prototypes[n] then
					return nil
				end
			elseif t == "virtual" then
				if not game.virtual_signal_prototypes[n] then
					return nil
				end
			end
			return s
		else
			return nil
		end
	end,
	ClearSchedule = function( s )
		local u = {}
		for i, r in pairs( s.records ) do
			if u[r.station] then
				s.records[i] = nil
			else
				u[r.station] = true
			end
		end
		return s
	end,
	GetDistance = function( pa, pb )
		return math.abs( pa.x - pb.x ) + math.abs( pa.y - pb.y )
	end,
	GetOrientation = function( e, t )
		local x = t.position.x - e.position.x
		local y = t.position.y - e.position.y
		return ( math.atan2( y, x ) / 2 / math.pi + 0.25 ) % 1
	end,
	GetRealFront = function( t, s )
		if Functions.GetDistance( t.front_stock.position, s.position ) < Functions.GetDistance( t.back_stock.position, s.position ) then
			return t.front_stock
		else
			return t.back_stock
		end
	end,
	GetRealBack = function( t, s )
		if Functions.GetDistance( t.front_stock.position, s.position ) < Functions.GetDistance( t.back_stock.position, s.position ) then
			return t.back_stock
		else
			return t.front_stock
		end
	end,
	GetSignal = function( e, s )
		local r = e.get_circuit_network( defines.wire_type.red )
		local g = e.get_circuit_network( defines.wire_type.green )
		local v = 0
		if r then
			v = r.get_signal( s )
		end
		if g then
			v = v + g.get_signal( s )
		end
		if value == 0 then
			return nil
		else
			return value
		end
	end,
	OrientationMatch = function( o1, o2 )
		return math.abs( o1, o2 ) < 0.25 or math.abs( o1, o2 ) > 0.75
	end,
	Round = function( n, d )
		local m = 10 ^ d
		return math.floor( n * m + 0.5 ) / m
	end,
	SwapRailDir = function( r )
		if r == defines.rail_direction.front then
			return defines.rail_direction.back
		else
			return defines.rail_direction.front
		end
	end,
}

return Functions