game.reload_script()

for index, force in pairs( game.forces ) do
	force.reset_recipes()
	force.reset_technologies()
end

for index, force in pairs( game.forces ) do
	local tech = force.technologies
	local recipe = force.recipes
	if tech["modular-armor"].researched then
		if recipe["Battle-Loco-1"] then recipe["Battle-Loco-1"].enabled = true end
		if recipe["Battle-Wagon-1"] then recipe["Battle-Wagon-1"].enabled = true end
		if recipe["Elec-Battle-Loco-1"] then recipe["Elec-Battle-Loco-1"].enabled = true end
	end
	if tech["power-armor"].researched then
		if recipe["Battle-Loco-2"] then recipe["Battle-Loco-2"].enabled = true end
		if recipe["Battle-Wagon-2"] then recipe["Battle-Wagon-2"].enabled = true end
		if recipe["Elec-Battle-Loco-2"] then recipe["Elec-Battle-Loco-2"].enabled = true end
	end
	if tech["power-armor-2"].researched then
		if recipe["Battle-Loco-3"] then recipe["Battle-Loco-3"].enabled = true end
		if recipe["Battle-Wagon-3"] then recipe["Battle-Wagon-3"].enabled = true end
		if recipe["Elec-Battle-Loco-3"] then recipe["Elec-Battle-Loco-3"].enabled = true end
	end
end