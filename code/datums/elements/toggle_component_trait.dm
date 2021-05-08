/// Entities with this element will dynamically add/remove components/elements depending on the existence of a trait.
/datum/element/toggle_component_trait
	element_flags = ELEMENT_BESPOKE | ELEMENT_DETACH
	id_arg_index = 2

	/// The trait we are observing.
	var/trait_to_watch

	/// If this is TRUE, then we'll only have this component if we DON'T have `trait_to_watch`.
	var/inverse = TOGGLE_COMPONENT_TRAIT_DIRECT

	/// The component type to add.
	var/component_type

	/// The arguments to create the component with.
	var/list/arguments

/datum/element/toggle_component_trait/Attach(datum/target, trait_to_watch, inverse, component_type, ...)
	. = ..()

	src.trait_to_watch = trait_to_watch
	src.inverse = inverse
	src.component_type = component_type

	// This intentionally copies component_type with it
	src.arguments = args.Copy(4)

	check(target)
	RegisterSignal(target, SIGNAL_ADDTRAIT(trait_to_watch), .proc/on_trait_added)
	RegisterSignal(target, SIGNAL_REMOVETRAIT(trait_to_watch), .proc/on_trait_removed)

/datum/element/toggle_component_trait/Detach(datum/source, ...)
	. = ..()

	UnregisterSignal(source, list(
		SIGNAL_ADDTRAIT(trait_to_watch),
		SIGNAL_REMOVETRAIT(trait_to_watch),
	))

	// Remove the component if we already have it
	if (HAS_TRAIT(source, trait_to_watch) != inverse)
		remove_component(source)

/datum/element/toggle_component_trait/proc/check(datum/target)
	if (HAS_TRAIT(target, trait_to_watch) == inverse)
		remove_component(target)
	else
		add_component(target)

/datum/element/toggle_component_trait/proc/on_trait_added(datum/target)
	SIGNAL_HANDLER
	if (inverse)
		remove_component(target)
	else
		add_component(target)

/datum/element/toggle_component_trait/proc/on_trait_removed(datum/target)
	SIGNAL_HANDLER
	if (inverse)
		add_component(target)
	else
		remove_component(target)

/datum/element/toggle_component_trait/proc/add_component(datum/target)
	log_world("ADD: [target]")
	if (ispath(component_type, /datum/component))
		target._AddComponent(arguments.Copy())
	else if (ispath(component_type, /datum/element))
		target._AddElement(arguments.Copy())
	else
		CRASH("invalid path: [component_type]")

/datum/element/toggle_component_trait/proc/remove_component(datum/target)
	log_world("REMOVE: [target]")
	if (ispath(component_type, /datum/component))
		qdel(target.GetComponent(component_type))
	else if (ispath(component_type, /datum/element))
		// target._RemoveElement(arguments.Copy())
	else
		CRASH("invalid path: [component_type]")
