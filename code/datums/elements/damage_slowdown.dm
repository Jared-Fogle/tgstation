/// Living mobs with this element will slow down the more damage they take.
/datum/element/damage_slowdown
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	/// The amount to multiply health deficiencies by to get slowdown
	var/slowdown_multiplier = 1 / 75

	/// The amount to multiply health deficiencies by to get slowdown for flying
	var/slowdown_multiplier_flying = 1 / 25

	/// The minimum amount of damage before slowdown takes effect
	var/minimum_damage_needed = 40

/datum/element/damage_slowdown/Attach(
	datum/target,
	slowdown_multiplier,
	slowdown_multiplier_flying,
	minimum_damage_needed,
)
	. = ..()

	if (!isliving(target))
		return ELEMENT_INCOMPATIBLE

	if (slowdown_multiplier)
		src.slowdown_multiplier = slowdown_multiplier

	if (slowdown_multiplier_flying)
		src.slowdown_multiplier_flying = slowdown_multiplier_flying

	if (minimum_damage_needed)
		src.minimum_damage_needed = minimum_damage_needed

	RegisterSignal(target, COMSIG_LIVING_HEALTH_SET, .proc/on_health_updated)

	update_slowdown(target)

/datum/element/damage_slowdown/Detach(datum/source, ...)
	. = ..()

	var/mob/living/living_source = source
	living_source.remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown)
	living_source.remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown_flying)

	UnregisterSignal(source, COMSIG_LIVING_HEALTH_SET)

/datum/element/damage_slowdown/proc/on_health_updated(mob/living/source)
	SIGNAL_HANDLER
	update_slowdown(source)

/datum/element/damage_slowdown/proc/update_slowdown(mob/living/target)
	var/health_deficiency = max((target.maxHealth - target.health), target.staminaloss)

	if(health_deficiency >= minimum_damage_needed)
		target.add_or_update_variable_movespeed_modifier(
			/datum/movespeed_modifier/damage_slowdown,
			update = TRUE,
			multiplicative_slowdown = health_deficiency * slowdown_multiplier,
		)

		target.add_or_update_variable_movespeed_modifier(
			/datum/movespeed_modifier/damage_slowdown_flying,
			update = TRUE,
			multiplicative_slowdown = health_deficiency * slowdown_multiplier_flying,
		)
	else
		target.remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown)
		target.remove_movespeed_modifier(/datum/movespeed_modifier/damage_slowdown_flying)
