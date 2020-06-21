/datum/team/frost_moths
	name = "Frost Moths"
	show_roundend_report = FALSE
	var/list/players_spawned = new

/datum/antagonist/frost_moth
	name = "Frost Moth"
	job_rank = ROLE_ICE_MOON
	show_in_antagpanel = FALSE
	show_to_ghosts = TRUE
	prevent_roundtype_conversion = FALSE
	antagpanel_category = "Frost Moths"
	var/datum/team/frost_moths/team

/datum/antagonist/frost_moth/create_team(datum/team/new_team)
	if (new_team)
		team = new_team
		objectives |= new_team.objectives
	else
		team = new

/datum/antagonist/frost_moth/get_team()
	return team

/datum/antagonist/frost_moth/on_gain()
	RegisterSignal(owner.current, COMSIG_LIVING_EDIBLE_EATEN, .proc/alert_eaten_clothing)
	..()

/datum/antagonist/frost_moth/on_removal()
	UnregisterSignal(owner.current, COMSIG_LIVING_EDIBLE_EATEN)
	..()

/datum/antagonist/frost_moth/proc/alert_eaten_clothing(mob/eater, obj/item/reagent_containers/food/snacks/clothing/food)
	if (istype(food) && food.original_clothing)
		if (food.original_clothing.obj_integrity == food.original_clothing.max_integrity)
			to_chat(eater, "<span class='warning'>As you bite into \the [food], you recognize that this is no longer a worthy offering to the loom.</span>")
