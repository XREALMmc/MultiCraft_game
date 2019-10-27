function beds.register_bed(name, def)
	minetest.register_node(name, {
		description = def.description,
		inventory_image = def.inventory_image,
		wield_image = def.wield_image,
		drawtype = "mesh",
		mesh = def.mesh,
		tiles = def.tiles,
		paramtype = "light",
		paramtype2 = "facedir",
		is_ground_content = false,
		stack_max = 1,
		groups = {choppy = 2, oddly_breakable_by_hand = 2, flammable = 3, bed = 1},
		sounds = def.sounds or default.node_sound_wood_defaults(),
		selection_box = {
			type = "fixed",
			fixed = def.selectionbox,
		},
		collision_box = {
			type = "fixed",
			fixed = def.collisionbox,
		},

		on_place = function(itemstack, placer, pointed_thing)
			local under = pointed_thing.under
			local node = minetest.get_node(under)
			local udef = minetest.registered_nodes[node.name]
			if udef and udef.on_rightclick and
					not (placer and placer:is_player() and
					placer:get_player_control().sneak) then
				return udef.on_rightclick(under, node, placer, itemstack,
					pointed_thing) or itemstack
			end

			local pos
			if udef and udef.buildable_to then
				pos = under
			else
				pos = pointed_thing.above
			end

			local player_name = placer and placer:get_player_name() or ""

			if minetest.is_protected(pos, player_name) and
					not minetest.check_player_privs(player_name, "protection_bypass") then
				minetest.record_protection_violation(pos, player_name)
				return itemstack
			end

			local pos_front = vector.new(pos)
			local dir = placer and placer:get_look_dir() and
				minetest.dir_to_facedir(placer:get_look_dir()) % 4 or 0
			if dir == 1 then
				pos_front.x = pos_front.x + 1
			elseif dir == 2 then
				pos_front.z = pos_front.z - 1
			elseif dir == 3 then
				pos_front.x = pos_front.x - 1
			else
				pos_front.z = pos_front.z + 1
			end
			for _, p in pairs({pos_front, pos}) do
				local node_def = minetest.registered_nodes[minetest.get_node(p).name]
				if node_def and node_def.buildable_to then
					minetest.remove_node(pos_front)
				end
				if not node_def or not node_def.buildable_to then
					return itemstack
				end
			end

			minetest.set_node(pos, {name = name, param2 = dir})

			if not (creative and creative.is_enabled_for
					and creative.is_enabled_for(player_name)) or
					not minetest.is_singleplayer() then
				itemstack:take_item()
			end
			return itemstack
		end,

		on_rightclick = function(pos, _, clicker, itemstack)
			beds.on_rightclick(pos, clicker)
			return itemstack
		end,

		can_dig = beds.can_dig
	})

	minetest.register_alias(name .. "_bottom", name)
	minetest.register_alias(name .. "_top", "air")

	minetest.register_craft({
		output = name,
		recipe = def.recipe
	})
end
