/datum/customer_data
	///Name of the robot's origin
	var/nationality = "Generic"
	///The types of food this robot likes in a assoc list of venue type | weighted list. does NOT include subtypes.
	var/list/orderable_objects = list()
	///The amount a robot pays for each food he likes in an assoc list type | payment
	var/list/order_prices = list()
	///Datum AI used for the robot. Should almost never be overwritten unless theyre subtypes of ai_controller/robot_customer
	var/datum/ai_controller/ai_controller_used = /datum/ai_controller/robot_customer
	///Patience of the AI, how long they will wait for their meal.
	var/total_patience = 600 SECONDS
	///Lines the robot says when it finds a seat
	var/list/found_seat_lines = list("I found a seat")
	///Lines the robot says when it can't find a seat
	var/list/cant_find_seat_lines = list("I did not find a seat")
	///Lines the robot says when leaving without food
	var/list/leave_mad_lines = list("Leaving without food")
	///Lines the robot says when leaving with food
	var/list/leave_happy_lines = list("Leaving with food")
	///Lines the robot says when leaving waiting for food
	var/list/wait_for_food_lines = list("I'm still waiting for food")
	///Clothing sets to pick from when dressing the robot.
	var/list/clothing_sets = list("amerifat_clothes")
	///List of prefixes for our robots name
	var/list/name_prefixes
	///Prefix file to uise
	var/prefix_file = "strings/names/american_prefix.txt"
	///Base icon for the customer
	var/base_icon = "amerifat"
	///Sound to use when this robot type speaks
	var/speech_sound = 'sound/creatures/tourist/tourist_talk.ogg'

/datum/customer_data/New()
	. = ..()
	name_prefixes = world.file2list(prefix_file)

/// Can this customer be chosen for this venue?
/datum/customer_data/proc/can_use(datum/venue/venue)
	return TRUE

/// Called when the venue chooses this customer
/datum/customer_data/proc/chosen(datum/venue/venue)

/// Gets the order of this customer.
/// In most cases, you shouldn't override this, and should just modify orderable_objects.
/datum/customer_data/proc/get_order(datum/venue/venue)
	return pickweight(orderable_objects[venue.type])

/datum/customer_data/proc/get_overlays(mob/living/simple_animal/robot_customer/customer)
	return

/datum/customer_data/american
	nationality = "Space-American"
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/burger/plain = 25, /obj/item/food/burger/cheese = 15, /obj/item/food/burger/superbite = 1, /obj/item/food/fries = 10, /obj/item/food/cheesyfries = 6, /obj/item/food/pie/applepie = 4, /obj/item/food/pie/pumpkinpie = 2, /obj/item/food/hotdog = 8, /obj/item/food/pizza/pineapple = 1, /obj/item/food/burger/baconburger = 10, /obj/item/food/pancakes = 4),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/b52 = 6, /datum/reagent/consumable/ethanol/manhattan = 3, /datum/reagent/consumable/ethanol/atomicbomb = 1, /datum/reagent/consumable/ethanol/beer = 25))


	found_seat_lines = list("I hope there's a seat that supports my weight.", "I hope I can bring my gun in here.", "I hope they have the triple deluxe fatty burger.", "I just love the culture here.")
	cant_find_seat_lines = list("I'm so tired from standing...", "I have chronic back pain, please hurry up and get me a seat!", "I'm not going to tip if I don't get a seat.")
	leave_mad_lines = list("NO TIP FOR YOU. GOODBYE!", "At least at SpaceDonalds they serve their food FAST!", "This venue is horrendous!", "I will speak to your manager!", "I'll be sure to leave a bad Yelp review.")
	leave_happy_lines = list("An extra tip for you my friend.", "Thanks for the great food!", "Diabetes is a myth anyway!")
	wait_for_food_lines = list("Listen buddy, I'm getting real impatient over here!", "I've been waiting for ages...")


/datum/customer_data/italian
	nationality = "Space-Italian"
	prefix_file = "strings/names/italian_prefix.txt"
	base_icon = "italian"
	clothing_sets = list("italian_pison", "italian_godfather")

	found_seat_lines = list("What a wonderful place to sit.", "I hope they serve it like-a my momma used to make it.")
	cant_find_seat_lines = list("Mamma mia! I just want a seat!", "Why-a you making me stand here?")
	leave_mad_lines = list("I have-a not seen-a this much disrespect in years!", "What-a horrendous establishment!")
	leave_happy_lines = list("That's amoreee!", "Just like momma used to make it!")
	wait_for_food_lines = list("I'ma so hungry...")
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/spaghetti/pastatomato = 20, /obj/item/food/spaghetti/copypasta = 6, /obj/item/food/spaghetti/meatballspaghetti = 4, /obj/item/food/pizza/vegetable = 2, /obj/item/food/pizza/mushroom = 2, /obj/item/food/pizza/meat = 2, /obj/item/food/pizza/margherita = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/fanciulli = 5, /datum/reagent/consumable/ethanol/branca_menta = 3, /datum/reagent/consumable/ethanol/beer = 10, /datum/reagent/consumable/lemonade = 8, /datum/reagent/consumable/ethanol/godfather = 5))


/datum/customer_data/french
	nationality = "Space-French"
	prefix_file = "strings/names/french_prefix.txt"
	base_icon = "french"
	clothing_sets = list("french_fit")
	found_seat_lines = list("Hon hon hon", "It's not the Eiffel tower but it will do.", "Yuck, I guess this will make do.")
	cant_find_seat_lines = list("Making someone like me stand? How dare you.", "What a filthy lobby!")
	leave_mad_lines = list("Sacre bleu!", "Merde! This place is shittier than the Rhine!")
	leave_happy_lines = list("Hon hon hon.", "A good effort.")
	wait_for_food_lines = list("Hon hon hon")
	speech_sound = 'sound/creatures/tourist/tourist_talk_french.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/baguette = 20, /obj/item/food/garlicbread = 5, /obj/item/food/soup/onion = 4, /obj/item/food/pie/berryclafoutis = 2, /obj/item/food/omelette = 15),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/champagne = 15, /datum/reagent/consumable/ethanol/mojito = 5, /datum/reagent/consumable/ethanol/sidecar = 5, /datum/reagent/consumable/ethanol/between_the_sheets = 4, /datum/reagent/consumable/ethanol/beer = 10))

/datum/customer_data/french/get_overlays(mob/living/simple_animal/robot_customer/customer)
	if(customer.ai_controller.blackboard[BB_CUSTOMER_LEAVING])
		var/mutable_appearance/flag = mutable_appearance(customer.icon, "french_flag")
		flag.appearance_flags = RESET_COLOR
		return flag



/datum/customer_data/japanese
	nationality = "Space-Japanese"
	prefix_file = "strings/names/japanese_prefix.txt"
	base_icon = "japanese"
	clothing_sets = list("japanese_animes")

	found_seat_lines = list("Konnichiwa!", "Arigato gozaimasuuu~", "I hope there's some beef stroganoff...")
	cant_find_seat_lines = list("I want to sit under the cherry tree already, senpai!", "Give me a seat before my Tsundere becomes Yandere!", "This place has less seating than a capsule hotel!", "No place to sit? This Shokunin is so cold...")
	leave_mad_lines = list("I can't believe you did this! WAAAAAAAAAAAAAH!!", "I-It's not like I ever wanted your food! B-baka...", "I was gonna give you my tip!")
	leave_happy_lines = list("Oh NOURISHMENT PROVIDER! This is the happiest day of my life. I love you!", "I take a potato chip.... AND EAT IT!", "Itadakimasuuu~", "Gochisousama desu!")
	wait_for_food_lines = list("No food yet? I guess it can't be helped.", "I can't wait to finally meet you burger-sama...", "Give me my food, you meanie!")
	speech_sound = 'sound/creatures/tourist/tourist_talk_japanese1.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/tofu = 5, /obj/item/food/breadslice/plain = 5, /obj/item/food/soup/milo = 10, /obj/item/food/soup/vegetable = 4, /obj/item/food/sashimi = 4, /obj/item/food/chawanmushi = 4, /obj/item/food/muffin/berry = 2, /obj/item/food/beef_stroganoff = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/sake = 8, /datum/reagent/consumable/cafe_latte = 6, /datum/reagent/consumable/ethanol/aloe = 6, /datum/reagent/consumable/chocolatepudding = 4, /datum/reagent/consumable/tea = 4, /datum/reagent/consumable/cherryshake = 1, /datum/reagent/consumable/ethanol/bastion_bourbon = 1))

/datum/customer_data/japanese/get_overlays(mob/living/simple_animal/robot_customer/customer)
	//leaving and eaten
	if(type == /datum/customer_data/japanese && customer.ai_controller.blackboard[BB_CUSTOMER_LEAVING] && customer.ai_controller.blackboard[BB_CUSTOMER_EATING])
		var/mutable_appearance/you_won_my_heart = mutable_appearance('icons/effects/effects.dmi', "love_hearts")
		you_won_my_heart.appearance_flags = RESET_COLOR
		return you_won_my_heart

/datum/customer_data/japanese/salaryman
	clothing_sets = list("japanese_salary")

	found_seat_lines = list("I wonder if giant monsters attack here too...", "Hajimemashite.", "Konbanwa.", "Where's the conveyor belt...")
	cant_find_seat_lines = list("Please, a seat. I just want a seat.", "I'm on a schedule here. Where is my seat?", "...I see why this place is suffering. They won't even seat you.")
	leave_mad_lines = list("This place is just downright shameful, and I'm telling my coworkers.", "What a waste of my time.", "I hope you don't take pride in the operation you run here.")
	leave_happy_lines = list("Thank you for the hospitality.", "Otsukaresama deshita.", "Business calls.")
	wait_for_food_lines = list("Zzzzzzzzzz...", "Dame da ne~", "Dame yo dame na no yo~")
	speech_sound = 'sound/creatures/tourist/tourist_talk_japanese2.ogg'
	orderable_objects = list(
	/datum/venue/restaurant = list(/obj/item/food/tofu = 5, /obj/item/food/soup/milo = 6, /obj/item/food/soup/vegetable = 4, /obj/item/food/sashimi = 4, /obj/item/food/chawanmushi = 4, /obj/item/food/meatbun = 4, /obj/item/food/beef_stroganoff = 2),
	/datum/venue/bar = list(/datum/reagent/consumable/ethanol/beer = 14, /datum/reagent/consumable/ethanol/sake = 9, /datum/reagent/consumable/cafe_latte = 3, /datum/reagent/consumable/coffee = 3, /datum/reagent/consumable/soy_latte = 3, /datum/reagent/consumable/ethanol/atomicbomb = 1))

/datum/customer_data/moth
	nationality = "Mothman"
	prefix_file = "strings/names/moth_prefix.txt"
	found_seat_lines = list("Give me your hat!", "Moth?", "Certainly an... interesting venue.")
	cant_find_seat_lines = list("If I can't find a seat, I'm flappity flapping out of here quick!", "I'm trying to flutter here!")
	leave_mad_lines = list("I'm telling all my moth friends to never come here!", "Zero star rating, even worse than that time I ate a mothball!","Closing down permanently would still be too good of a fate for this place.")
	leave_happy_lines = list("I'd tip you my hat, but I ate it!", "I hope that wasn't a collectible!", "That was the greatest thing I ever ate, even better than Guanaco!")
	wait_for_food_lines = list("How hard is it to get food here? You're even wearing food yourself!", "My fuzzy robotic tummy is rumbling!", "I don't like waiting!")

	speech_sound = 'sound/creatures/tourist/tourist_talk_moth.ogg'

	// Always asks for the clothes that you have on, but this is a fallback.
	orderable_objects = list(
		/datum/venue/restaurant = list(
			/obj/item/clothing/head/chefhat = 3,
			/obj/item/clothing/shoes/sneakers/black = 3,
			/obj/item/clothing/gloves/color/black = 1,
		),
	)

// The whole gag is taking off your hat and giving it to the customer.
// If it takes any more effort, it loses a bit of the comedy.
// Therefore, only show up if it's reasonable for that gag to happen.
/datum/customer_data/moth/can_use(datum/venue/venue)
	return !isnull(get_dynamic_order(venue))

/datum/customer_data/moth/chosen(datum/venue/venue)
	. = ..()

	// Only show up once, again for the purposes of keeping the comedic value.
	// Also prevents the unlikely, but possible, that you keep getting the extremely easy to satisy
	// moth bots, which isn't as fun as completing real orders.
	venue.customer_types[type] = 0

/datum/customer_data/moth/proc/get_dynamic_order(datum/venue/venue)
	var/mob/living/carbon/buffet = venue.restaurant_portal?.turned_on_portal?.resolve()
	if (!istype(buffet))
		return

	var/list/orderable = list()

	if (!QDELETED(buffet.head))
		orderable[buffet.head] = 5

	if (!QDELETED(buffet.gloves))
		orderable[buffet.gloves] = 5

	if (!QDELETED(buffet.shoes))
		orderable[buffet.shoes] = 1

	if (orderable.len)
		var/datum/order = pickweight(orderable)
		return order.type

/datum/customer_data/moth/get_order(datum/venue/venue)
	var/dynamic_order = get_dynamic_order(venue)

	// Fall back to basic clothing.
	return dynamic_order || ..()
