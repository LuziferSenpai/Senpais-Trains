require "mod-gui"
require "functions"
require "config"

script.on_init( function()
	Senpais_Trains_globals()
	Senpais_Trains_Players()
end )

script.on_configuration_changed( function()
	Senpais_Trains_globals()
	Senpais_Trains_Players()
	if global.SenpaisTrainsList ~= nil then
		for _, f in pairs( global.SenpaisTrainsList ) do
			for _, r in pairs( global.Register ) do
				if f.entity.name == r.name and f.multi ~= r.multy then
					f.multi = r.multy
					break
				end
			end
		end
	end
end )

script.on_event( defines.events.on_gui_click, function( event )
	local element = event.element
	local name = element.name
	local player = game.players[event.player_index]
	local parent = element.parent or nil

	if not name then return end
	if name == "SenpaisGUIButton" then
		if mod_gui.get_frame_flow( player ).SenpaisGUI then
			mod_gui.get_frame_flow( player ).SenpaisGUI.destroy()
		else
			Senpais_Trains_MainGUI( player )
		end
		return
	end
	if parent and parent.name == "SenpaisGUIFrame01" then
		if Senpais.GUIButtons[name] then
			Senpais_Trains_DestroyChildren( parent.parent.parent.children, 2 )
		end
		if name == "SenpaisSmarterTrainsGUIMainButton" and settings.startup["Smarter-Trains"].value then
			Senpais_Trains_SmarterTrainsGUIMain( parent.parent.parent.children[2] )
		end
		if name == "SenpaisCountTrainsButton" then
			Senpais_Trains_CountTrainsGUIMain( parent.parent.parent.children[2] )
		end
		if name == "SenpaisCountWagonsButton" then
			Senpais_Trains_CountWagonsGUIMain( parent.parent.parent.children[2] )
		end
		if name == "SenpaisCountFluidWagonsButton" then
			Senpais_Trains_CountFluidWagonsGUIMain( parent.parent.parent.children[2] )
		end
		if name == "SenpaisElectricTrainsStatesButton" then
			Senpais_Trains_ElectricTrainsStatesGUIMain( parent.parent.parent.children[2] )
		end
		return
	end
	if name == "SenpaisSmarterTrainsGUISpriteButton01" and player.opened and player.opened.train then
		if parent.parent.parent.parent.children[3].children[1] then
			parent.parent.parent.parent.children[3].clear()
		else
			Senpais_Trains_SmarterTrainsGUIAdd( parent.parent.parent.parent.children[3] )
		end
		return
	elseif name == "SenpaisSmarterTrainsGUISpriteButton01" and parent.parent.parent.parent.children[3].children then
		parent.parent.parent.parent.children[3].clear()
		return
	end
	if name == "SenpaisSmarterTrainsGUISpriteButton02" and parent.children[1].selected_index > 0 then
		global.SenpaisScheduleLinesSignals[global.SenpaisLines[parent.children[1].selected_index]] = nil
		global.SenpaisScheduleLines[global.SenpaisLines[parent.children[1].selected_index]] = nil
		table.remove( global.SenpaisLines, parent.children[1].selected_index )
		if parent.parent.parent.parent.children[3].children then parent.parent.parent.parent.children[3].clear() end
		local parent2 = parent.parent.parent.parent.children[2]
		parent2.clear()
		Senpais_Trains_SmarterTrainsGUIMain( parent2 )
		return
	end
	if name == "SenpaisSmarterTrainsGUIButton" then
		if player.opened and player.opened.train and parent.children[1].children[1].text ~= nil and not global.SenpaisScheduleLines[parent.children[1].children[1].text] then
			table.insert( global.SenpaisLines, parent.children[1].children[1].text )
			local clear_schedule = CLEARSCHEDULE( player.opened.train.schedule )
			global.SenpaisScheduleLines[parent.children[1].children[1].text] = { signal = Senpais_Trains_Check( parent.children[1].children[2].elem_value ), schedule = clear_schedule }
			global.SenpaisScheduleLinesSignals[parent.children[1].children[1].text] = {}
			for _, s in pairs( clear_schedule.records ) do
					table.insert( global.SenpaisScheduleLinesSignals[parent.children[1].children[1].text], { signal = nil, station = s.station } )
			end
			local parent2 = parent.parent.parent
			parent2.children[3].clear()
			parent2.children[2].clear()
			Senpais_Trains_SmarterTrainsGUIMain( parent2.children[2] )
		else
			parent.parent.parent.children[3].clear()
		end
		return
	end
	if parent and parent.name == "SenpaisCountTrainsTable01" then
		parent.parent.parent.parent.parent.parent.children[3].clear()
		for _, z in pairs( global.PlayerDATA[player.index].TrainsCount ) do
			if element.name == "SenpaisCountTrainsButton01_" .. z.name then
				Senpais_Trains_CountTrainsGUIList( parent.parent.parent.parent.parent.parent.children[3], z )
				break
			end
		end
		return
	end
	if parent and parent.parent and parent.parent.name == "SenpaisCountTrainsTable02" then
		for _, s in pairs( global.PlayerDATA[player.index].TrainsCount ) do
			if s.name == global.PlayerDATA[player.index].EntityName then
				for v = 1, #s.entities do
					if element.name == "SenpaisCountTrainsButton02_" .. s.name .. "_" .. v then
						global.PlayerDATA[player.index].EntityCount = v
						Senpais_Trains_CountTrainsGUIEntityEdit( parent.parent.parent.parent.parent.parent.children[4], s.entities[v] )
						break
					end
				end
				break
			end
		end
		return
	end
	if name == "SenpaisCountTrainsButton03" then
		for _, r in pairs( global.PlayerDATA[player.index].TrainsCount ) do
			if r.name == global.PlayerDATA[player.index].EntityName then
				local entity = r.entities[global.PlayerDATA[player.index].EntityCount]
				entity.backer_name = parent.children[1].text or entity.backer_name
				if settings.startup["Smarter-Trains"].value and parent.children[2].selected_index > 0 then
					for _, p in pairs( parent.children[3].children[1].children[1].children ) do
						if p.type == "radiobutton" and p.state == true then
							local station_name = p.name:match( "^%a%_(.*)" )
							local records = global.SenpaisScheduleLines[global.SenpaisLines[parent.children[2].selected_index]].schedule.records
							for w = 1, #records do
								if records[w].station == station_name then
									entity.train.manual_mode = true
									entity.train.schedule = { current = w, records = records }
									entity.train.manual_mode = false
									break
								end
							end
						break
						end
					end
				end
				local parent2 = parent.parent.parent.children
				Senpais_Trains_DestroyChildren( parent2, 2 )
				Senpais_Trains_CountTrainsGUIMain( parent2[2] )
				break
			end
		end
		return
	end
	if parent and parent.name == "SenpaisCountWagonsTable01" then
		parent.parent.parent.parent.parent.parent.children[3].clear()
		for _, j in pairs( global.PlayerDATA[player.index].WagonsCount ) do
			if element.name == "SenpaisCountWagonsButton_" .. j.name then
				Senpais_Trains_CountWagonsGUIList( parent.parent.parent.parent.parent.parent.children[3], j )
				break
			end
		end
		return
	end
	if parent and parent.name == "SenpaisCountFluidWagonsTable01" then
		parent.parent.parent.parent.parent.parent.children[3].clear()
		for _, y in pairs( global.PlayerDATA[player.index].FluidWagonsCount ) do
			if element.name == "SenpaisCountFluidWagonsButton_" .. y.name then
				Senpais_Trains_CountFluidWagonsGUIList( parent.parent.parent.parent.parent.parent.children[3], y )
			end
		end
		return
	end
end )

script.on_event( defines.events.on_gui_selection_state_changed, function( event )
	local element = event.element
	local parent = element.parent or nil
	if element.name == "SenpaisSmarterTrainsGUIDropDown" then
		parent.children[2].elem_value = Senpais_Trains_Check( global.SenpaisScheduleLines[global.SenpaisLines[element.selected_index]].signal )
		Senpais_Trains_SmarterTrainsGUIMainList( parent.parent )
		return
	end
	if element.name == "SenpaisCountTrainsDropDown" and settings.startup["Smarter-Trains"].value then
		Senpais_Trains_CountTrainsGUIEntityEditList( parent.children[3], element.selected_index )
	end
end )

script.on_event( defines.events.on_gui_checked_state_changed, function( event )
	local element = event.element
	local parent = element.parent or nil
	if parent.name == "SenpaisCountTrainsTable03" then
		for n = 1, #parent.children do
			if parent.children[n].type == "radiobutton" then
				parent.children[n].state = false
			end
		end
		element.state = true
	end
end )

script.on_event( defines.events.on_gui_elem_changed, function( event )
	local element = event.element
	local name = element.name
	local parent = element.parent
	if name == "SenpaisSmarterTrainsGUIElemButton01" and parent.children[1].selected_index > 0 then
		global.SenpaisScheduleLines[global.SenpaisLines[parent.children[1].selected_index]].signal = Senpais_Trains_Check( element.elem_value )
		return
	end
	if parent.name == "SenpaisSmarterTrainsGUITable03" then
		for _, f in pairs( global.SenpaisScheduleLinesSignals[global.SenpaisLines[parent.parent.parent.parent.children[1].children[1].selected_index]] ) do
			if name == "SenpaisSmarterTrainsGUIElemButton_" .. f.station then
				f.signal = Senpais_Trains_Check( element.elem_value )
			end
		end
		return
	end
end )

script.on_event( defines.events.on_player_created, function( event )
	if not mod_gui.get_button_flow( game.players[event.player_index] ).SenpaisGUIButton then
		local button = Senpais_Trains_Add_Sprite_Button( mod_gui.get_button_flow( game.players[event.player_index] ), "SenpaisGUIButton", "Senpais-S" )
		button.style.visible = true
	end
	global.PlayerDATA[game.players[event.player_index].index] = { TrainsCount = {}, WagonsCount = {}, FluidWagonsCount = {}, EntityName = {}, EntityCount = {} }
end )

script.on_event( defines.events.on_train_changed_state, function( event )
	local train = event.train
	if train.state == defines.train_state.wait_station then
		local station = train.station
		global.SenpaisTrainSchedulebyID[train.id] = { coupling = false, smartertrains = false, station = station }
		if settings.startup["Coupling"].value and ( station.get_circuit_network( defines.wire_type.red ) or  station.get_circuit_network( defines.wire_type.green ) ) then
			global.SenpaisTrainSchedulebyID[train.id].coupling = true
		end
		if settings.startup["Smarter-Trains"].value and station.get_circuit_network( defines.wire_type.red ) and station.get_circuit_network( defines.wire_type.green ) then
			global.SenpaisTrainSchedulebyID[train.id].smartertrains = true
		end
	end
	if train.state == defines.train_state.on_the_path and event.old_state == defines.train_state.wait_station and global.SenpaisTrainSchedulebyID[train.id] then
		local train_global = global.SenpaisTrainSchedulebyID[train.id]
		global.SenpaisTrainSchedulebyID[train.id] = nil
		local station = train_global.station
		if train_global.smartertrains then
			train.manual_mode = true
			local red = station.get_circuit_network( defines.wire_type.red )
			local green = station.get_circuit_network( defines.wire_type.green )
			local LinieSignals = {}
			for o, p in pairs( global.SenpaisScheduleLines ) do
				if p.signal ~= nil then
					table.insert( LinieSignals, { signal = Senpais_Trains_Check( { type = p.signal.type, name = p.signal.name } ), linie = o } )
				end
			end
			local LinieHighestSignal = { signal = nil, value = 0, linie = nil }
			for _, u in pairs( LinieSignals ) do
				if red.get_signal( u.signal ) ~= nil and red.get_signal( u.signal ) > LinieHighestSignal.value then
					LinieHighestSignal = { signal = u.signal, value = red.get_signal( u.signal ), linie = u.linie }
				end
			end
			if LinieHighestSignal.linie ~= nil then
				local StationSignals = {}
				for _, b in pairs( global.SenpaisScheduleLinesSignals[LinieHighestSignal.linie] ) do
					if b.signal ~= nil then
						table.insert( StationSignals, { signal = Senpais_Trains_Check( { type = b.signal.type, name = b.signal.name } ), station = b.station } )
					end
				end
				local StationHighestSignal = { signal = nil, value = 0, station = nil }
				for _, d in pairs( StationSignals ) do
					if green.get_signal( d.signal ) and green.get_signal( d.signal ) > StationHighestSignal.value then
						StationHighestSignal = { signal = d.signal, value = green.get_signal( d.signal ), station = d.station }
					end
				end
				if StationHighestSignal.station ~= nil then
					local currentvalue = 0
					local records = global.SenpaisScheduleLines[LinieHighestSignal.linie].schedule.records
					for i = 1, #records do
						if records[i].station == StationHighestSignal.station then
							currentvalue = i
							break
						end
					end
					train.schedule = { current = currentvalue, records = records }
				end
			end
			train.manual_mode = false
		end
		if train_global.coupling then
			local couple = false
			local front = Senpais_Trains_GetRealFront( train, station )
			local back = Senpais_Trains_GetRealBack( train, station )
			local schedule = train.schedule
			local changed = false
			if Senpais_Trains_AttemptCouple( train, Senpais_Trains_GetSignal( station, Senpais.Signals["Signal_Couple"] ), station ) then
				changed = true
				couple = true
				train = front.train
				if front == train.front_stock or back == train.back_stock then
					front = train.front_stock
					back = train.back_stock
				else
					front = train.back_stock
					back = train.front_stock
				end
			end
			front = Senpais_Trains_AttemptUncouple( front, Senpais_Trains_GetSignal( station, Senpais.Signals["Signal_Uncouple"] ) )
			if front then
				changed = true
			else
				front = back
			end
			if changed then
				front.train.schedule = schedule
				if #front.train.locomotives > 0 or couple then front.train.manual_mode = false end
				back.train.schedule = schedule
				if #back.train.locomotives > 0 or couple then back.train.manual_mode = false end
			end
		end
	end
end )

script.on_event( defines.events.on_tick, function( event )
	local PowerNeed = 0
	local PowerStorage = 0
	local PowerPer = 0
	if global.SenpaisTrainsList ~= nil and global.SenpaisAccuList ~= nil then
		for _, p in pairs( global.SenpaisTrainsList ) do
			PowerNeed = PowerNeed + ( p.entity.burner.heat_capacity - p.entity.burner.heat )
		end
		for _, a in pairs( global.SenpaisAccuList ) do
			PowerStorage = PowerStorage + a.energy
		end
		if PowerStorage >= PowerNeed then
			for _, u in pairs( global.SenpaisTrainsList ) do
				u.entity.burner.heat = u.entity.burner.heat_capacity
			end
			PowerPer = PowerNeed / #global.SenpaisAccuList
			for _, o in pairs( global.SenpaisAccuList ) do
				o.energy = o.energy - PowerPer
			end
		else
			for _, w in pairs( global.SenpaisAccuList ) do
				w.energy = 0
			end
			PowerPer = PowerStorage / #global.SenpaisTrainsList
			for _, n in pairs( global.SenpaisTrainsList ) do
				n.entity.burner.heat = PowerPer
			end
		end
	end
	if settings.startup["Senpais-Power-Provider"].value and event.tick % ( game.speed * 15 ) == 0 then
		for _, player in pairs( game.players ) do
			local GUI = mod_gui.get_frame_flow( player ).SenpaisGUI
			if GUI and GUI.SenpaisGUITable01.children[2].children[1] ~= nil and GUI.SenpaisGUITable01.children[2].children[1].name == "SenpaisElectricTrainsStatesFrame01" then
				GUI.SenpaisGUITable01.children[2].clear()
				Senpais_Trains_ElectricTrainsStatesGUIMain( GUI.SenpaisGUITable01.children[2] )
			end
		end
	end
end )

script.on_event( defines.events.on_built_entity, Senpais_Trains_OnBuild )
script.on_event( defines.events.on_robot_built_entity, Senpais_Trains_OnBuild )
script.on_event( defines.events.on_pre_player_mined_item, Senpais_Trains_OnRemove )
script.on_event( defines.events.on_robot_pre_mined, Senpais_Trains_OnRemove )
script.on_event( defines.events.on_entity_died, Senpais_Trains_OnRemove )

remote.add_interface( "ADDTRAIN", { ADDTRAIN = function( name, multiplier ) table.insert( global.Register, { name = name, multy = multiplier } ) end } )