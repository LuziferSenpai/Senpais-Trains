# How to add your own Electric Trains/Battle Locomotives/Battle Wagons

## First!!
You should add a `"?Senpais_Trains”` dependency into your info.json. That makes sure, that my Modification is loaded before yours.

## Electric Trains:
First you generate a Electric Train Entity, Item, Recipe in the data.lua file.
For that you call the Function `Senpais.Functions.Create.Elec_Locomotive( multiplier, name, icon, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )`
multiplier = how much more can this pull to a vanilla locomotive? (600kw * multiplier)
name = name of the entity, item and recipe
icon = icon of the entity and item
health = the maximal health of this entity
weight = how much does it weight?
speed = maximum speed
color = the locomotive color
grid = can be nil, if you dont want one
subgroup = subgroup of the item
order = order of the item
stack = stacksize of the item
ingredients = recipe ingredients
tech = which tech unlocks the recipe?

Second you call a remote event in control.lua to let the script know, there is a new Electric Train.
For that you just write into your control.lua:
`script.on_init( function() if remote.interfaces["Addtrain"] then remote.call( "Addtrain", "new", entity-name, multiplier ) end end )`.

## Battle Locomotives:
You just generate a Battle Locomotives Entity, Item, Recipe in the data.lua file.
For that you call the Function `Senpais.Functions.Create.Battle_Locomotive( multiplier, name, icon, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )`
multiplier = how much more can this pull to a vanilla locomotive? (600kw * multiplier)
name = name of the entity, item and recipe
icon = icon of the entity and item
health = the maximal health of this entity
weight = how much does it weight?
speed = maximum speed
color = the locomotive color
grid = the grid you want to use
subgroup = subgroup of the item
order = order of the item
stack = stacksize of the item
ingredients = recipe ingredients
tech = which tech unlocks the recipe?

## Battle Wagons:
You just generate a Battle Locomotives Entity, Item, Recipe in the data.lua file.
For that you call the Function `Senpais.Functions.Create.Battle_Wagon( name, icon, inventory, health, weight, speed, color, grid, subgroup, order, stack, ingredients, tech )`
name = name of the entity, item and recipe
icon = icon of the entity and item
iventory = the inventory size
health = the maximal health of this entity
weight = how much does it weight?
speed = maximum speed
color = the wagon color
grid = the grid you want to use
subgroup = subgroup of the item
order = order of the item
stack = stacksize of the item
ingredients = recipe ingredients
tech = which tech unlocks the recipe?

And this was all!
There are few other functions, but I dont explain them.