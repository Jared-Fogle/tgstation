#define CARGO_TECH_SECOND_TOOL_CHANCE 20

GLOBAL_LIST_INIT(ice_moon_corpses, collect_ice_moon_corpses())

/// Returns a list of every corpse type path and its weight
/proc/collect_ice_moon_corpses()
	. = list()
	for (var/_C in subtypesof(/obj/effect/mob_spawn/human/corpse/icemoon))
		var/obj/effect/mob_spawn/human/corpse/icemoon/C = _C
		.[C] = initial(C.weight)

/// A parent class for any corpse that should spawn on the Ice Moon.
/// Will be spawned near the aggro range of enemies.
/// Should generally have around 3 clothes on them so that one
/// unstripped body can be used to create a new frost moth cocoon.
/obj/effect/mob_spawn/human/corpse/icemoon
	/// The weight that this corpse will be spawned
	var/weight = 1

/obj/effect/mob_spawn/human/corpse/icemoon/cargo_tech
	outfit = /datum/outfit/ice_moon_corpse/cargo_tech

/obj/effect/mob_spawn/human/corpse/icemoon/wanderer
	weight = 4
	outfit = /datum/outfit/ice_moon_corpse/wanderer

/datum/outfit/ice_moon_corpse/cargo_tech
	belt = /obj/item/storage/belt/utility
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/hooded/wintercoat/miner
	uniform = /obj/item/clothing/under/rank/cargo/tech

	var/tools = list(
		/obj/item/crowbar,
		/obj/item/wrench,
		/obj/item/wirecutters,
		/obj/item/screwdriver,
		/obj/item/weldingtool
	)

/datum/outfit/ice_moon_corpse/cargo_tech/post_equip(mob/living/carbon/human/H, visuals_only)
	if (!visuals_only)
		var/obj/item/storage/belt = H.belt
		if (istype(belt))
			var/first_tool = pick(tools)
			new first_tool(belt)
			if (prob(CARGO_TECH_SECOND_TOOL_CHANCE))
				var/second_tool = pick(tools - first_tool)
				new second_tool(belt)

/datum/outfit/ice_moon_corpse/wanderer
	shoes = /obj/item/clothing/shoes/sneakers/black
	suit = /obj/item/clothing/suit/hooded/wintercoat
	uniform = /obj/item/clothing/under/color/random

#undef CARGO_TECH_SECOND_TOOL_CHANCE
