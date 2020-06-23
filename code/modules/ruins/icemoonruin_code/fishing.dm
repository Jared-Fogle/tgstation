#define FISH_DEFINE(fish_type, with_rod, without_rod) list("type" = fish_type, "chance_with_rod" = with_rod, "chance_without_rod" = without_rod)
#define FISH_RATE_IMPOSSIBLE 0
#define FISH_RATE_COMMON 3
#define TIME_TO_FISH (7 SECONDS)

/obj/item/fishing_rod
	name = "fishing rod"
	desc = "A fishing rod. You can attach bait to it and catch some fish if you know where to look."
	// TODO: Icon
	icon = 'icons/obj/items_and_weapons.dmi'
	icon_state = "telebaton_1"
	lefthand_file = 'icons/mob/inhands/weapons/melee_lefthand.dmi'
	righthand_file = 'icons/mob/inhands/weapons/melee_righthand.dmi'
	inhand_icon_state = "nullrod"

	var/obj/item/bait

/obj/item/fishing_rod/proc/update_bait()
	// TODO: Icon state
	if (bait == null)
		desc = initial(desc)
		maptext = ""
	else
		desc = "[initial(desc)]\n<span class='notice'>It has [bait] attached</span>"
		maptext = "<span class='maptext'>bait</span>"

/obj/item/fishing_rod/attackby(obj/item/W, mob/user)
	var/obj/item/reagent_containers/food/snacks/meat/meat = W
	if (!istype(meat))
		to_chat(user, "<span class='warning'>You don't think the fish will be interested in [W].</span>")
		return

	if (!user.transferItemToLoc(W, src))
		return

	if (bait != null)
		user.put_in_hands(bait)

	bait = W
	update_bait()

	return ..()

/obj/item/fishing_rod/attack_self(mob/user)
	if (bait)
		user.put_in_hands(bait)
		bait = null
		update_bait()

/obj/structure/sink/ice_fishing_pond
	name = "pond"
	desc = "A pond that looks like it was carved out of the ice. There seem to be fish swimming by, maybe you can catch some."
	// TODO: Icon
	icon_state = "puddle"
	resistance_flags = FREEZE_PROOF | UNACIDABLE
	density = TRUE

	var/static/list/fish = list(
		FISH_DEFINE(/mob/living/simple_animal/crab, FISH_RATE_COMMON, FISH_RATE_COMMON)
	)

/obj/structure/sink/ice_fishing_pond/attackby(obj/item/O, mob/living/user)
	var/obj/item/fishing_rod/fishing_rod = O
	if (istype(fishing_rod))
		var/bait = fishing_rod.bait
		var/with_bait = bait ? "with \the [fishing_rod.bait] attached" : "without any bait"
		user.visible_message("<span class='notice'>[user] casts \the [fishing_rod] into \the [src] [with_bait].</span>", \
			"<span class='notice'>You cast \the [fishing_rod] into \the [src] [with_bait].</span>")

		if (!do_after(user, TIME_TO_FISH, target = src, extra_checks = CALLBACK(src, .proc/bait_consistent, fishing_rod, bait)))
			return

		var/list/weighted = list()

		for (var/fish_data in fish)
			var/weight = fish_data[bait ? "chance_with_rod" : "chance_without_rod"]
			if (weight > 0)
				weighted[fish_data["type"]] = weight

		// TODO: Sound
		var/fish_type = pickweight(weighted)
		var/caught_fish = new fish_type(get_turf(user))
		user.visible_message("<span class='notice'>[user] caught \a [caught_fish]!", \
			"<span class='notice'>You caught \a [caught_fish]!</span>")

		QDEL_NULL(fishing_rod.bait)
		fishing_rod.update_bait()
		return

	return ..()

/obj/structure/sink/ice_fishing_pond/proc/bait_consistent(obj/item/fishing_rod/fishing_rod, bait)
	return fishing_rod.bait == bait

#undef FISH_DEFINE
#undef FISH_RATE_IMPOSSIBLE
#undef FISH_RATE_COMMON
#undef TIME_TO_FISH
