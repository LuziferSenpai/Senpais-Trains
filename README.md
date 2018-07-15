# Senpais Trains

Hey Guys,

this is a combination of my two old MODs [Senpais Electric Trains](https://mods.factorio.com/mods/LuziferSenpai/SenpaisElectricTrains) and [Battle Trains](https://mods.factorio.com/mods/LuziferSenpai/Battle-Train-MOD)!

## The Trains and Wagons
![5 Electric and 3 Normal Fuel Trains](https://i.imgur.com/wD8bF0T.png)

## The Power Provider
![This Provides the Power to the Trains!](https://i.imgur.com/KkTBOA4.png)

## The German Railway Gun "Dora"
![This is OP!](https://i.imgur.com/eeKFRQS.png)

## Automatic Coupling!

### How it works:
 - If you want to Couple you send the Coupling Signal
 - If you want to Uncouple you send the Uncoupling Signal with the Strength of how many you want to Uncouple.
 - Like in the GIF below it sends a Signal Strength of 10.
 - ITS NOT DESIGNED FOR SINGLE HEADED TRAINS!!!
[Coupling!](https://i.imgur.com/FPdnvFT.gifv)

## Simpler Smarter Trains!
 - You open the GUI and have a Train open.
 - Than you add a new Linie with the Schedule of the Train.
 - Than you assign a Signal to the Linie and to each Station on the Linie in the GUI.
 - Next when the Train arrives at a Station, it checks for Coupling Signals or/and if both Wires are connected.
 - When that is true, the Train will save the Station for it self, so it can read out the Signals when it leaves the Station.
 - Red Wire is for Schedule, Green Wire is for Station in that Schedule.

### Here is an Example Map:
[Click](https://www.dropbox.com/s/kzbz2ijlidozug9/Smarter%20Trains%20Example.zip?dl=0)

## New GUI with nice Features and a Overview for Stats!

## It adds 2 new Braking Force Research!

## If you want ModSupport than read the File for that in the Mod Folder.

## Does it have a Config?

### Yes everything is fully Configurable!

## Future Plans

 - More Trains
 - More Power Input Ways
 - Better Graphics
 - Electric Rails

## Known Bugs
 - Offset Issues by the Battle Laser while shooting

## Releases
 - v1.1.6
    - Hopefully fixed [Issue](https://github.com/LuziferSenpai/Senpais-Trains/issues/4)
 - v1.1.5
    - Hopefully fixed [Issue](https://github.com/LuziferSenpai/Senpais-Trains/issues/3)
 - v1.1.4
    - Fixed a horrible Bug with on_tick and valid entitys
 - v1.1.3
    - Fixed Bug with on_gui_click
 - v1.1.2
    - Fixed on_player_created
 - v1.1.1
 	- Added Support for script raised built Entitys!
 - v1.1.0
    - Reworked the Code
    - Removed a bit of Code Mass
    - Redone GUI
    - Redone globals
    - Redone PlayerData
    - Redone most of the Code
 - v1.0.7
    - Added Player Train Kills List
 - v1.0.6
    - HOPEFULLY ITS FIXED NOW.
    - I HATE SPRITES.
 - v1.0.5
    - Now it should be really fixed.
 - v1.0.4
    - Fixed a Small Bug I hope.
 - v1.0.3
    - A bit of GUI rework
    - Some smaller Stuff
 - v1.0.2
    - Renamed Functions
    - Removed some not needed Variabels
    - Redone some Stuff
 - v1.0.1
    - Fixed Function Bug
 - v1.0.0
    - Reworked the complete Modification.
    - Added a new GUI
    - Reworked the Smarter Trains GUI
    - Reworked the way Settings getting readed.
 - v0.4.5
    - Fixed a Bug that the Icon for the Smarter Trains is going away.
 - v0.4.4
    - Fixed a Small writing Fail
 - v0.4.3
    - Added locale to Smarter Trains Setting
    - Reworked Smarter Trains, so it reads out after leaving the Station.
    - Reworked some Code again.
 - v0.4.2
    - Fixed a locale Fail
 - v0.4.1
    - Changed the Max Speed of most of the Electronic Trains, I hope they are now better.
    - Added a Code to the on config changed script.
 - v0.4.0
    - Added Simpler Smarter Trains
    - Changed Coupling so its Couple/Uncouple after Leaving the Station
    - Some Code rework
 - v0.3.1
    - Now its really disabeling Coupling with a Setting, even in controls
 - v0.3.0
    - Added Automic Coupling with Enable/Disable!
 - v0.2.2
    - Enabled Battle Laser
    - Increased Damage of Atomic 80cm Caliber Shell
    - Increased Recipe Cost of Atomic 80cm Caliber Shell
    - Added new Map Visulation while Shooting
 - v0.2.1
    - Added Cliff destruction to the Atomic 80cm Caliber Shell
 - v0.2.0 
    - Updated to .16
    - Disabled Battle Laser because of Issues
    - New Artillery Wagon called German Railway Gun "Dora"
    - New Atomic 80cm Caliber Shell only for the German Railway Gun "Dora"
    - fixxed some Bugs

## Credits

 - [Mooncat](https://mods.factorio.com/mods/Mooncat) for the Train and Wagon Masks
 - [Klonan](https://mods.factorio.com/mods/Klonan) for the Laser Turret Sounds and Laser Graphics
 - [GotLag](https://mods.factorio.com/user/GotLag) for his Permission to overtake Automic Coupling
 - Hopewelljnj for his changes to Automic Coupling MOD that I have overtaken
 - Dead Planet for Graphical Help