#define CLOTH_PER_COCOON 6
#define FROST_MOTHS_TO_SUMMON 3
#define FROST_MOTH_RESPAWN_TIME (20 SECONDS)

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
			if (H.stat != CONSCIOUS)
				consumed_someone = TRUE
				consumed_something = TRUE

				var/moth_sacrificed = H.mind?.has_antag_datum(/datum/antagonist/frost_moth) && (H.key || H.get_ghost(FALSE, TRUE))
				if (moth_sacrificed)
					visible_message("<span class='warning'>\The [src] takes the body of [H], and tries to reconstruct [p_them(H)].</span>")
					var/mob/moth_soul = H.key ? H : H.get_ghost(FALSE, TRUE)
					to_chat(moth_soul, "Your body has returned to the loom, and you will return shortly. </br><b>Your memories will remain intact in your new body, as your soul is being salvaged</b>")
					SEND_SOUND(moth_soul, sound('sound/magic/enter_blood.ogg', volume = 100))
					addtimer(CALLBACK(src, .proc/respawn_moth, H.mind, H.real_name), FROST_MOTH_RESPAWN_TIME)

				for (var/obj/item/I in H.get_clothing_slots())
					// Throw away clothes from sacrificed moths so clicking on the loom more than once doesn't trash the clothes
					if (istype(I, /obj/item/clothing) && !moth_sacrificed)
						qdel(I)
						consumed_cloth += 1
					else
						I.forceMove(loc)
						I.throw_at(pick(oview(3)), rand(1, 3), 2)

				H.dust()
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

/obj/structure/icemoon/frost_moth/proc/respawn_moth(datum/mind/old_mind, old_name)
	var/mob/living/carbon/human/M = new /mob/living/carbon/human(get_step(loc, pick(GLOB.alldirs)))
	M.set_species(/datum/species/moth/frost_moth)
	M.real_name = old_name
	M.underwear = "Nude"
	M.update_body()
	old_mind.transfer_to(M)
	M.mind.grab_ghost()
	to_chat(M, "<b>You have returned from death, ready to serve alongside your tribe once more.</b>")
	playsound(get_turf(M), 'sound/magic/exit_blood.ogg', 100, TRUE)

/obj/screen/alert/notify_action/frost_moth_revive


#undef CLOTH_PER_COCOON
#undef FROST_MOTHS_TO_SUMMON
#undef FROST_MOTH_RESPAWN_TIME
