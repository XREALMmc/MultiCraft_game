--
-- Seeds
--

-- Pumpkin
for i = 2, 5 do
	minetest.override_item("default:dry_grass_" .. i, {drop = {
		max_items = 1,
		items = {
			{items = {"farming_addons:seed_pumpkin"}, rarity = 12},
			{items = {"default:dry_grass_1"}}
		}
	}})
end

-- Carrot
-- Wheat
for i = 2, 5 do
	minetest.override_item("default:grass_" .. i, {drop = {
		max_items = 1,
		items = {
			{items = {"farming:seed_wheat"}, rarity = 5},
			{items = {"farming_addons:seed_carrot"}, rarity = 12},
			{items = {"default:grass_1"}}
		}
	}})
end

-- Potato
minetest.override_item("default:junglegrass", {drop = {
	max_items = 1,
	items = {
		{items = {"farming_plants:seed_potato"}, rarity = 6},
		{items = {"farming_plants:seed_cucumber"}, rarity = 8},
		{items = {"default:junglegrass"}}
	}
}})

-- Corn
-- Melon
minetest.override_item("default:dry_shrub", {drop = {
	max_items = 1,
	items = {
		{items = {"farming_plants:seed_corn"}, rarity = 6},
		{items = {"default:dry_shrub"}}
	}
}})
