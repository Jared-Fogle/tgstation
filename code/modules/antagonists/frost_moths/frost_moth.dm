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
