#define FISH_DEFINE(fish_type, with_rod, without_rod) list("type" = fish_type, "chance_with_rod" = with_rod, "chance_without_rod" = without_rod)
#define FISH_RATE_IMPOSSIBLE 0
#define FISH_RATE_RARE 1
#define FISH_RATE_UNCOMMON 2
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

/obj/item/fishing_rod/examine(mob/user)
	. = ..()
	if (bait != null)
		. += "<span class='notice'>It has [bait] attached</span>"

/obj/item/fishing_rod/update_icon_state()
	// TODO: Icon state
	if (bait == null)
		maptext = ""
	else
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
	update_icon_state()

	return ..()

/obj/item/fishing_rod/attack_self(mob/user)
	if (bait)
		user.put_in_hands(bait)
		bait = null
		update_icon_state()

/obj/item/fishing_rod/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] attempts to catch fish by casting \the [src] into their own throat! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return BRUTELOSS

/obj/structure/sink/ice_fishing_pond
	name = "pond"
	desc = "A pond that looks like it was carved out of the ice. There seem to be fish swimming by, maybe you can catch some."
	// TODO: Icon
	icon_state = "puddle"
	resistance_flags = FREEZE_PROOF | UNACIDABLE
	density = TRUE

	/// A list of fish that can spawn from the pond
	/// Elements are in the format of list("type" = atom/callback, "chance_with_rod" = number, "chance_without_rod" = number)
	var/list/fish

/obj/structure/sink/ice_fishing_pond/Initialize()
	. = ..()

	// FISH_DEFINE(item, chance_with_rod, chance_without_rod)
	fish = list(
		FISH_DEFINE(/mob/living/simple_animal/crab, FISH_RATE_COMMON, FISH_RATE_COMMON),
		FISH_DEFINE(/obj/item/storage/cans, FISH_RATE_IMPOSSIBLE, FISH_RATE_COMMON),
		FISH_DEFINE(/obj/item/fish/clownfish, FISH_RATE_COMMON, FISH_RATE_IMPOSSIBLE),
		FISH_DEFINE(/obj/item/fish/eel, FISH_RATE_RARE, FISH_RATE_UNCOMMON),
		FISH_DEFINE(/obj/item/fish/goldfish, FISH_RATE_IMPOSSIBLE, FISH_RATE_COMMON),
		FISH_DEFINE(/obj/item/fish/nurse_shark, FISH_RATE_RARE, FISH_RATE_UNCOMMON),
		FISH_DEFINE(/obj/item/melee/sabre/swordfish, FISH_RATE_RARE, FISH_RATE_UNCOMMON),
		FISH_DEFINE(CALLBACK(src, .proc/spawn_ore), FISH_RATE_UNCOMMON, FISH_RATE_UNCOMMON)
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
		var/datum/callback/fish_callback = fish_type
		if (istype(fish_callback))
			fish_callback.Invoke(user)
		else
			var/caught_fish = new fish_type(get_turf(user))
			user.visible_message("<span class='notice'>[user] caught \a [caught_fish]!", \
				"<span class='notice'>You caught \a [caught_fish]!</span>")

		QDEL_NULL(fishing_rod.bait)
		fishing_rod.update_icon_state()
		return

	return ..()

/obj/structure/sink/ice_fishing_pond/proc/bait_consistent(obj/item/fishing_rod/fishing_rod, bait)
	return fishing_rod.bait == bait

/obj/structure/sink/ice_fishing_pond/proc/spawn_ore(mob/user)
	for(var/type in GLOB.ore_probability)
		var/chance = GLOB.ore_probability[type]
		if(!prob(chance))
			continue
		var/obj/ore = new type(loc, rand(2, 3))
		user.visible_message("<span class='notice'>[user] caught some [ore.name]!</span>", \
			"<span class='notice'>You caught some [ore.name]!</span>")

/// Fish that can be received from the ice fishing pond
/// If adding a new one, it needs to be added to the pool (heh) of items in /obj/structure/sink/ice_fishing_pond/Initialize()
/obj/item/fish
	icon = 'icons/mob/icemoon/fish.dmi'
	w_class = WEIGHT_CLASS_SMALL
	// TODO: Replace with custom fish meat
	var/list/butcher_results

/obj/item/fish/suicide_act(mob/user)
	user.visible_message("<span class='suicide'>[user] feels so much remorse for the dead [src] that they start suffocating in solidarity! It looks like [user.p_theyre()] trying to commit suicide!</span>")
	return OXYLOSS

/obj/item/fish/Initialize()
	. = ..()
	butcher_results = list(/obj/item/reagent_containers/food/snacks/meat/rawcrab = 1)

	// TODO: Remove once sprites are added
	if (icon_state == null)
		maptext = "<span class='maptext'>[initial(name)]</span>"

/obj/item/fish/attackby(obj/item/I, mob/living/user, params)
	var/datum/component/butchering/butchering = I.GetComponent(/datum/component/butchering)
	if (!istype(butchering))
		return ..()

	playsound(get_turf(user), butchering.butcher_sound, 50, TRUE, -1)
	to_chat(user, "<span class='notice'>You begin to butcher \the [src]...</span>")
	if (!do_after(user, butchering.speed, target = src))
		return

	user.visible_message("<span class='notice'>[user] butchers \the [src].</span>", \
		"<span class='notice'>You butcher \the [src].</span>")

	var/turf/T = get_turf(src)

	for (var/produce in butcher_results)
		for (var/i in 1 to butcher_results[produce])
			new produce(T)

	new /obj/effect/gibspawner/generic(T)
	qdel(src)

/// Clownfish - Effectively the same as a bikehorn
/obj/item/fish/clownfish
	name = "clownfish"
	desc = "A fish with clown paint dried onto its face."

/obj/item/fish/clownfish/Initialize()
	. = ..()
	butcher_results[/obj/item/bikehorn] = 1

/obj/item/fish/clownfish/ComponentInitialize()
	. = ..()
	AddComponent(/datum/component/squeak, list('sound/items/bikehorn.ogg'=1), 50)

/// Electric eels - Acts as an inducer and can be used for the shock step in revival surgery
// TODO: Sprite for both when it has charge and when it doesn't
/obj/item/fish/eel
	name = "electric eel"
	desc = "A slippery snake-like fish."
	var/obj/item/inducer/eel/inducer

/obj/item/fish/eel/examine(mob/user)
	. = ..()

	switch (inducer.cell.charge / inducer.cell.maxcharge)
		if (0)
			. += "<span class='notice'>It doesn't have the same spark it used to.</span>"
		if (0.5 to 1)
			. += "<span class='notice'>It looks like it's charged.</span>"
		if (0.2 to 0.5)
			. += "<span class='notice'>It looks like it's charged, but it's fading.</span>"
		else
			. += "<span class='notice'>It looks like it has a little bit of charge left.</span>"

/obj/item/fish/eel/Initialize()
	. = ..()
	inducer = new

/obj/item/fish/eel/attack_obj(obj/O, mob/living/user)
	if (!inducer.recharge(O, user))
		..()

/obj/item/inducer/eel/induce(obj/item/stock_parts/cell/target, coefficient, mob/living/user)
	..()
	user.electrocute_act(10, src)

/// Goldfish - Can be butchered for gold ore
/obj/item/fish/goldfish
	name = "goldfish"
	desc = "A fish commonly kept as pets. You can hear what sounds like coins jingling when you hold it."

/obj/item/fish/goldfish/Initialize()
	. = ..()
	butcher_results = list(/obj/item/stack/ore/gold = 5)

/// Nurse shark - Butchered for medical supplies
/// When hooked up to an IV drip, can be drained of omnizine
/obj/item/fish/nurse_shark
	name = "nurse shark"
	desc = "This shark used to be terrifying, but now it's dead. Named after the fact that its blood has over time been mixed with healing chemicals."
	w_class = WEIGHT_CLASS_GIGANTIC

	/// Weighted list of how many items to spawn when butchering
	var/static/list/butcher_amount_chances = list(
		2 = 4,
		3 = 2,
		4 = 1,
	)

	/// Weighted list of the possible results when butchering
	var/static/list/butcher_item_chances = list(
		/obj/item/stack/medical/suture = 3,
		/obj/item/stack/medical/mesh = 3,
		/obj/item/stack/medical/gauze = 3,
		/obj/item/stack/medical/bone_gel = 2,
		/obj/item/stack/medical/aloe = 2,
		/obj/item/healthanalyzer = 1
	)

/obj/item/fish/nurse_shark/Initialize()
	. = ..()

	butcher_results = list()
	for (var/_ in 1 to pickweight(butcher_amount_chances))
		var/item = pickweight(butcher_item_chances)
		butcher_results[item] = (butcher_results[item] || 0) + 1

/// Swordfish - Reskin of the officer's sabre
/obj/item/melee/sabre/swordfish
	// TODO: Custom inhand sprite too
	name = "swordfish"
	desc = "A fish with a long, sharp snout. Capable of cutting through flesh and bone with ease."

#undef FISH_DEFINE
#undef FISH_RATE_IMPOSSIBLE
#undef FISH_RATE_RARE
#undef FISH_RATE_UNCOMMON
#undef FISH_RATE_COMMON
#undef TIME_TO_FISH
