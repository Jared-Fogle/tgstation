#define CLOTH_PER_COCOON 3
#define FROST_MOTHS_TO_SUMMON 3

/// The frost moth loom. Handles summoning more frost moths and respawning.
/obj/structure/icemoon/frost_moth
	name = "frost moth loom"
	desc = "It looks like an ordinary loom, but it definitely doesn't feel like one. It's surrounded by rapidly growing cocoons..."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "loom"
	move_resist = INFINITY
	anchored = TRUE
	resistance_flags = FREEZE_PROOF
	max_integrity = 200

	var/datum/team/frost_moths/team
	var/consumed_cloth = 0
	var/used_directions = 0

/obj/structure/icemoon/frost_moth/Initialize()
	. = ..()
	team = new
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	team.objectives += objective

	SSticker.OnRoundstart(CALLBACK(src, .proc/spawn_initial_cocoons))

/obj/structure/icemoon/frost_moth/attackby(obj/item/I, mob/living/user, params)
	if (istype(I, /obj/item/clothing))
		qdel(I)
		consumed_cloth += 1
		cloth_consumed()
	else
		return ..()

/obj/structure/icemoon/frost_moth/attack_hand(mob/user)
	. = ..()
	if (.)
		return

	var/consumed_someone = FALSE
	var/consumed_something = FALSE

	for (var/thing in get_turf(src))
		if (istype(thing, /mob/living/carbon/human))
			var/mob/living/carbon/human/H = thing
			if (H.stat != CONSCIOUS && !H.mind?.has_antag_datum(/datum/antagonist/frost_moth))
				consumed_someone = TRUE
				consumed_something = TRUE
				for (var/obj/item/I in H.get_clothing_slots())
					if (istype(I, /obj/item/clothing))
						qdel(I)
						consumed_cloth += 1
					else
						I.forceMove(loc)
						I.throw_at(pick(oview(3)), rand(1, 3), 2)
				H.gib()
		else if (istype(thing, /obj/item/clothing))
			qdel(thing)
			consumed_cloth += 1
			consumed_something = TRUE

	if (consumed_someone)
		for (var/mob/living/L in view(src, 5))
			if (L.mind?.has_antag_datum(/datum/antagonist/frost_moth))
				SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_good)
			else
				SEND_SIGNAL(L, COMSIG_ADD_MOOD_EVENT, "oogabooga", /datum/mood_event/sacrifice_bad)
	else if (!consumed_something)
		to_chat(user, "<span class='warning'>\The [src] needs a clothed body to consume.</span>")

	if (consumed_something)
		cloth_consumed()

/obj/structure/icemoon/frost_moth/proc/spawn_initial_cocoons()
	for (var/_ in 1 to FROST_MOTHS_TO_SUMMON)
		spawn_cocoon()

/obj/structure/icemoon/frost_moth/proc/cloth_consumed()
	// TODO: Visual effect and sound here
	if (consumed_cloth >= CLOTH_PER_COCOON)
		var/plural = consumed_cloth >= CLOTH_PER_COCOON * 2
		visible_message("[plural ? "A cocoon" : "Several cocoons"] appear[plural ? "" : "s"], seemingly out of thin air!")
		while (consumed_cloth >= CLOTH_PER_COCOON)
			consumed_cloth -= CLOTH_PER_COCOON
			spawn_cocoon()

/obj/structure/icemoon/frost_moth/proc/spawn_cocoon()
	// Try to spawn the egg in a place we haven't put it in
	var/list/directions_left = list()
	var/list/directions_used = list()
	var/list/directions_closed = list()

	for (var/dir in GLOB.alldirs)
		if (get_open_turf_in_dir(src, dir))
			if (used_directions & dir)
				directions_used += dir
			else
				directions_left += dir
		else
			directions_closed += dir

	var/dir

	if (directions_left.len)
		// Use a unique direction if we can
		dir = pick(directions_left)
		used_directions |= dir
	else if (directions_used.len)
		// All directions have been used, but at least some are still open.
		dir = pick(directions_used)
		used_directions = 0
	else
		// All directions have been used, *and* are all closed. That's impressively dumb!
		dir = pick(directions_closed)
		used_directions = 0

	new /obj/effect/mob_spawn/human/frost_moth(get_step(loc, dir), team)
	visible_message("<span class='danger'>One of the cocoons starts to rattle aggressively. It's ready to hatch!</span>")

#undef CLOTH_PER_COCOON
#undef FROST_MOTHS_TO_SUMMON
