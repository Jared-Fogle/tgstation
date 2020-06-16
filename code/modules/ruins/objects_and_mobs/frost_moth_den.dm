#define FROST_MOTHS_TO_SUMMON 3

/obj/structure/icemoon/frost_moth
	name = "frost moth loom"
	desc = "It looks like an ordinary loom, but it definitely doesn't feel like one. It's surrounded by rapidly growing cocoons..."
	icon = 'icons/obj/hydroponics/equipment.dmi'
	icon_state = "loom"
	move_resist = INFINITY
	anchored = TRUE
	density = TRUE
	resistance_flags = FREEZE_PROOF
	max_integrity = 200

	var/datum/team/frost_moths/team
	var/used_directions = 0

/obj/structure/icemoon/frost_moth/Initialize()
	. = ..()
	team = new
	var/datum/objective/protect_object/objective = new
	objective.set_target(src)
	team.objectives += objective

	SSticker.OnRoundstart(CALLBACK(src, .proc/spawn_initial_cocoons))

/obj/structure/icemoon/frost_moth/proc/spawn_initial_cocoons()
	for (var/_ in 1 to FROST_MOTHS_TO_SUMMON)
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

#undef FROST_MOTHS_TO_SUMMON
