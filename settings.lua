local function SETTINGSBOOLSTARTUP ( name, value, order )
	local Setting =
	{
	 type = "bool-setting",
	 name = name,
	 setting_type = "startup",
	 default_value = value,
	 order = order
	}

	return Setting
end

data:extend
(
{
 SETTINGSBOOLSTARTUP( "Senpais-Power-Provider", true, "01" ),
 SETTINGSBOOLSTARTUP( "Senpais-Electric-Train", true, "02" ),
 SETTINGSBOOLSTARTUP( "Battle-Laser", true, "03" ),
 SETTINGSBOOLSTARTUP( "Senpais-Electric-Train-Heavy", true, "04" ),
 SETTINGSBOOLSTARTUP( "Battle-Loco-1", true, "05" ),
 SETTINGSBOOLSTARTUP( "Battle-Loco-2", true, "06" ),
 SETTINGSBOOLSTARTUP( "Battle-Loco-3", true, "07" ),
 SETTINGSBOOLSTARTUP( "Battle-Wagon-1", true, "08" ),
 SETTINGSBOOLSTARTUP( "Battle-Wagon-2", true, "09" ),
 SETTINGSBOOLSTARTUP( "Battle-Wagon-3", true, "10" ),
 SETTINGSBOOLSTARTUP( "Elec-Battle-Loco-1", true, "11" ),
 SETTINGSBOOLSTARTUP( "Elec-Battle-Loco-2", true, "12" ),
 SETTINGSBOOLSTARTUP( "Elec-Battle-Loco-3", true, "13" ),
 SETTINGSBOOLSTARTUP( "braking-force-8", true, "14" ),
 SETTINGSBOOLSTARTUP( "braking-force-9", true, "15" ),
 SETTINGSBOOLSTARTUP( "Senpais-Dora", true, "16" ),
 SETTINGSBOOLSTARTUP( "Coupling", true, "17" ),
 SETTINGSBOOLSTARTUP( "Smarter-Trains", true, "18" )
}
)