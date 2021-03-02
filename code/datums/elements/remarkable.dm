#define REMARKABLE_KEY_CORPSE "corpse"

/// This atom, when examined, will play ambience to the examiner if its
/// their first time seeing something like it.
/datum/element/remarkable
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	/// A key to distinguish this remarkable with others like it.
	var/key

	/// The ambience to play to the examiner when they examine.
	var/ambience

	/// The volume to play the ambience at.
	var/volume = 25

	/// What trait decides whether or not the examiner cares?
	/// If null, will not be checked.
	var/trait_needed = null

	/// A lazy list of weakref</datum/mind> that have examined
	var/list/remarked

/datum/element/remarkable/Attach(datum/target, key, ambience, trait_needed, volume)
	if (!isatom(target))
		return ELEMENT_INCOMPATIBLE

	src.ambience = ambience
	src.key = key
	src.trait_needed = trait_needed
	src.volume = volume

	RegisterSignal(target, COMSIG_PARENT_EXAMINE, .proc/on_examine)

	return ..()

/datum/element/remarkable/proc/on_examine(datum/source, mob/user)
	SIGNAL_HANDLER

	var/mind = user.mind
	if (isnull(mind))
		return

	var/mind_weakref = WEAKREF(mind)
	if (LAZYFIND(remarked, mind_weakref))
		return

	LAZYADD(remarked, mind_weakref)
	SEND_SOUND(user, sound(ambience, repeat = 0, wait = 0, volume = volume, channel = CHANNEL_AMBIENCE))

/// A pre-made remarkable element to be applied to corpses.
/datum/element/remarkable/corpse

/datum/element/remarkable/corpse/Attach(datum/target)
	return ..(target, REMARKABLE_KEY_CORPSE, 'sound/ambience/remarkcorpse.ogg', TRAIT_CARES_ABOUT_DEATH)

#undef REMARKABLE_KEY_CORPSE
