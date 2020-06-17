/// A parent class for any corpse that should spawn on the Ice Moon.
/// Will be spawned near the aggro range of enemies.
/// Should generally have around 3 clothes on them so that one
/// unstripped body can be used to create a new frost moth cocoon.
/obj/effect/mob_spawn/human/corpse/icemoon

/obj/effect/mob_spawn/human/corpse/icemoon/wanderer
	outfit = /datum/outfit/ice_moon_corpse/wanderer

/datum/outfit/ice_moon_corpse/wanderer
	suit = /obj/item/clothing/suit/hooded/wintercoat
	uniform = /obj/item/clothing/under/color/random
	shoes = /obj/item/clothing/shoes/sneakers/black
